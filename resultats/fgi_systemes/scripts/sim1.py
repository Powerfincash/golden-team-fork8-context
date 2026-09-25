import pandas as pd,numpy as np
import sim3
from s2feat import m1
m=m1(); m=m[(m.index>='2020-12-01')&(m.index<'2025-01-01')]
q=m.resample('15min').agg({'open':'first','high':'max','low':'min','close':'last'}).dropna()
top=(m.index.minute%15==0)
rng=np.random.default_rng(3)
V={}
for r in range(3):
    v=np.where(rng.random(len(m))<0.004,np.where(rng.random(len(m))<0.63,1,-1),0); V[f'hasard {r}']=pd.Series(v,m.index).where(top,0)
body=(q.close-q.open)
for k in [2,4]:
    sg=pd.Series(np.where(body>k,1,np.where(body<-k,-1,0)),q.index).shift(1).fillna(0).reindex(m.index).fillna(0)
    V[f'suite bougie M15 >{k}$']=sg.where(top,0); V[f'contre bougie M15 >{k}$']=(-sg).where(top,0)
for spr in [0.15,0.25,0.35]:
    sim3.SPR=spr; sim3.TP=2.0; sim3.SL=15.0
    print('--- écart',spr)
    for k,s in V.items():
        tr=sim3.simule(m,s); tr=tr[tr.t>='2021-01-04']; b=sim3.bilan(tr); print(k,b[0],b[1],b[3],'moy',b[5],'gagn',b[7])
