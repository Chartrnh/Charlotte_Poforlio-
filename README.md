## Side note
As for the first topic, I figure that it is consequential to choose ones that showcase each essential step of the data analysis process, which are: 
- Ask 
- Prepare 
- Process
- Analyze
- Share 
- Act 

Out of the six phases, Analyze is the one part that demands both knowledge and practical skills to achieve due to its nature of unpredictability. It entails using tools to format, transform data, identify a pattern, and draw a conclusion. Choose the closest model, it cannot solely base on its fittingness on existing data, but also its fittingness on future data. If a model is too close to the existing data or shows signs of chasing after extreme outliers, we are running the risk of overfitting which makes it extremely vulnerable to future variance. However, if too simple of a model is chosen, it will result in a high error. That is also the concept of bias-variance trade-off that we will have to keep in mind when dealing with different machinery.

As for now, to tackle the complexity of this matter, I will start with a topic that is just about model selections. Specifically, I will dive into a dataset with 15 explanatory variables and one response variable. The chosen data will attempt to explain the effect that outer factors have on one's choice of meal cost, such as their financial situation, education, number of meals a day, workplace, etc, and how we can predict their choice based on these characteristics. The objective of this project is to only focus on finding the most suitable prediction model for it and use it to test on other datasets.

The data will be collected from the Island - a virtual simulation of the human population that has been developed to support learning and teaching in experimental design, epidemiology, and statistical reasoning. These simulated islanders will be asked a simple question about how much they spend on a meal, followed by some personal questions about their income, working class, and education and we will use the data to predict individual spending on food and its pattern.

# Topic: What is the optimal machine? - Project Overview
- Gathered data from simulated islanders using one question
- Used 10-fold Cross Valuation to set up 10 sets of training data and validate data
- Calculated Mean Squared Prediction Error (MSPE) and drew its distribution on boxplot based on each type of model and training-validating set we attempt to fit
- Chose the model with the lowest MSPE and narrowest shape in the boxplot
- Used the chosen model as our prediction machine to estimate the pattern.

## Code and Resources Used
**R version**: 4.0.4 (2021-02-15)  
**Packages**: tidyverse, rpart, mgcv, MASS, glmnet.  
**Reference book**: An Introduction to Statistical Learning with Applications in R by *Gareth James, Daniela Witten, Trevor Hastie, Robert Tibshirani   
**Link**: https://static1.squarespace.com/static/5ff2adbe3fe4fe33db902812/t/6009dd9fa7bc363aa822d2c7/1611259312432/ISLR+Seventh+Printing.pdf

## Data set
- **Data2020.csv** : training set
- **Data2020testX.csv** : prediction testing set  
*Both are on the file

## Models
- Linear Regression Line
- Hybrid Stepwise
- Ridge Regression
- LASSO using CV with the 1SE min rule for its λ
- Generalized Addictive Models 
- Projection Pursuit Regression with numbers of terms up to 5
- Full regression tree 
- Regression tree using CV with 1SE and min optimal pruning

## Results

We sucessfully generate a boxplot of MSPE distribution throughout models and cross-validation folds.
![image](https://user-images.githubusercontent.com/108549500/195476453-b0ef19b9-6c90-48e8-a19c-133a266a8823.png)
![image](https://user-images.githubusercontent.com/108549500/195476896-8b8089ac-fa38-4ca7-91b5-cec5bb569db4.png)

It's noticeable right away the good performance that comes Generalized Addictive Model.

As we choose GAM to be our optimal machine, the prediction is quickly drawn out with its accuracy upto 90%. Below here is its table and scatterplot.

![image](https://user-images.githubusercontent.com/108549500/195500942-a9145a2e-f794-4cfe-9b4a-4419732d9a0e.png)
![image](https://user-images.githubusercontent.com/108549500/195502148-f6592516-3691-494b-9fd8-7f7ec1aa5b30.png)







