#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
plafond_paquet.py — rejoue chaque paquet de positions (un cote, de 0 a 0) minute par minute
sur l historique M1 du courtier (fichiers .hcc du terminal de test PU Prime), puis simule
un plafond de perte par paquet. Ne 24/09/2026 (paquet reel du 16/09, argent Till).

  python plafond_paquet.py <dossier du terminal de test> <rapport1> [rapport2 ...]

Hypotheses : barres M1 = bid, vente evaluee a high + spread ; prix d entree d une position
fermee retrouve depuis son profit (contrat 5000 oz) ; paquet coupe = ferme au plafond
(ou a l ouverture de la barre si elle ouvre deja au-dela) ; les re-entrees apres la coupe
ne sont pas modelisees. Controle : somme des paquets = solde final de mesure.py.
"""
import sys, struct, bisect, datetime as dt, json
sys.path.insert(0, __import__("os").path.dirname(__file__))
import empilement as E

T = sys.argv[1] if len(sys.argv) > 1 else r"C:/Users/User/AppData/Roaming/MetaQuotes/Terminal/E62C655ED163FFC555DD40DBEA67E6BB"
H = T + r"/bases/PUPrime-Demo/history/XAGUSD.p/"
C, PT = 5000.0, 0.001

def lire_hcc_sp(chemin):
    d=open(chemin,'rb').read(); p=228; recs=[]
    while True:
        a,b,c,e,f,g=struct.unpack('<HHIIHI',d[p:p+18])
        if f!=1: break
        recs.append((b,g)); p+=18
    out=[]
    for n,o in recs:
        q=o+189
        for k in range(n):
            t,op,hi,lo,cl,tv,sp,rv=struct.unpack('<qddddqiq',d[q+60*k:q+60*k+60]); out.append((t,op,hi,lo,cl,sp))
    return out
bars=[]
for y in range(2021,2027): bars+=lire_hcc_sp(H+f"{y}.hcc")
bars.sort(); TS=[b[0] for b in bars]
PRIX_ACTUEL = bars[-1][4]; DATE_ACTUEL = dt.datetime.utcfromtimestamp(bars[-1][0])

def ts(s): return int(dt.datetime.strptime(s[:19] if len(s)>16 else s+':00','%Y.%m.%d %H:%M:%S').replace(tzinfo=dt.timezone.utc).timestamp())

def deals(rapport):
    t=E.lire(rapport); out=[]
    for c in E.lignes(t):
        if len(c)!=13 or not E.DATE.match(c[0]): continue
        s,cote=c[4].lower(),c[3].lower()
        if s not in E.ENTREE|E.SORTIE or cote not in E.ACHAT|E.VENTE: continue
        out.append(dict(t=ts(c[0]),h=c[0],n=int(c[1]),type='buy' if cote in E.ACHAT else 'sell',sens='in' if s in E.ENTREE else 'out',
            v=E.nombre(c[5]),px=E.nombre(c[6]),com=E.nombre(c[8]),swap=E.nombre(c[9]),pr=E.nombre(c[10])))
    out.sort(key=lambda d:(d['t'],d['n'])); return out

def pire_prix(b, cote):   # prix defavorable du bar pour le cote (bars = bid)
    return b[3] if cote=='buy' else b[2]+b[5]*PT
def prix_ouv(b, cote):
    return b[1] if cote=='buy' else b[1]+b[5]*PT

def paquets(ds):
    # cote du paquet = cote de la position : entree buy = position longue ; sortie 'sell' ferme une longue
    res=[]; cur={}
    for d in ds:
        cote = d['type'] if d['sens']=='in' else ('buy' if d['type']=='sell' else 'sell')
        s = 1 if cote=='buy' else -1
        P = cur.get(cote)
        if P is None:
            P = cur[cote] = dict(cote=cote,debut=d['t'],hdebut=d['h'],V=0.0,EV=0.0,real=0.0,npos=0,nmax=0,ent=0,evts=[],px0=d['px'])
        if d['sens']=='in':
            P['V']+=d['v']; P['EV']+=d['px']*d['v']; P['ent']+=1
        else:
            e = d['px'] - s*d['pr']/(d['v']*C)     # prix d'entree retrouve depuis le profit
            P['V']-=d['v']; P['EV']-=e*d['v']
        P['real'] += d['com']+d['swap']+(d['pr'] if d['sens']=='out' else 0)
        P['nmax']=max(P['nmax'],round(P['V']/0.01))
        P['evts'].append((d['t'],P['V'],P['EV'],P['real'],d['px']))
        if P['V']<1e-9:
            P['fin']=d['t']; P['hfin']=d['h']; res.append(P); del cur[cote]
    return res

def trajet(P):
    """liste (t, pnl_pire, pnl_ouverture) minute par minute, et minimum"""
    s = 1 if P['cote']=='buy' else -1
    pts=[]
    ev=P['evts']
    for i,(t,V,EV,real,px) in enumerate(ev):
        # a l'instant du deal, au prix du deal
        if V>1e-9: pts.append((t, real + s*(px*V-EV)*C, real + s*(px*V-EV)*C))
        if i+1<len(ev) and V>1e-9:
            t2=ev[i+1][0]
            a=bisect.bisect_left(TS, (t//60)*60+60); z=bisect.bisect_left(TS, (t2//60)*60)
            for b in bars[a:z]:
                pts.append((b[0], real + s*(pire_prix(b,P['cote'])*V-EV)*C, real + s*(prix_ouv(b,P['cote'])*V-EV)*C))
    pts.append((P['fin'], P['real'], P['real']))
    return pts

def analyse(rapport):
    ps=paquets(deals(rapport))
    for P in ps:
        pts=trajet(P); m=min(pts,key=lambda x:x[1])
        P['mae']=min(0.0,m[1]); P['tmae']=m[0]; P['pts']=pts
        P['facteur']=PRIX_ACTUEL/P['px0']
    return ps

def couper(P, X):
    """resultat du paquet si on ferme tout quand la perte du paquet atteint X $ (a 0,01 lot, prix de l'epoque)"""
    for t,pire,ouv in P['pts']:
        if pire <= -X:
            return min(-X, ouv) if ouv<=-X else -X
    return P['real']

if __name__ == '__main__':
    import os
    R = {os.path.basename(r): analyse(r) for r in sys.argv[2:]}
    print(f"prix actuel {PRIX_ACTUEL} ({DATE_ACTUEL}) ; montants ramenes a ce prix, par 0,01 lot")
    for nom, ps in R.items():
        print(f"{nom}: {len(ps)} paquets, somme {sum(p['real'] for p in ps):.2f} (a comparer a mesure.py)")
    print("plafond | rapport | net | net coupe | ecart | paquets coupes | dont finis gagnants")
    for X in range(200, 701, 50):
        for nom, ps in R.items():
            net = sum(p['real'] * p['facteur'] for p in ps)
            net2 = sum(couper(p, X / p['facteur']) * p['facteur'] for p in ps)
            cut = [p for p in ps if p['mae'] * p['facteur'] <= -X]
            print(f"{X} | {nom} | {net:.0f} | {net2:.0f} | {net2-net:+.0f} | {len(cut)} | {sum(p['real'] > 0 for p in cut)}")
