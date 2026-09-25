import pandas as pd,numpy as np
def m1():
    m=pd.read_csv(r'C:\Users\User\OneDrive\Documents\forex\outils\barres\XAUUSD_p_M1.csv'); m['t']=pd.to_datetime(m.time,unit='s'); return m.set_index('t')
def feats(m):
    o=m.open; F=pd.DataFrame(index=m.index)
    F['hour']=m.index.hour; F['minute']=m.index.minute; F['wd']=m.index.weekday
    c1=m.close.shift(1)
    for w in [5,15,30,60,120,240]:
        F[f'r{w}']=o-m.close.shift(w); F[f'dH{w}']=o-m.high.rolling(w).max().shift(1); F[f'dL{w}']=o-m.low.rolling(w).min().shift(1)
    for tf in ['15min','1h','4h','1D']:
        g=m.index.floor(tf); F[f'dopen_{tf}']=o-m.open.groupby(g).transform('first')
        hh=m.high.groupby(g).cummax().shift(1); ll=m.low.groupby(g).cummin().shift(1)
        same=pd.Series(g,index=m.index).eq(pd.Series(g,index=m.index).shift(1))
        F[f'dhi_{tf}']=(o-hh).where(same); F[f'dlo_{tf}']=(o-ll).where(same)
    h=m.resample('1h').agg({'open':'first','high':'max','low':'min','close':'last'}).dropna()
    for N in [1,3,6,12,24]:
        H=h.high.rolling(N).max().shift(1).reindex(m.index,method='ffill'); L=h.low.rolling(N).min().shift(1).reindex(m.index,method='ffill')
        F[f'hH{N}']=o-H; F[f'hL{N}']=o-L
    d=m.resample('1D').agg({'high':'max','low':'min','close':'last'}).dropna()
    F['pdh']=o-d.high.shift(1).reindex(m.index,method='ffill'); F['pdl']=o-d.low.shift(1).reindex(m.index,method='ffill'); F['pdc']=o-d.close.shift(1).reindex(m.index,method='ffill')
    for P in [20,50]:
        ma=h.close.rolling(P).mean().shift(1).reindex(m.index,method='ffill'); F[f'hma{P}']=o-ma
    return F
def flat_labels(idx,tr_first,tr_all):
    busy=np.zeros(len(idx),bool)
    for _,x in tr_all.iterrows():
        a=idx.searchsorted(x.t_in); b=idx.searchsorted(x.t_out); busy[a+1:b+1]=True
    lab=np.zeros(len(idx),int)
    for _,x in tr_first.iterrows():
        j=idx.searchsorted(x.t_in)
        if j<len(idx) and idx[j]==x.t_in: lab[j]=1; busy[j]=False
    return pd.Series(lab,idx),pd.Series(~busy,idx)
