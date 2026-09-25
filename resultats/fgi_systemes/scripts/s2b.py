import pandas as pd,numpy as np
from s2feat import *
from sklearn.tree import DecisionTreeClassifier, export_text
m=m1(); m=m[m.index>='2020-10-01']; F=feats(m)
tr=pd.read_csv('s2_trades.csv',parse_dates=['t_in','t_out']); f=pd.read_csv('s2_first.csv',parse_dates=['t_in','t_out'])
lab,flat=flat_labels(m.index,f,tr); flat&=(m.index>='2021-01-04')
X=F[flat].dropna(); y=lab.reindex(X.index)
print(len(X),y.sum())
X.to_pickle('s2X.pkl'); y.to_pickle('s2y.pkl')
t=DecisionTreeClassifier(max_depth=5,min_samples_leaf=20,class_weight={0:1,1:300}).fit(X,y)
print(export_text(t,feature_names=list(X.columns),show_weights=True))
