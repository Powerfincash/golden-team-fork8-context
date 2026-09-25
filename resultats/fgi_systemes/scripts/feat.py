import pandas as pd, numpy as np
def barres():
    m=pd.read_csv(r'C:\Users\User\OneDrive\Documents\forex\outils\barres\XAUUSD_p_M15.csv'); m['t']=pd.to_datetime(m.time,unit='s'); m=m.set_index('t')
    return m
def features(m, tf='1h'):
    h=m.resample(tf).agg({'open':'first','high':'max','low':'min','close':'last'}).dropna()
    d=m.resample('1D').agg({'open':'first','high':'max','low':'min','close':'last'}).dropna()
    F=pd.DataFrame(index=h.index)
    pc=h.close.shift(1); po=h.open.shift(1)
    tr=pd.concat([h.high-h.low,(h.high-h.close.shift()).abs(),(h.low-h.close.shift()).abs()],axis=1).max(axis=1)
    atr=tr.rolling(14).mean().shift(1); F['atr']=atr
    F['hour']=h.index.hour; F['wd']=h.index.weekday
    F['body']=pc-po; F['rng']=(h.high-h.low).shift(1)
    for N in [2,3,5,8,12,24,48,96]:
        F[f'dH{N}']=pc-h.high.rolling(N).max().shift(2); F[f'dL{N}']=pc-h.low.rolling(N).min().shift(2)
        F[f'ret{N}']=pc-h.close.shift(1+N)
    for k in [1,2,3,5]:
        F[f'pdh{k}']=pc-d.high.rolling(k).max().shift(1).resample(tf).ffill().reindex(h.index)
        F[f'pdl{k}']=pc-d.low.rolling(k).min().shift(1).resample(tf).ffill().reindex(h.index)
    day=h.index.normalize()
    F['dop']=pc-h.open.groupby(day).transform('first')
    hh=h.high.groupby(day).cummax().shift(2); ll=h.low.groupby(day).cummin().shift(2)
    F['dHday']=pc-hh; F['dLday']=pc-ll
    for M in [20,50,100,200]:
        ma=h.close.rolling(M).mean().shift(1); F[f'ma{M}']=pc-ma
    return h,F
def etiquettes(h,tr):
    lab=pd.Series(0,index=h.index); flat=pd.Series(False,index=h.index)
    idx=h.index
    for i in range(len(tr)):
        a=tr.t_out[i-1] if i>0 else idx[0]; b=tr.t_in[i]
        j0=idx.searchsorted(a.ceil('h')); j1=idx.searchsorted(b.floor('h'))
        flat.iloc[j0:j1+1]=True
        if b.minute==0 and b.second==0 and j1<len(idx) and idx[j1]==b: lab.iloc[j1]=1 if tr.dir[i]=='buy' else -1
    return lab,flat
