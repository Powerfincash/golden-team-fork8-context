import csv,sys,datetime as dt,collections
def num(x): return float(x.replace(' ','').replace('\u00a0','')) if x else 0.0
def paire(f):
    d=list(csv.reader(open(f,encoding='utf-8')))
    opens=[];tr=[]
    for r in d:
        t=dt.datetime.strptime(r[0][:19],'%Y.%m.%d %H:%M:%S'); typ=r[3]; vol=num(r[5]); px=num(r[6]); pl=num(r[8])+num(r[9])+num(r[10]); com=r[12]
        if r[4]=='in': opens.append(dict(t=t,typ=typ,vol=vol,px=px,comm=num(r[8])))
        else:
            side='sell' if typ=='buy' else 'buy'
            c=[o for o in opens if o['typ']==side and abs(o['vol']-vol)<1e-9]
            if not c: c=[o for o in opens if o['typ']==side]
            k=com.split()[0] if com else '-'
            if k in('sl','tp'):
                lvl=num(com.split()[1]); o=min(c,key=lambda o:abs(abs(o['px']-lvl)-round(abs(o['px']-lvl),1))+0*o['vol'])
                # choose the one whose distance is closest to a known system distance
                dists={'sl':[15,17,22],'tp':[13,14.9]}[k]
                o=min(c,key=lambda o:min(abs(abs(o['px']-lvl)-D) for D in dists))
            else: o=c[0]
            opens.remove(o)
            dist=abs(o['px']-(num(com.split()[1]) if k in('sl','tp') else px))
            tr.append(dict(t_in=o['t'],t_out=t,dir=side,vol=vol,p_in=o['px'],p_out=px,pl=pl+o['comm'],exit=k,dist=round(dist,2)))
    return tr
if __name__=='__main__':
    tr=paire(sys.argv[1])
    w=csv.DictWriter(open(sys.argv[2],'w',newline=''),fieldnames=list(tr[0].keys())); w.writeheader(); w.writerows(tr)
    print(len(tr))
    for k in('sl','tp'):
        print(k,collections.Counter(round(x['dist']) for x in tr if x['exit']==k).most_common(8))
    hold=[(x['t_out']-x['t_in']).total_seconds()/3600 for x in tr]
    import statistics as st; print('hold h median',st.median(hold),'max',max(hold))
