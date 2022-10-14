# Filename:Lab2.py
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
    #a. Import data(VandelaySales2015.csv) into a Pandas dataframe
    FILENAME = "VandelaySales2015.csv"
    df = pd.read_csv(FILENAME,encoding="utf-8")
    print('VandelaySales2015 data are following:\n',df)
    print(dash)
    # check if file has missing values
    print("\n Any null values?")
    print(df.isnull().any())
    print(dash)
    print(df.isnull().sum())
    print(dash)
    print(df.info())
    print(dash)
    #a. print head for top 10 record only for the dataframe call it "df"
    print('A. Top 10 record of VandelaySales2015 are following:\n',df.head(10))
    print(dash)

    #b. Find the sum, mean, max, min value of total_product_price (COLUMN I) of VandelaySales2015.csv file.
    print('B. The sum, mean, max, min value of total_product_price are following:\n',df['total_product_price'].describe())
    print(dash)

    #c. Show correlation
    print('C. The correlations between variables are following:\n',df.corr())
    print(dash)
    # show corr in heatmap
    dataplot = sn.heatmap(df.corr(),
                          cmap='YlGnBu',
                          annot=True)
    plt.show()

    #d. Show distribution analysis Histogram for item_product_price(COLUMN H) of VandelaySales2015.csv file.
    plt.hist(df['item_product_price'],
             bins=15,
             color='steelblue',
             edgecolor='k',
             label='Histogram')
    plt.title("D. Distribution analysis Histogram for item_product_price")
    plt.ylabel("Frequency for item_product_price")
    plt.xlabel("Bins")
    plt.show()

#starting point... launch
# __name__ is predefined class attribute
if __name__ == '__main__':
    main()