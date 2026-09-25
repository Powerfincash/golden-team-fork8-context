import pandas as pd,numpy as np
def evalue(h,tr,b,s,tol_h=0):
    idx=h.index; bb=b.values; ss=s.values; ok=0;n=0;early=0;late=0
    tin=tr.t_in.dt.floor('h').values; tout=tr.t_out.values
    for i in range(1,len(tr)):
        if pd.Timestamp(tin[i]).year<2021: continue
        j=idx.searchsorted(tout[i-1],side='right'); je=idx.searchsorted(tin[i])
        first=None
        while j<len(idx) and j<=je+tol_h+200:
            if bb[j] or ss[j]: first=(j,'buy' if bb[j] else 'sell');break
            j+=1
        n+=1
        if first and abs(first[0]-je)<=tol_h and first[1]==tr.dir[i]: ok+=1
        elif first and first[0]<je: early+=1
        else: late+=1
    return ok/n,early/n,late/n
