#!/bin/bash
# lancer_mt4.sh — lanceur MT4 sous garde-fous.
# Usage : lancer_mt4.sh <terminal.exe> <dossier de donnees> <fichier.ini> [--sans-ticks|--attendre]
#
# REFUSE de lancer, ou refuse de moissonner, si l'un des controles echoue.
# Ecrit le rapport lu sur la sortie standard. Ne moissonne JAMAIS un rapport
# qu'il n'a pas vu naitre pendant CE lancement.

EXE="$1"; DAT="$2"; INI="$3"; DEROG="$4"
refus(){ echo "///// REFUS : $1"; exit 1; }

[ -x "$EXE" ] || refus "terminal introuvable : $EXE"
[ -d "$DAT" ] || refus "dossier de donnees introuvable : $DAT"
[ -f "$INI" ] || refus "configuration introuvable : $INI"

# --- lecture de la configuration (ANSI, cles Test*) ---
SYM=$(grep -i "^TestSymbol="  "$INI" | head -1 | cut -d= -f2 | tr -d ' \r')
REP=$(grep -i "^TestReport="  "$INI" | head -1 | cut -d= -f2 | tr -d ' \r')
MOD=$(grep -i "^TestModel="   "$INI" | head -1 | cut -d= -f2 | tr -d ' \r')
EA=$(grep  -i "^TestExpert="  "$INI" | head -1 | cut -d= -f2 | tr -d '\r')
[ -n "$SYM" ] || refus "TestSymbol absent de $INI"
[ -n "$REP" ] || refus "TestReport absent — sans rapport nomme, rien n'est moissonnable"

# 1. modele de ticks : sur MT4 seul 0 (chaque tick) a un sens avec TDS
[ "$MOD" = "0" ] || refus "TestModel=$MOD ; sur MT4 avec TDS seul TestModel=0 est acceptable"

# 2. aucune instance de CETTE installation ne tourne (piege de l'instance unique)
inst(){ CIBLE="$EXE" python -c "
import subprocess,os
cible=os.environ['CIBLE'].replace(chr(92),'/').lower()
o=subprocess.run(['wmic','process','where',\"name='terminal.exe'\",'get','ProcessId,ExecutablePath','/format:csv'],capture_output=True,text=True).stdout
for l in o.splitlines():
    p=l.strip().split(',')
    if len(p)>=3 and p[1].strip().replace(chr(92),'/').lower()==cible: print(p[2].strip())
"; }
# --attendre : patienter que l'installation se libere (chainage de passages).
# Sans cette option, une instance active est un refus immediat. AVEC, l'attente
# est BORNEE et un depassement REFUSE — il ne poursuit jamais.
if [ "$DEROG" = "--attendre" ]; then
  # MT4 ne se ferme PAS toujours malgre TestShutdownTerminal=true : constate 3 fois les
  # 30-31/08, chaque fois des heures de file bloquee derriere un terminal mort. Une
  # instance dont le journal de testeur ne bouge plus depuis 3 min est morte : on la
  # ferme. On ne ferme QUE l'installation qu'on s'apprete a utiliser.
  age(){ AGEDAT="$DAT" python -c "
import os,glob,time
fs=glob.glob(os.path.join(os.environ['AGEDAT'],'tester','logs','*.log'))
print(int(time.time()-max(os.path.getmtime(f) for f in fs)) if fs else 99999)
"; }
  # CORRECTION 01/09 : un journal fige NE PROUVE PAS que le terminal est mort.
  # Pendant la PREPARATION DES TICKS (conversion des donnees Dukascopy par TDS) il
  # ne s'ecrit aucune ligne, parfois vingt minutes ; et quand aucun journal n'existe
  # encore, age() rend 99999, donc la mise a mort etait IMMEDIATE. Ce jour-la les
  # passages en file ont tue celui qui preparait devant eux. On mesure donc
  # l'ACTIVITE REELLE du processus au lieu d'un indice de cette activite.
  cpu(){ CPUPID="$1" python -c "
import subprocess,os,time
pid=os.environ['CPUPID']
def t():
    o=subprocess.run(['wmic','process','where','ProcessId=%s'%pid,'get','KernelModeTime,UserModeTime','/format:csv'],
                     capture_output=True,text=True).stdout
    for l in o.splitlines():
        p=[x.strip() for x in l.split(',')]
        if len(p)>=3 and p[1].isdigit() and p[2].isdigit(): return (int(p[1])+int(p[2]))/1e7
    return None
a=t()
if a is None: print(-1); raise SystemExit
time.sleep(5); b=t()
print(-1 if b is None else int(100*(b-a)/5))
"; }
  for i in $(seq 1 1440); do
    [ -z "$(inst)" ] && break
    if [ "$(age)" -gt 180 ]; then
      for p in $(inst); do
        C=$(cpu "$p")
        if [ "$C" -ge 0 ] 2>/dev/null && [ "$C" -lt 5 ]; then
          echo "   instance inactive (journal fige, CPU ${C}%), fermeture du PID $p"
          taskkill //PID $p >/dev/null 2>&1
        else
          echo "   journal fige mais le PID $p travaille (CPU ${C}%) — je patiente"
        fi
      done
      for k in $(seq 1 20); do [ -z "$(inst)" ] && break; sleep 3; done
    fi
    sleep 5
  done
fi
[ -n "$(inst)" ] && refus "cette installation tourne deja (PID $(inst)) — MT4 ignorerait la configuration en silence"

# 3. le prefixe de rapport est libre
[ -f "$DAT/$REP.htm" ] && refus "rapport $REP.htm deja present — choisir un autre prefixe"

# 3bis. le symbole est dans la Market Watch (history/<serveur>/symbols.sel). Constate le 18/09 (Luna, EURGBP et AUDCAD) :
#       sans cela le testeur ecrit « TestGenerator: <SYM> symbol not found », rapport vide, 0 tick — et l'ajout ne se fait
#       que dans l'interface du terminal (clic droit sur la Market Watch, « Afficher tout » ou « Symboles »).
mw=$(SYMMW="$SYM" DATMW="$DAT" python -c "
import os,glob
sym=os.environ['SYMMW']; ok=False
# UN seul serveur compte : celui de la derniere connexion = dossier history/<serveur> le plus recemment modifie
# (les autres serveurs — Darwinex, Fusion, Vantage — ont leur propre symbols.sel et donnaient un faux « present »)
fs=[f for f in glob.glob(os.path.join(os.environ['DATMW'],'history','*','symbols.sel')) if 'default' not in f]
f=max(fs, key=lambda x: os.path.getmtime(os.path.dirname(x))) if fs else None
if f:
    b=open(f,'rb').read()
    for i in range((len(b)-4)//128):
        if b[4+i*128:4+i*128+12].split(b'\0')[0].decode('ascii','ignore')==sym: ok=True
print(('oui' if ok else 'non')+' '+(os.path.basename(os.path.dirname(f)) if f else '?'))
")
srv=${mw#* }; mw=${mw%% *}
[ "$mw" = "oui" ] || refus "$SYM n'est pas dans la Market Watch du terminal (symbols.sel) : le testeur repondrait « symbol not found » — l'ajouter dans l'interface du MT4 d'abord"
echo "symbole present dans la Market Watch : $SYM"

# 4. des ticks reels existent pour ce symbole (sauf derogation explicite)
TDSD="C:/Users/User/AppData/Local/Tick Data Suite/Dukascopy"
if [ "$DEROG" = "--sans-ticks" ]; then
  echo "///// DEROGATION --sans-ticks : $SYM lance sans reserve de ticks reels"
else
  # Le nom du dossier Dukascopy n'est PAS toujours celui du courtier : pour les
  # indices il y a un MAPPAGE dans config/tds.config (NAS100.s -> USATECHIDXUSD).
  # Constate le 01/09 : trois passages Artemis refuses a tort.
  duka=$(python "C:/Users/User/OneDrive/Documents/forex/outils/duka_symbole.py" "$SYM" "$DAT/config/tds.config")
  [ -d "$TDSD/$duka" ] || refus "aucun tick reel pour $SYM (mappe vers $duka)"
  echo "ticks reels : $SYM -> $duka"
fi

# 4bis. TDS est-il ACTIVE pour cette installation ? (cause exacte des 3 passes vides
#       sur le terminal Ultima le 30/08 : tds.config absent => 0 tick modelise)
CFG="$DAT/config/tds.config"
[ -f "$CFG" ] || refus "TDS jamais configure pour cette installation ($CFG absent) : le testeur tournerait sans ticks reels"
grep -q 'key="UseTickDataEnabled" value="True"' "$CFG" || refus "TDS present mais UseTickDataEnabled != True dans $CFG"
echo "TDS actif pour cette installation"

# 5. l'EA existe bien au chemin demande
chemin="$DAT/MQL4/Experts/$(echo "$EA" | sed 's|[\]|/|g').ex4"
[ -f "$chemin" ] || refus "EA introuvable : $chemin"

echo "controles passes : $SYM  modele $MOD  rapport $REP  EA $EA"
rm -f "$DAT/tester/logs"/*.log 2>/dev/null
# 20/09 : chemin ABSOLU obligatoire — un .ini relatif est cherche par le MT4 dans SON dossier, jamais trouve, et le terminal
# demarre sans test (Viper AUDUSD, 20/09 20:59 : 27 min d'attente pour rien). Et le temoin ne vaut que s'il est POSTERIEUR au lancement.
INI_ABS="$(cd "$(dirname "$INI")" && pwd)/$(basename "$INI")"
T_LANCE=$(date +%s)
"$EXE" "$(cygpath -w "$INI_ABS")" &

# 6. temoin de prise en compte de la configuration.
#    Le journal peut etre en ANSI ou en UTF-16, et la ligne peut tomber dans logs/
#    comme dans tester/logs/ : on cherche partout et dans les deux encodages.
temoin(){ T_LANCE="$T_LANCE" python -c "
import io,glob,os,sys
mot='started with configuration file'
t0=float(os.environ.get('T_LANCE','0'))
for d in (os.path.join(sys.argv[1],'logs'), os.path.join(sys.argv[1],'tester','logs')):
    for f in glob.glob(os.path.join(d,'*.log')):
        if os.path.getmtime(f) < t0 - 5: continue   # 20/09 : un journal d'un passage ANTERIEUR ne temoigne de rien
        b=io.open(f,'rb').read()
        for enc in ('utf-16-le','cp1252','utf-8'):
            try: s=b.decode(enc,'ignore')
            except Exception: continue
            if mot in s.lower(): print('oui'); sys.exit()
" "$DAT"; }
vu=non
for i in $(seq 1 36); do
  sleep 5
  [ "$(temoin)" = "oui" ] && { vu=oui; break; }
  # si le rapport est deja la, le passage a bien demarre : le temoin n'a plus d'objet
  [ -f "$DAT/$REP.htm" ] && { vu=oui; break; }
done
[ "$vu" = "oui" ] || refus "le temoin 'Started with configuration file' n'est jamais apparu"
echo "configuration prise en compte"

# 6bis. SANTE DU PASSAGE, apres 90 s de simulation. Un passage qui refuse ses
#       ordres tourne des heures pour rien : Artemis NAS100 le 01/09, 801 848
#       erreurs 130 pour presque aucun ordre. Visible des la premiere minute.
sleep 90
sante=$(python "C:/Users/User/OneDrive/Documents/forex/outils/sante_passage.py" "$DAT")
echo "   sante : $sante"
case "$sante" in
  *VERDICT=MALADE*)
    for p in $(inst); do taskkill //PID $p >/dev/null 2>&1; done
    refus "le passage refuse ses ordres ($sante) — arrete au bout de 90 s" ;;
esac


# 7. attente bornee — un depassement REFUSE, il ne poursuit pas
fini=non
for i in $(seq 1 360); do
  [ -f "$DAT/$REP.htm" ] && { fini=oui; break; }
  [ -z "$(inst)" ] && { fini=sorti; break; }
  sleep 10
done
[ "$fini" = "oui" ] || refus "aucun rapport apres l'attente (etat: $fini) — ne rien conclure de ce passage"
sleep 8

# 8. le rapport contient-il vraiment quelque chose ?
tk=$(python -c "
import io,re,html
t=io.open(r'$DAT/$REP.htm',encoding='cp1252',errors='replace').read()[:9000]
p=re.sub(r'<[^>]+>',' ',t); p=html.unescape(p); p=re.sub(r'\s+',' ',p)
m=re.search(r'Ticks model[^ ]*s[: ]*(\d+)',p); print(m.group(1) if m else 0)
")
[ "$tk" = "0" ] && refus "0 tick modelise — le symbole n'a pas de donnees dans ce terminal"
echo "ticks modelises : $tk"
python "C:/Users/User/OneDrive/Documents/forex/outils/lire_rapport.py" "$DAT/$REP.htm"
