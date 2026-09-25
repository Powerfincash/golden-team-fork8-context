import pandas as pd,numpy as np
from feat import *; from evals3 import evalue
from sklearn.tree import DecisionTreeClassifier, export_text
m=barres(); h,F=features(m); c=h.close
for P in [20,50]:
    ma=c.rolling(P).mean(); sd=c.rolling(P).std(); F[f'bb{P}']=((c-ma)/sd).shift(1)
for col in [x for x in F.columns if x.startswith(('dH','dL','pdh','pdl','ret','ma','dop','body','rng'))]: F[col+'_a']=F[col]/F.atr
tr=pd.read_csv('s3_trades.csv',parse_dates=['t_in','t_out'])
lab,flat=etiquettes(h,tr); flat&=h.index.year>=2021
X=F[flat].dropna(); y=lab.reindex(X.index); Fa=F.fillna(0)
cut=pd.Timestamp('2023-01-01')
for depth in [3,4,5,6]:
    t=DecisionTreeClassifier(max_depth=depth,min_samples_leaf=10,class_weight='balanced').fit(X[X.index<cut],y[X.index<cut])
    p=pd.Series(t.predict(Fa),index=F.index)
    b=p==1; s=p==-1
    trA=tr[tr.t_in<cut].reset_index(drop=True); trB=tr[tr.t_in>=cut].reset_index(drop=True)
    print(depth,'in',np.round(evalue(h,trA,b,s),2),'out',np.round(evalue(h,trB,b,s),2))
    if depth==4: print(export_text(t,feature_names=list(X.columns)))
