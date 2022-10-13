library(tidyverse)
library(rpart)
library(mgcv)
library(MASS)   
library(glmnet)


data <- read_csv("Data2020.csv")
View(data)

# Rename variable for simplification 

data <- rename(data, Y= 'Meal cost')
for (i in 2:14){
  xx <- paste("X", i-1, sep = "")
  colnames(data)[i] <- xx
}

get.folds = function(n, V){
  n.fold = ceiling(n / V) 
  fold.ids.raw = rep(1:V, times = n.fold)
  fold.ids = fold.ids.raw[1:n] 
  
  folds.rand = fold.ids[sample.int(n)]
  
  return(folds.rand)
}

#  Set up 10-fold CV and table of MSPE for easy acess
V=10
n=nrow(data)
folds=get.folds(n,V)
max.terms=5

MSPE=matrix(NA, nrow=V, ncol=10)
colnames(MSPE)=c("LS", "Hybrid Stepwise ", "Ridge", "LASSO-min", "LASSO-1se", "GAM", "PPR", 
                 "Full tree", "tree-min", "tree-1se")

# Set up For loop for model training and testing
for (v in 1:V) {
  data.train=data[folds!=v,]
  data.valid=data[folds==v,]
  Y.valid = data.valid$Y
  
  lm = lm(Y~., data=data.train)
  
  initial.1 <- lm(data=data.train, formula=Y~ 1)
  final.1 <- lm(data=data.train, 
                formula=Y~.)
  step1 <- step(object=initial.1, scope=list(upper=final.1), 
                k = log(nrow(data.train)))
  
  lambda.vals = seq(from = 0, to = 100, by = 0.05)
  ridge <- lm.ridge(Y ~., lambda = lambda.vals, data=data.train)
  ind.min.GCV = which.min(ridge$GCV)
  lambda.min = lambda.vals[ind.min.GCV]
  all.coefs.ridge = coef(ridge)
  coef.min = all.coefs.ridge[ind.min.GCV,]
  matrix.valid.ridge = model.matrix(Y ~., data = data.valid)
  
  
  
  matrix.train.raw = model.matrix(Y ~ ., data = data.train)
  matrix.train = matrix.train.raw[,-1]
  all.LASSOs = cv.glmnet(x = matrix.train, y = data.train$Y)
  lambda.min = all.LASSOs$lambda.min
  lambda.1se = all.LASSOs$lambda.1se
  
 
  gam.all <- gam(data=data.train, formula=Y~s(X1)+s(X2)+s(X3)+s(X4,k=length(unique(data.train$X4)))+s(X5)+s(X6)+
                   s(X7)+s(X8)+s(X9)+s(X10, k=length(unique(data.train$X10)))+s(X11)+s(X12, k=length(unique(data.train$X12)))+s(X13)+s(X14)+s(X15),
                 family=gaussian(link=identity))
  
  pr.tree <- rpart(Y ~ ., method="anova", data=data.train)
  pr.tree$cptable[,c(2:5,1)]
  cpt <- pr.tree$cptable
  minrow <- which.min(cpt[,4])
  minrow
  cplow.min <- cpt[minrow,1]
  cplow.min
  cpup.min <- ifelse(minrow==1, yes=1, no=cpt[minrow-1,1])
  cp.min <- sqrt(cplow.min*cpup.min)
  
  se.row <- min(which(cpt[,4] < cpt[minrow,4]+cpt[minrow,5]))
  
  cplow.1se <- cpt[se.row,1]
  cpup.1se <- ifelse(se.row==1, yes=1, no=cpt[se.row-1,1])
  cp.1se <- sqrt(cplow.1se*cpup.1se)
  
  pr.prune.min <- prune(pr.tree, cp=cp.min)
  pr.prune.1se <- prune(pr.tree, cp=cp.1se)
  
  
  pred.lm = predict(lm, newdata=data.valid)
  pred.step = predict(step1, newdata=data.valid)
  pred.ridge = matrix.valid.ridge %*% coef.min
  
  matrix.valid.LASSO.raw = model.matrix(Y ~ ., data = data.valid)
  matrix.valid.LASSO = matrix.valid.LASSO.raw[,-1]
  pred.LASSO.min = predict(all.LASSOs, newx = matrix.valid.LASSO,
                           s = lambda.min, type = "response")
  pred.LASSO.1se = predict(all.LASSOs, newx = matrix.valid.LASSO,
                           s = lambda.1se, type = "response")
  
  pred.gam = predict(gam.all, newdata=data.valid)
  
  pred.all.tree = predict(pr.tree, newdata=data.valid)
  pred.min.tree = predict(pr.prune.min, newdata=data.valid)
  pred.1se.tree = predict(pr.prune.1se, newdata=data.valid)
  
  MSPE[v,1] = mean((Y.valid-pred.lm)^2)
  MSPE[v,2] = mean((Y.valid-pred.step)^2)
  MSPE[v,3] = mean((Y.valid-pred.ridge)^2)
  MSPE[v,4] = mean((Y.valid-pred.LASSO.min)^2)
  MSPE[v,5] = mean((Y.valid- pred.LASSO.1se)^2)
  MSPE[v,6] = mean((Y.valid-pred.gam)^2)
  MSPE[v,8] = mean((Y.valid-pred.all.tree)^2)
  MSPE[v,9] = mean((Y.valid-pred.min.tree)^2)
  MSPE[v,10] = mean((Y.valid-pred.1se.tree)^2)
  
  K.ppr=5
  n.train = nrow(data.train)
  folds.ppr = get.folds(n.train, K.ppr)
  
  MSPE.cv = array(0, dim = c(max.terms, K.ppr))
  
  for (k in 1:K.ppr) {
    
    train.ppr = data.train[folds.ppr != k,]
    valid.ppr = data.train[folds.ppr == k,] 
    Y.valid.ppr = valid.ppr$Y
    
    
    ppr1.cv <- ppr(data=train.ppr, Y~., max.term=5, nterms=1, 
                   sm.method="gcvspline")
    ppr2.cv <- ppr(data=train.ppr, Y~., max.term=5, nterms=2, 
                   sm.method="gcvspline")
    ppr3.cv <- ppr(data=train.ppr, Y~., max.term=5, nterms=3, 
                   sm.method="gcvspline")
    ppr4.cv <- ppr(data=train.ppr, Y~., max.term=5, nterms=4, 
                   sm.method="gcvspline")
    ppr5.cv <- ppr(data=train.ppr, Y~., max.term=5, nterms=5, 
                   sm.method="gcvspline")
    
    pred1.cv = predict(ppr1.cv, newdata=valid.ppr)
    pred2.cv = predict(ppr2.cv, newdata=valid.ppr)
    pred3.cv = predict(ppr3.cv, newdata=valid.ppr)
    pred4.cv = predict(ppr4.cv, newdata=valid.ppr)
    pred5.cv = predict(ppr5.cv, newdata=valid.ppr)
    
    MSPE.cv[1,k] = mean((Y.valid.ppr-pred1.cv)^2)
    MSPE.cv[2,k] = mean((Y.valid.ppr-pred2.cv)^2)
    MSPE.cv[3,k] = mean((Y.valid.ppr-pred3.cv)^2)
    MSPE.cv[4,k] = mean((Y.valid.ppr-pred4.cv)^2)
    MSPE.cv[5,k] = mean((Y.valid.ppr-pred5.cv)^2)
  }
  
  ave.MSPE.ppr = apply(MSPE.cv, 1, mean)
  best.terms = which.min(ave.MSPE.ppr)
  best.terms
  fit.ppr.best = ppr(Y ~ ., data = data.train,
                     max.terms = max.terms, nterms = best.terms, sm.method = "gcvspline")
  
  pred.ppr.best = predict(fit.ppr.best, data.valid)
  MSPE.ppr.best = mean((Y.valid- pred.ppr.best)^2) 
  
  MSPE[v, 7] = MSPE.ppr.best
  
}

#Generate MSPE value table and boxplot
View(MSPE)

summary(MSPE)
x11(h=7, w=10)
par(mfrow=c(1,3))
boxplot(MSPE, las=2, ylim=c(1,3), main="MSPE of 10 fold for different methods")

x11(h=7, w=10)
low2=apply(MSPE, 1, min)
par(mfrow=c(1,3))
boxplot(MSPE/low2, las=2.5, main="Relative MSPE of 10 fold for different methods" )

# As GAM turns out to be our optimal model
# Find the most optimal loop for GAM training and get prediction

get.folds = function(n, V){
  n.fold = ceiling(n / V) 
  fold.ids.raw = rep(1:V, times = n.fold)
  fold.ids = fold.ids.raw[1:n] 
  
  folds.rand = fold.ids[sample.int(n)]
  
  return(folds.rand)
}

V=10
n=nrow(data)
folds=get.folds(n,V)

MSPE.gam=matrix(NA, nrow=V, ncol=1)
colnames(MSPE.gam)=c("GAM")

for (v in 1:V) {
  data.train=data[folds!=v,]
  data.valid=data[folds==v,]
  Y.valid = data.valid$Y
  
gam.all <- gam(data=data.train, formula=Y~s(X1)+s(X2)+s(X3)+s(X4,k=length(unique(data.train$X4)))+s(X5)+s(X6)+s(X7)+s(X8)+s(X9)+s(X10, k=length(unique(data.train$X10)))+s(X11)+s(X12, k= length(unique(data.train$X12)))+s(X13),  family=gaussian(link=identity))
pred.gam = predict(gam.all, newdata=data.valid)
MSPE.gam[v,1] = mean((Y.valid-pred.gam)^2)
}

MSPE.gam
x <- which.min(MSPE.gam[,1])
x
gam.all <- gam(data=data[folds!=x,], formula=Y~s(X1)+s(X2)+s(X3)+s(X4,k=length(unique(data.train$X4)))+
                 s(X5)+s(X6)+s(X7)+s(X8)+s(X9)+s(X10, k=length(unique(data.train$X10)))+
                 s(X11)+s(X12, k= length(unique(data.train$X12)))+s(X13),  family=gaussian(link=identity))

prediction <- predict(gam.all, data.t)

# Graph the visualization for the prediction and actual value

data.t <- read.csv("Data2020testX.csv")
actual <- read.csv("result.csv")
for (i in 1:13){
  xx <- paste("X", i, sep = "")
  colnames(data.t)[i] <- xx
}

x <- 1:750
x11(h=7, w=10)
plot(x, y=prediction, col="red", pch=23, main = "Scatter plot of actual vs prediction value")
points(x, y = actual)
legend(1, 13.5, legend=c("Actual", "Prediction"),
       col=c("black", "red"), lty=3:4, cex=1, bg="white")





