import sys,re,html,csv
sys.path.insert(0,r'C:\Users\User\OneDrive\Documents\forex\outils')
import mesure as M
p,out=sys.argv[1],sys.argv[2]
s=M.charge(p)
ordres=[];deals=[]
for r in re.findall(r'<tr[^>]*>(.*?)</tr>', s, flags=re.S|re.I):
    t=[html.unescape(re.sub(r'<[^>]+>','',x)).strip() for x in re.findall(r'<td[^>]*>(.*?)</td>', r, flags=re.S|re.I)]
    if not t or not re.match(r'\d{4}\.\d{2}\.\d{2}',t[0]): continue
    if len(t)==11 and t[1].isdigit(): ordres.append(t)
    elif len(t)>=13 and t[4] in('in','out','inout'): deals.append(t)
with open(out+'_ordres.csv','w',newline='',encoding='utf-8') as f: csv.writer(f).writerows(ordres)
with open(out+'_deals.csv','w',newline='',encoding='utf-8') as f: csv.writer(f).writerows(deals)
print(len(ordres),len(deals))
