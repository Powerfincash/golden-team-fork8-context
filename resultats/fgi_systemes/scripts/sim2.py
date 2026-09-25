import pandas as pd,numpy as np
from s2feat import m1
SPR=0.20; ADD=5.0; TP=5.0; SL=17.0; VAL=1.0  # $ per 1.00 price move per 0.01 lot
def simule(m,sig):
    o=m.open.values;hi=m.high.values;lo=m.low.values;t=m.index;s=sig.values
    pos=[] # (price_ask,lots)
    trades=[]
    for i in range(len(o)):
        # manage on this bar: exits first (using bid = o/hi/lo)
        if pos:
            # stops per order
            keep=[]
            for p,l in pos:
                if lo[i]<=p-SL: trades.append((t[i],-SL*l*100-0.07*l*100))
                else: keep.append((p,l))
            pos=keep
            if pos:
                L=sum(l for _,l in pos); avg=sum(p*l for p,l in pos)/L
                if hi[i]>=avg+TP:
                    trades.append((t[i],TP*L*100-0.07*L*100)); pos=[]
                elif len(pos)==1 and pos[0][1]==0.01 and lo[i]<=pos[0][0]-ADD:
                    pos.append((pos[0][0]-ADD+SPR,0.02))
        if not pos and s[i]: pos=[(o[i]+SPR,0.01)]
    return pd.DataFrame(trades,columns=['t','pl'])
def bilan(tr):
    y=tr.groupby(tr.t.dt.year).pl.sum().round(0).to_dict()
    eq=tr.pl.cumsum(); dd=(eq.cummax()-eq).max()
    return len(tr),round(tr.pl.sum()),round(dd),y
if __name__=='__main__':
    m=m1(); m=m[(m.index>='2021-01-04')&(m.index<'2025-01-01')]
    hr=m.index.hour; mi=m.index.minute; win=(hr>=15)&(hr<20)
    q=m.resample('15min').agg({'high':'max','close':'last'}).dropna()
    V={}
    for N in [4,8]:
        b=(q.close>q.high.rolling(N).max().shift(1)).shift(1).reindex(m.index).fillna(False).astype(bool)
        V[f'A_cass15m_N{N}']=b&win&(mi%15==0)
    low60=m.low.rolling(60).min().shift(1)
    for K in [8,10]: V[f'B_remonte60_{K}']=(m.open-low60>K)&win
    V['C_heure_1530']=(hr==15)&(mi==30)
    hopen=m.open.groupby(m.index.floor('1h')).transform('first')
    V['D_repli_2']=(m.open<hopen-2)&win
    V['E_tout_quart']=win&(mi%15==0)
    for k,s in V.items(): print(k,bilan(simule(m,pd.Series(s,index=m.index))))
