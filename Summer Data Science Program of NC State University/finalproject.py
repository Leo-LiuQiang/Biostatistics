# Filename:Final project.py
# Date: 07/22/2022
# NCSU-GTI Summer 2022 Data Science
#------------------import library---------------------
import pandas as pd
import numpy as np
import scipy
from scipy.stats import skew
import sklearn as sl
import matplotlib.pyplot as plt
from datetime import datetime

#------------------global variables-------------------
dash = "-" * 80
print(dash)

sap = pd.read_csv('SAP.csv')
ift = pd.read_csv('iFlytek.csv')

sap = pd.Series(data = sap['Adj.Close'].values.tolist(),index = sap['Date'])
ift = pd.Series(data = ift['Adj.Close'].values.tolist(),index = ift['Date'])

from sklearn.linear_model import LinearRegression

def Line_Trend_Model(s,):
    res = {}
    n = len(s)
    m = 2
    res['t'] = [ i+1 for i in range(n)]
    avg_t = np.mean(res['t'])
    avg_y = np.mean(s)
    ly = sum( map(lambda x,y:x * y, res['t'], s )) - n * avg_t * avg_y
    lt = sum( map(lambda x:x**2, res['t'])) - n * avg_t ** 2
    res['b'] = ly/lt
    res['a'] = avg_y - res['b'] * avg_t
    pre_y = res['a'] + res['b'] * np.array(res['t'])
    res['sigma'] = np.sqrt(sum(map(lambda x,y:(x - y)**2, s, pre_y ))/(n-m))
    return res

param_sap = Line_Trend_Model(sap)
pre_sap = param_sap['a']+ param_sap['b']* np.array(param_sap['t'])
residual_sap = sap - pre_sap
db_sap = pd.DataFrame([param_sap['t'],sap,list(pre_sap),list(residual_sap),list(residual_sap**2)],index = ['t','Y(‰)','Trend','Residual','R sqare'],columns = sap.index).T
rsquare_sap = sum((pre_sap - np.mean(sap))**2)/sum((sap - np.mean(sap))**2)
print(rsquare_sap)
print(dash)

param_ift = Line_Trend_Model(ift)
pre_ift = param_ift['a']+ param_ift['b']* np.array(param_ift['t'])
residual_ift = ift - pre_ift
db_ift = pd.DataFrame([param_ift['t'],ift,list(pre_ift),list(residual_ift),list(residual_ift**2)],index = ['t','Y(‰)','Trend','Residual','R sqare'],columns = ift.index).T
rsquare_ift = sum((pre_ift - np.mean(ift))**2)/sum((ift - np.mean(ift))**2)
print(rsquare_ift)
print(dash)

fig = plt.figure(figsize = (12,8))
db_sap['Y(‰)'].plot(style = ':',label = 'SAP')
db_sap['Trend'].plot(style = '-',label = 'SAP Trend')
db_ift['Y(‰)'].plot(style = ':',label = 'iFlytek')
db_ift['Trend'].plot(style = '-',label = 'iFlytek Trend')
plt.grid(axis = 'y')
plt.title('Trend')
plt.legend(loc='upper left')
plt.show()