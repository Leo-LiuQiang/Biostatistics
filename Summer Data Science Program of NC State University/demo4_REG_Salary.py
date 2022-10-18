# Filename:demo4_REG_Salary.py
# Date: 07/20/2022
# Qiang Liu
# NCSU-GTI Summer 2022 Data Science
#------------------import library---------------------
import sys
import math
import os,io,csv

#------------------Data Science library---------------
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sn

#------------------global variables-------------------
dash = "-" * 80
print(dash)

def main():
    print("Start Program.....")
    #print(pd.__doc__)
    #read the Salary Data file
    FILENAME = "Salary_Data.csv"
    df = pd.read_csv(FILENAME,encoding="latin1")
    #or utf-8
    print(df)
    print(dash)
    print(df.info())
    print(dash)
    print(df.head(8))
    print(dash)
    print(df.tail(3))
    print(dash)
    print(df.describe())
    print(dash)
    print(df.corr())
    #show corr in heatmap
    dataplot = sn.heatmap(df.corr(),
                          cmap='YlGnBu',
                          annot=True)
    plt.show()

    #histogram
    plt.hist(df['Salary'],bins=15)
    plt.title("Histogram for Salary")
    plt.ylabel("Frequency for Salary")
    plt.xlabel("Bins")
    plt.show()

    #box plot using plt
    plt.boxplot(df['Salary'],showmeans=True)
    #skew to the right
    plt.xlabel('Salary Values')
    plt.title('Box plot for Historical Salaries')
    plt.grid()
    plt.show()
    print(dash)

    #check if you have missing values
    print("\n Any null values?")
    print(df.isnull().any())
    print(df.isnull().sum())
    print(dash)

    #identify your x features (indep variables)
    #identify y target
    x = df.iloc[:,:-1].values
    y = df.iloc[:,1].values
    print("x\n",x)
    print("y\n",y)

    #skew
    #install scipy
    import scipy
    from scipy.stats import skew
    print("\nSkewness for data",skew(df['Salary']))
    #split the data
    import sklearn
    from sklearn.model_selection import train_test_split
    x_train,x_test,y_train,y_test=train_test_split(x,y,test_size=1/3,random_state=5)
    print(dash)
    print("x_train",x_train.size)
    print("x_test",x_test.size)

    #model?Supervised
    from sklearn.linear_model import LinearRegression
    model1 = LinearRegression()
    model1.fit(x_train,y_train)
    print("R2",model1.score(x_train,y_train))
    print("Model Coeff (slop)",model1.coef_)
    print("Model intercept (b)",model1.intercept_)
    #Y = 27334.81 + 9213.15 * X
    #PredictedSalary = 27334.81 + 9213.15 * YearsOfExperience

    #plot regression model using seaborn
    sn.jointplot(x="YearsExperience",
                 y="Salary",
                 data=df,
                 kind='reg',
                 fit_reg=True)
    plt.show()

    #scatter
    sn.jointplot(x="YearsExperience",
                 y="Salary",
                 data=df)
    plt.show()

    #density
    sn.jointplot(x="YearsExperience",
                 y="Salary",
                 data=df,
                 kind='kde')
    plt.show()

    #using another model OLS (Ordinary Least Squares Regression)
    print(dash)
    import statsmodels.api as sm
    import statsmodels.formula.api as smf
    x_train2=sm.add_constant((x_train))
    model2 = sm.OLS(y_train,x_train2).fit()
    print(model2.summary())

    #plot OLS Model
    fig1 = plt.figure(figsize=(6,6))
    model3 = smf.ols('YearsExperience ~ Salary',data=df).fit()
    sm.graphics.plot_regress_exog(model3,'Salary',fig=fig1)
    plt.show()
    #https: // www.statsmodels.org / dev / generated / statsmodels.graphics.regressionplots.plot_regress_exog.html
    #CCPR(component and component - plus - residual)


#starting point... launch
# __name__ is predefined class attribute
if __name__ == '__main__':
    main()