import pandas as pd, numpy as np, sys
m=pd.read_csv(r'C:\Users\User\OneDrive\Documents\forex\outils\barres\XAUUSD_p_M15.csv'); m['t']=pd.to_datetime(m.time,unit='s'); m=m.set_index('t')
h=m.resample('1h').agg({'open':'first','high':'max','low':'min','close':'last'}).dropna()
d=m.resample('1D').agg({'open':'first','high':'max','low':'min','close':'last'}).dropna()
tr=pd.read_csv('s3_trades.csv',parse_dates=['t_in','t_out'])
pc=h.close.shift(1); po=h.open.shift(1)
pdh=d.high.shift(1).resample('1h').ffill().reindex(h.index); pdl=d.low.shift(1).resample('1h').ffill().reindex(h.index)
def chN(N): return pc>h.high.rolling(N).max().shift(2), pc<h.low.rolling(N).min().shift(2)
C={'pdh':(pc>pdh,pc<pdl),'pdh+up':((pc>pdh)&(pc>po),(pc<pdl)&(pc<po))}
for N in [3,5,10,20]:
    b,s=chN(N); C[f'ch{N}']=(b,s); C[f'ch{N}+pdh']=(b&(pc>pdh),s&(pc<pdl))
idx=h.index
for k,(b,s) in C.items():
    ok=okd=0; n=0
    for i in range(1,len(tr)):
        prev=tr.t_out[i-1]; act=tr.iloc[i]
        # first hour bar whose open >= prev exit floor-hour, check the current (partial) hour too
        start=prev.floor('h')
        j=idx.searchsorted(start)
        pred=None
        while j<len(idx) and idx[j]<=act.t_in+pd.Timedelta(days=3):
            t=idx[j]
            if t.weekday()!=0:
                if b.iloc[j]: pred=(max(t,prev),'buy');break
                if s.iloc[j]: pred=(max(t,prev),'sell');break
            j+=1
        n+=1
        if pred and pred[1]==act.dir: 
            okd+=1
            if abs((pred[0]-act.t_in).total_seconds())<=120: ok+=1
    print(f'{k:12s} même sens {okd/n:.0%}  même heure+sens {ok/n:.0%}')

b,s=C['pdh']; import collections
early=collections.Counter(); late=0; rows=[]
for i in range(1,len(tr)):
    prev=tr.t_out[i-1]; act=tr.iloc[i]; j=idx.searchsorted(prev.floor('h')); pred=None
    while j<len(idx) and idx[j]<=act.t_in+pd.Timedelta(days=3):
        t=idx[j]
        if t.weekday()!=0 and (b.iloc[j] or s.iloc[j]): pred=(max(t,prev),'buy' if b.iloc[j] else 'sell');break
        j+=1
    if pred:
        dtm=(act.t_in-pred[0]).total_seconds()/3600
        rows.append((dtm,pred[0],act.t_in,pred[1],act.dir))
rows.sort()
import random; random.seed(1)
for r in random.sample(rows,30): print(round(r[0],1),r[1],r[2],r[3],r[4])
print('pred hour of too-early',sorted(collections.Counter(r[1].hour for r in rows if r[0]>0.1).items()))
