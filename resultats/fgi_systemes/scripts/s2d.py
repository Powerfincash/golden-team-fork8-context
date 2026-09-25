import pandas as pd,numpy as np
from sklearn.ensemble import HistGradientBoostingClassifier
from sklearn.metrics import precision_recall_curve
X=pd.read_pickle('s2X.pkl'); y=pd.read_pickle('s2y.pkl')
cut=X.index<'2023-01-01'
# subsample negatives for speed
rng=np.random.default_rng(0); keep=(y==1)|(rng.random(len(y))<0.1)
Xa,ya=X[cut&keep],y[cut&keep]
g=HistGradientBoostingClassifier(max_iter=300,learning_rate=0.05,class_weight='balanced').fit(Xa,ya)
p=g.predict_proba(X[~cut])[:,1]; yy=y[~cut].values
pr,rc,th=precision_recall_curve(yy,p)
f1=2*pr*rc/(pr+rc+1e-9); i=f1.argmax(); print('hors échantillon (minute exacte) : F1 max %.2f précision %.2f rappel %.2f'%(f1[i],pr[i],rc[i]))
# tolerance: positive if within ±15 min of true entry
