import pandas as pd,numpy as np
def evalue(idx,tr_first,tr_all,sig,tol=1,start='2021-01-04'):
    """for each first entry: from the time the book was last flat (max t_out of previous trades) find first signal; ok if within tol minutes"""
    s=sig.values; tr_all=tr_all.sort_values('t_in'); f=tr_first.sort_values('t_in').reset_index(drop=True)
    outs=tr_all.t_out.values; ins=tr_all.t_in.values
    ok=early=late=0;n=0
    for i,x in f.iterrows():
        if x.t_in<pd.Timestamp(start): continue
        prev=outs[ins<np.datetime64(x.t_in)]
        a=prev.max() if len(prev) else np.datetime64(start)
        j=idx.searchsorted(a,side='right'); je=idx.searchsorted(x.t_in)
        k=j+np.argmax(s[j:je+tol+1]) if s[j:je+tol+1].any() else None
        n+=1
        if k is None: late+=1
        elif abs(k-je)<=tol: ok+=1
        else: early+=1
    return round(ok/n,3),round(early/n,3),round(late/n,3)
