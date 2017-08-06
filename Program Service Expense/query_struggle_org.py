
# coding: utf-8

# In[3]:

import numpy as np
import pandas as pd
import sys,os,time
import matplotlib.pyplot as plt
import seaborn

chartocat={}
chartocat['A']=1
chartocat['B']=2
chartocat['C']=3
chartocat['D']=3
chartocat['E']=4
chartocat['F']=4
chartocat['G']=4
chartocat['H']=4
chartocat['I']=5
chartocat['J']=5
chartocat['K']=5
chartocat['L']=5
chartocat['M']=5
chartocat['N']=5
chartocat['O']=5
chartocat['P']=5
chartocat['Q']=6
chartocat['R']=7
chartocat['S']=7
chartocat['T']=7
chartocat['U']=7
chartocat['V']=7
chartocat['W']=7
chartocat['X']=8
chartocat['Y']=9
chartocat['Z']=10


model_list=np.load('model_list.npy')

#np.array with shape=(n_year,) containing dictionaryies of the model of group i
# model_list[i][j] corresponds to the ratio of SPE_{201i}/SPE_(201{i-1}) in group j
from scipy.stats import norm as G_V

def query(ratio,model):
    logratio=np.log(ratio)
    quantile=G_V.cdf(logratio, loc=model[0], scale=model[1])
    return quantile
        

#example use:

#query(1.1,model_list[0][1])
#outputs the quantile of an organisation in group 1 with ratio of 1.1 for its SPE of 2011 over 2010.
#the result is 
#0.55493653299297774




