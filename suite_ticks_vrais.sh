#!/bin/bash
# suite_ticks_vrais.sh (25/09) : importe les ticks PU Prime XAUUSD.p dans
# XAUUSD_VRAI (importe_ticks.ps1), puis lance t06/t07 par lance_chaine. Rien d'autre.
D="C:/Users/User/OneDrive/Documents/forex"; L="$D/suite_ticks_vrais.log"
t(){ echo "$(date +%H:%M:%S)  $*" >> "$L"; }
for i in $(seq 1 60); do
  powershell -NoProfile -ExecutionPolicy Bypass -File "$D/outils/importe_ticks.ps1" -Modele XAUUSD.p -Symbole XAUUSD_VRAI -Minutes 120 && break
  t "import refuse (terminal occupe ?), nouvel essai dans 2 min"; sleep 120
done
tail -4 "$D/importe_ticks_XAUUSD_VRAI.log" | while read l; do t "  $l"; done
# 25/09 10:35 : « IMPORT OK » avec 0 tick. On exige desormais un import non vide.
if ! grep -q "IMPORT OK" "$D/importe_ticks_XAUUSD_VRAI.log" || grep -q "FIN : 0 ticks" "$D/importe_ticks_XAUUSD_VRAI.log"; then t "ARRET : import pas OK"; exit 1; fi
for i in $(seq 1 60); do
  if ! tasklist | grep -qi metatester64; then break; fi; sleep 60
done
t "lancement t06/t07"
powershell -NoProfile -ExecutionPolicy Bypass -File "$D/outils/lance_chaine.ps1" -Inis t06_n121_2124_vrai,t07_n121_2526_vrai -Journal chaine_ticks_vrais.log
t "fin"
