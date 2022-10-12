## Side note
As for project's topic, I figure that it is consequential to choose ones that showcase each essential steps of the data analysis process, which are: 
- Ask 
- Prepare 
- Process
- Analyse
- Share 
- Act 

Out of the six phases, Analyze is the one part that demands both knowledge and practical skills to achieve due to its nature of unpredictability. It entails using tools to format, transform data , identify pattern, and draw conclusion. To choose the closest model, it cannot solely base on its fittingness on existing data, but also on the future data that is not yet collected. if a model is running too close with the existing data, we are running the risk of overfitting which just simply implies its vulnerability to extreme future variance. However, if too simple of a model is chosen, it will result in high error. That is also the concept of bias-variance trade off that we will have to keep in mind when dealing different machinery. 

As for now, to tackle the complexity of this matter, I will start off with a topic that is just about model selections. The chosen dataset will only have one variable and 3000 observations and the objective of this project is to only focus on that particular variable and find the most suitable prediction model for it. 

The data will be collected from the Island - a virtual simulation of human population that has been developed to support learning and teaching in experimental design, epidemiology and statistical reasoning. These simulated islanders will be asked a simple question of how much they spend on a meal and we will use the data to predict individual spending on food and its pattern.

Since we are choosing the most basic form of data, the processing phase will be quick as we collect it for a single purpose. Not much testing and cleaning will be needed. We will only concentrate on the Analyzing part for this one. 


# Topic: What is the fittiest machine? - Project Overview
- Gathered data from simulated islanders using one question
- Used 10-fold Cross Valuation to set up 10 sets of training data and validating data 
- Calculated Mean Squared Prediction Error (MSPE) and drawed its distribution on boxplot based on each type of model and training-validating set we attempt to fit 
- Chose the model with lowest MSPE and narrowest shape in boxplot 
- Used the chosen model as our prediction machine to estimate pattern.

## Code and Resources Used
**R version**: 4.0.4 (2021-02-15)  
**Packages**: tidyverse, rpart, mgcv, MASS, glmnet.  
**Reference book**: An Introduction to Statistical Learning with Applications in R by *Gareth James, Daniela Witten, Trevor Hastie, Robert Tibshirani   
**Link**: https://static1.squarespace.com/static/5ff2adbe3fe4fe33db902812/t/6009dd9fa7bc363aa822d2c7/1611259312432/ISLR+Seventh+Printing.pdf

## MODELS
- Linear Regression Line
- Hybrid Stepwise
- Ridge Regression
- LASSO using CV with the 1SE min rule for its λ
- Generalized Addictive Models 
- Projection Pursuit Regression with numbers of terms up to 5
- Full regression tree 
- Regression tree using CV with 1SE and min optimal pruning


