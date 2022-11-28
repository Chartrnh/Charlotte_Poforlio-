## Analysis Outline

1. Simplify the variables  

Going into this dataset, we will follow a big assumption that every outer factor has a direct and/or indirect effect on our daily meal of choice. Since we are predicting the result based on their combined impact, it's efficient to just refer to our response variable as "Y" and our 15 explanatory variables as X1-X15.

Later on, we can refer back to any particular factor if needed. 

2. Set up training data and validate data using a 10-fold CV

As we expressed earlier in the Project Overview, OVERFITTING is the one main concern that needs to be taken into consideration when fitting models. If we chase after extreme observation or use too complicated models, we will risk high MSPE value from huge variance for the sake of minimizing bias. Therefore, to minimize this threat, we will set various training-validating data within the given dataset itself. 

3. Create a For loop 

Precisely, the given observables will be divided into 10 groups and in the For loop of 10, we will fit and test models on each of them. The group chosen as training data will be used to fit different models and the result will be tested on the rest of the dataset, which is also called validating data to calculate its Mean Squared Prediction Errors (MSPE). 

4. Generate MSPE Boxplot 
 
After going through the loop, a table of MSPE values for each group and each machine will be generated and a visualization will be drawn to access each model's performance. A model with low errors and narrow variance will be considered.

## Mean Squared Prediction Error and its Boxplot visualization

I looked at the distributions of MSPE value for each machine and the value counts for the various variables. Below are a few highlights from the result table and boxplot.


![image](https://user-images.githubusercontent.com/108549500/195474174-c3ab60f1-6c1a-4d53-8984-920a5030c059.png)

![image](https://user-images.githubusercontent.com/108549500/195474667-8de4b527-dc42-453a-9fff-b8c9292d7eab.png)                        ![image](https://user-images.githubusercontent.com/108549500/195474757-37981107-1e72-4c2a-bb2b-4dc708226d73.png)

As we can see from the boxplot, GAM or the s Generalized Addictive Model stands out not only because of its lowest average MSPE value but also its narrow distribution across the value. Seemingly from this analysis and the pattern we are attempting to make, GAM is a relatively good model that balances between the two factors bias and variance. 

Therefore, we will proceed with GAM as our model for future prediction. 

## Prediction
With the conclusion of GAM being our suitest model, I move on with picking the dataset to train the model with. Picking the whole dataset would be an easy choice due to its straightforward process. However, I did go a step further with using the training set that I used before and selected the GAM with the lowest MSPE value when tested with the evaluating set. 

![image](https://user-images.githubusercontent.com/108549500/195496821-857f8ced-b938-4281-ae89-99176c725f94.png)

The model with the lowest MSPE value will be chosen to be the optimal model for the whole dataset and as we can see using the seventh fold as a training set will be beneficial in this case. From here, the prediction will be drawn and shown on the 2-D graph below alongside its actual value. We are looking for a prediction with a percentage accuracy of 85%

![image](https://user-images.githubusercontent.com/108549500/195496200-c676eb0e-692a-40ef-b5be-7baa3685ca28.png)








