import pandas as pd,numpy as np
from s2feat import m1
SPR=0.20; TP=15.0; SL=22.0; COM=0.07
def simule(m,sig):
    """sig: +1 buy / -1 sell at M1 bar open, only when flat"""
    o=m.open.values;hi=m.high.values;lo=m.low.values;t=m.index;s=sig.values
    pos=None; out=[]
    for i in range(len(o)):
        if pos:
            d,p=pos
            if d>0:
                if lo[i]<=p-SL: out.append((t[i],-SL-COM,d)); pos=None
                elif hi[i]>=p+TP: out.append((t[i],TP-COM,d)); pos=None
            else:
                if hi[i]+SPR>=p+SL: out.append((t[i],-SL-COM,d)); pos=None
                elif lo[i]+SPR<=p-TP: out.append((t[i],TP-COM,d)); pos=None
        if pos is None and s[i]!=0:
            pos=(s[i], o[i]+SPR if s[i]>0 else o[i])
    return pd.DataFrame(out,columns=['t','pl','d'])
def bilan(tr):
    y=tr.groupby(tr.t.dt.year).pl.sum().round(0).to_dict(); eq=tr.pl.cumsum()
    return len(tr),round(tr.pl.sum()),round((eq.cummax()-eq).max()),y,'moy',round(tr.pl.mean(),2),'gagn',round((tr.pl>0).mean(),2)
if __name__=='__main__':
    m=m1(); m=m[(m.index>='2020-12-01')&(m.index<'2025-01-01')]
    h=m.resample('1h').agg({'open':'first','high':'max','low':'min','close':'last'}).dropna()
    top=(m.index.minute==0)&(m.index.weekday!=0)
    V={}
    for N,k in [(24,1),(36,2),(12,0)]:
        H=h.high.rolling(N).max().shift(1); L=h.low.rolling(N).min().shift(1)
        sg=np.where(h.close>H+k,1,np.where(h.close<L-k,-1,0))
        sg=pd.Series(sg,h.index).shift(1).fillna(0).reindex(m.index).fillna(0)
        V[f'cassure H1 N{N} +{k}$']=sg.where(top,0)
    rng=np.random.default_rng(7)
    for r in range(3):
        v=np.where(rng.random(len(m))<0.01,np.where(rng.random(len(m))<0.5,1,-1),0)
        V[f'hasard {r}']=pd.Series(v,m.index).where(top,0)
    v=np.where(rng.random(len(m))<0.01,np.where(rng.random(len(m))<0.69,1,-1),0)
    V['hasard 69% achats']=pd.Series(v,m.index).where(top,0)
    for k,s in V.items():
        tr=simule(m,s); tr=tr[tr.t>='2021-01-04']; print(k,bilan(tr))
