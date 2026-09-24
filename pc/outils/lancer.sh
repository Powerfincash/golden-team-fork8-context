#!/bin/bash
# lancer.sh <fichier.ini> [derogation] [derogation] [derogation]
# Refuse tout passage non conforme. Chaque controle correspond a une erreur
# reellement commise le 29-30/08/2026. Aucune regle a retenir de tete.
#   1 Model=4 obligatoire      -> ticks generes : +170 % la ou les ticks reels liquident
#   2 aucun agent ni terminal  -> boucles concurrentes, journaux ecrases
#   3 prefixe de rapport libre -> collisions cut_ / cx_ avec d'anciennes sessions
#   4 fichier d'equite neuf    -> melange de courbes ; une valeur VIDE est IGNOREE par MT5
#   5 ticks reels presents     -> Model=4 sans historique retombe en silence sur du genere
# DEROGATIONS, cumulables, toutes imprimees dans la sortie :
#   --ea-tiers     : EA tiers -> dispense du SEUL controle de fichier d'equite
#   --modele-libre : dispense du SEUL controle Model=4 (comparaison de modeles)
#   --parallele    : dispense du SEUL controle d'exclusivite (second terminal)
# Terminal cible : par defaut PU Prime (E62C655E). Surchargeable par variables
# d'environnement, pour piloter un SECOND terminal sans dupliquer ce fichier :
#   TERMHASH=<hash du dossier de donnees>  TERMEXE=<chemin terminal64.exe>
TERMHASH="${TERMHASH:-E62C655ED163FFC555DD40DBEA67E6BB}"
TERMEXE="${TERMEXE:-/c/Program Files/PU Prime MT5 Terminal/terminal64.exe}"
D="C:/Users/User/AppData/Roaming/MetaQuotes/Terminal/$TERMHASH"
A="C:/Users/User/AppData/Roaming/MetaQuotes/Tester/$TERMHASH/Agent-127.0.0.1-3000/logs"
CF="C:/Users/User/AppData/Roaming/MetaQuotes/Terminal/Common/Files"
EXE="$TERMEXE"
[ -d "$D" ] || { echo "   REFUS  dossier de donnees introuvable : $D"; exit 1; }
[ -x "$EXE" ] || { echo "   REFUS  terminal introuvable : $EXE"; exit 1; }
INI="$1"; DEROG="$2"; DEROG2="$3"; DEROG3="$4"; ko=0
say(){ printf "   %-6s %s\n" "$1" "$2"; }
[ -f "$INI" ] || { say "REFUS" "ini introuvable : $INI"; exit 1; }
g(){ grep -m1 "^$1=" "$INI" | cut -d= -f2- | tr -d '\r'; }
MOD=$(g Model); REP=$(g Report); EQ=$(g InpFichierEquite); SYM=$(g Symbol)
# --ea-tiers ne dispense PLUS du modele de ticks : il ne dispense que du fichier
# d'equite (un EA tiers n'a pas notre parametre). Pour comparer deux modeles de
# ticks il faut la derogation SEPAREE --modele-libre, qui se voit dans la sortie.
if [ "$DEROG" = "--modele-libre" ] || [ "$DEROG2" = "--modele-libre" ] || [ "$DEROG3" = "--modele-libre" ]; then
  echo "   ///// DEROGATION --modele-libre : Model=$MOD accepte SANS controle"
else
  [ "$MOD" = "4" ] && say "ok" "Model=4 (ticks reels)" || { say "REFUS" "Model=$MOD : seuls les ticks reels sont admis"; ko=1; }
fi
# CONTROLE NON DEROGEABLE : une instance de CETTE installation rend la
# configuration SILENCIEUSEMENT IGNOREE (constate le 30/08 : passage lance,
# aucune activite du testeur, aucun message d'erreur). --parallele ne le leve pas.
moi=$(MOICIBLE="$EXE" python -c "
import subprocess,os
c=os.environ['MOICIBLE'].replace(chr(92),'/').lower()
if c.startswith('/c/'): c='c:'+c[2:]
o=subprocess.run(['wmic','process','where',\"name='terminal64.exe'\",'get','ProcessId,ExecutablePath','/format:csv'],capture_output=True,text=True).stdout
for l in o.splitlines():
    p=l.strip().split(',')
    if len(p)>=3 and p[1].strip().replace(chr(92),'/').lower()==c: print(p[2].strip())
")
if [ -n "$moi" ]; then say "REFUS" "cette installation tourne deja (PID $moi) : la configuration serait ignoree en silence"; ko=1
else say "ok" "aucune instance de cette installation"; fi
n=$(tasklist //FI "IMAGENAME eq metatester64.exe" 2>/dev/null | grep -c metatester64)
m=$(tasklist //FI "IMAGENAME eq terminal64.exe"   2>/dev/null | grep -c terminal64)
# Les agents MT5 se lient a 127.0.0.1:3000, port PARTAGE entre installations :
# un agent actif ailleurs empeche CE terminal de demarrer le sien, en silence.
# Verifie le 30/08 par netstat : port 3000 tenu par l'agent du terminal PU Prime.
# --parallele ne leve donc PAS l'exigence d'aucun agent, seulement celle d'aucun terminal.
if [ "$n" != "0" ]; then say "REFUS" "$n agent de test actif : le port 3000 est pris, ce terminal ne pourra pas demarrer le sien"; ko=1; fi
if [ "$DEROG" = "--parallele" ] || [ "$DEROG2" = "--parallele" ] || [ "$DEROG3" = "--parallele" ]; then
  echo "   ///// DEROGATION --parallele : $m terminal(aux) ouverts, exclusivite des TERMINAUX non exigee"
  say "DEROG" "verifier soi-meme qu'aucun autre passage n'ecrit le meme prefixe"
else
  [ "$n" = "0" ] && [ "$m" = "0" ] && say "ok" "aucun agent ni terminal actif" || { say "REFUS" "$n agent(s), $m terminal(aux) en cours"; ko=1; }
fi
c=$(ls "$D/$REP".* 2>/dev/null | wc -l)
[ "$c" = "0" ] && say "ok" "prefixe de rapport libre : $REP" || { say "REFUS" "$REP existe deja ($c fichier(s))"; ko=1; }
if [ "$DEROG" = "--ea-tiers" ] || [ "$DEROG2" = "--ea-tiers" ] || [ "$DEROG3" = "--ea-tiers" ]; then
  say "DEROG" "EA tiers : fichier d'equite non controle"
else
  if [ -z "$EQ" ]; then say "REFUS" "InpFichierEquite vide : une valeur VIDE est ignoree"; ko=1
  elif [ -f "$CF/$EQ" ]; then say "REFUS" "$EQ existe deja"; ko=1
  else say "ok" "equite neuve : $EQ"; fi
fi
TK="$D/bases/PUPrime-Demo/ticks/$SYM"
if [ -d "$TK" ]; then say "ok" "$(ls "$TK"/*.tkc 2>/dev/null | wc -l) mois de ticks reels pour $SYM"
else
  if [ "$MOD" = "4" ]; then say "REFUS" "aucun tick reel pour $SYM"; ko=1
  else say "ok" "pas de ticks reels pour $SYM (sans objet)"; fi
fi
[ "$ko" = "1" ] && { echo "   ---- PASSAGE REFUSE ----"; exit 1; }
echo "   ---- configuration effective complete ----"
sed 's/\r//; s/^Login=.*/Login=<masque>/; s/^/   /' "$INI"
if [ "$DEROG" != "--parallele" ] && [ "$DEROG2" != "--parallele" ] && [ "$DEROG3" != "--parallele" ]; then rm -f "$A"/*.log; fi
"$EXE" /config:"$(cygpath -w "$INI")" &
echo "   ---- lance ----"
