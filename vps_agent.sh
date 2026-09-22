#!/usr/bin/env bash
# =============================================================================
#  vps_agent.sh — l'agent de remontee du VPS.
#
#  Il tourne sur la machine qui porte le COMPTE REEL. Il est donc concu pour
#  peser le moins possible : quelques secondes, quelques kilo-octets, toutes
#  les quinze minutes.
#
#  CE QU'IL FAIT :
#    - il pousse dans le depot les journaux du terminal, masques du numero de
#      compte, et un etat lisible d'un coup d'oeil ;
#    - il pose dans le terminal les fichiers deposes dans a-poser/.
#
#  CE QU'IL NE FAIT JAMAIS, ET C'EST VOLONTAIRE :
#    - toucher une position ouverte ;
#    - changer les parametres d'un robot en cours ;
#    - attacher un robot a un graphique ;
#    - arreter, relancer ou mettre a jour un terminal ;
#    - ecraser le fichier d'un robot qui tourne (il pose a cote et le signale).
#
#  Aucun port n'est ouvert. Rien n'entre : le VPS ne fait que sortir vers GitHub.
# =============================================================================

set -u

DEPOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DEPOT" || exit 1
BRANCHE=vps

VERROU="$HOME/.vps-agent.lock"
GARDE_JOURS=14          # on gardera quatorze jours de journaux, pas davantage
PLAFOND_JOURNAL=400000  # 400 Ko par journal : on garde la fin, pas le debut

maintenant() { date '+%d/%m/%Y a %Hh%M'; }
trace()      { printf '%s\n' "$*"; }

if [ -f "$VERROU" ]; then
  pid="$(cat "$VERROU" 2>/dev/null)"
  if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then exit 0; fi
  rm -f "$VERROU"
fi
echo $$ > "$VERROU"
trap 'rm -f "$VERROU"' EXIT

# ------------------------------------------------------- trouver les terminaux
MT4_DONNEES=""; MT5_DONNEES=""
for d in "${APPDATA:-/introuvable}/MetaQuotes/Terminal"/*/; do
  d="${d%/}"
  [ -d "$d/MQL5" ] && [ -z "$MT5_DONNEES" ] && MT5_DONNEES="$d"
  [ -d "$d/MQL4" ] && [ -z "$MT4_DONNEES" ] && MT4_DONNEES="$d"
done

# ----------------------------- masquer le numero de compte avant toute copie
# Les journaux portent le numero de compte et le nom du serveur. Le depot est
# prive, ce n'est pas une raison pour les y laisser en clair.
masquer() {
  sed -E -e "s/'[0-9]{4,12}'/'compte-masque'/g" \
         -e "s/([Aa]ccount|[Ll]ogin)[[:space:]]*[:=][[:space:]]*[0-9]{4,12}/\1: compte-masque/g" \
         -e "s/lo""gin=[0-9]{4,12}/login=compte-masque/g"
}

# --------------------------------------------- ramasser les journaux du jour
mkdir -p "$DEPOT/etat/journaux"
ramasser_journaux() {
  local donnees="$1" etiquette="$2" src dst
  [ -n "$donnees" ] && [ -d "$donnees" ] || return 0
  for sous in "logs" "MQL5/Logs" "MQL4/Logs"; do
    [ -d "$donnees/$sous" ] || continue
    for src in $(find "$donnees/$sous" -maxdepth 1 -name '*.log' -mtime -2 2>/dev/null); do
      dst="$DEPOT/etat/journaux/${etiquette}-$(basename "$(dirname "$src")")-$(basename "$src")"
      if [ "$(stat -c %s "$src" 2>/dev/null || echo 0)" -gt "$PLAFOND_JOURNAL" ]; then
        { echo "[debut coupe : journal trop long, seule la fin est gardee]";
          tail -c "$PLAFOND_JOURNAL" "$src"; } | masquer > "$dst"
      else
        masquer < "$src" > "$dst"
      fi
    done
  done
}
ramasser_journaux "$MT5_DONNEES" "mt5"
ramasser_journaux "$MT4_DONNEES" "mt4"
find "$DEPOT/etat/journaux" -name '*.log' -mtime "+$GARDE_JOURS" -delete 2>/dev/null

# ------------------------------------------------- de quoi lire l'etat d'un coup
recents() { cat "$DEPOT"/etat/journaux/*.log 2>/dev/null; }

ERREURS="$(recents | grep -iE "error|failed|echec|invalid|not enough money|no connection|rejected" \
           | tail -25)"
DECO="$(recents | grep -ciE "no connection|disconnect" 2>/dev/null || echo 0)"
ORDRES="$(recents | grep -iE "order|deal|position" | tail -25)"
# Les noms de robots, ratisses large : ce sont eux qui protegent les fichiers
# d'un robot qui tourne. Mieux vaut un nom de trop qu'un fichier ecrase.
ROBOTS="$( { recents | grep -oiE "expert[[:space:]]+[A-Za-z0-9_.-]+" \
               | sed -E 's/^[Ee]xpert[[:space:]]+//'
             recents | grep -oE "[A-Za-z][A-Za-z0-9_.-]*[[:space:]]*\([A-Z0-9._]+,[A-Za-z0-9]+\)" \
               | sed -E 's/[[:space:]]*\(.*$//' ; } \
           | grep -viE '^(removed|loaded|initialized|started|stopped|expert)$' \
           | sort -u | head -20)"

{
  echo "# Etat du VPS"
  echo
  echo "**Dernier passage : $(maintenant).**"
  echo
  echo "> Ce fichier est reecrit a chaque passage, toutes les quinze minutes."
  echo "> **Si la date ci-dessus a plus d'une heure, l'agent ne tourne plus sur le VPS.**"
  echo
  echo "| | |"
  echo "|---|---|"
  echo "| Terminal MT5 | ${MT5_DONNEES:-non trouve} |"
  echo "| Terminal MT4 | ${MT4_DONNEES:-non trouve} |"
  echo "| Pertes de connexion vues dans les journaux | ${DECO} |"
  echo
  echo "## Robots vus dans les journaux"
  echo
  if [ -n "$ROBOTS" ]; then printf '%s\n' "$ROBOTS" | sed 's/^/- /'; else echo "_aucun robot nomme dans les journaux recents._"; fi
  echo
  echo "## Erreurs recentes"
  echo
  if [ -n "$ERREURS" ]; then echo '```'; printf '%s\n' "$ERREURS"; echo '```'
  else echo "_aucune erreur dans les journaux recents._"; fi
  echo
  echo "## Derniers mouvements"
  echo
  if [ -n "$ORDRES" ]; then echo '```'; printf '%s\n' "$ORDRES"; echo '```'
  else echo "_aucun mouvement dans les journaux recents._"; fi
  echo
  echo "---"
  echo
  echo "Ce que cet agent ne voit pas, et il faut le savoir : **l'etat instantane des positions"
  echo "et le solde**. Les journaux disent ce qui s'est passe, pas ce qui est ouvert maintenant."
  echo "Pour l'avoir, il faudrait attacher au terminal un petit exportateur en lecture seule,"
  echo "qui ne passe aucun ordre. Ce n'est pas fait : cela demande un clic de Denis sur la"
  echo "machine du compte reel, et ce clic lui appartient."
} > "$DEPOT/etat/etat.md"

# ----------------------------------- poser les fichiers deposes dans a-poser/
mkdir -p "$DEPOT/a-poser" "$DEPOT/poses"
COMPTE_RENDU="$DEPOT/poses/$(date +%Y%m%d-%H%M%S).md"
POSES=0
if ls "$DEPOT"/a-poser/* >/dev/null 2>&1; then
  { echo "# Pose du $(maintenant)"; echo; } > "$COMPTE_RENDU"
  for f in "$DEPOT"/a-poser/*; do
    [ -f "$f" ] || continue
    base="$(basename "$f")"
    minu="$(printf '%s' "$base" | tr 'A-Z' 'a-z')"
    dest=""
    case "$minu" in
      *.ex5|*.mq5)  [ -n "$MT5_DONNEES" ] && dest="$MT5_DONNEES/MQL5/Experts" ;;
      *.ex4|*.mq4)  [ -n "$MT4_DONNEES" ] && dest="$MT4_DONNEES/MQL4/Experts" ;;
      mt5-*.set)    [ -n "$MT5_DONNEES" ] && dest="$MT5_DONNEES/MQL5/Presets" ;;
      mt4-*.set)    [ -n "$MT4_DONNEES" ] && dest="$MT4_DONNEES/MQL4/Presets" ;;
      *.set)        echo "- \`$base\` : **non pose**. Un .set doit commencer par \`mt4-\` ou \`mt5-\` pour dire ou il va." >> "$COMPTE_RENDU"; continue ;;
      *)            echo "- \`$base\` : **non pose**. Extension non prevue." >> "$COMPTE_RENDU"; continue ;;
    esac
    if [ -z "$dest" ] || [ ! -d "$dest" ]; then
      echo "- \`$base\` : **non pose**. Le dossier d'arrivee n'existe pas sur cette machine." >> "$COMPTE_RENDU"
      continue
    fi

    # Garde-fou : ne jamais ecraser le fichier d'un robot qui tourne.
    racine="${base%.*}"
    if printf '%s' "$ROBOTS" | grep -qiF "$racine"; then
      cp -f "$f" "$dest/${racine}.nouveau.${base##*.}"
      echo "- \`$base\` : **pose A COTE**, sous \`${racine}.nouveau.${base##*.}\`." >> "$COMPTE_RENDU"
      echo "  Un robot de ce nom apparait dans les journaux : son fichier n'a pas ete ecrase." >> "$COMPTE_RENDU"
      echo "  **A vous de voir si vous voulez le remplacer.**" >> "$COMPTE_RENDU"
    else
      [ -f "$dest/$base" ] && cp -f "$dest/$base" "$dest/$base.avant-$(date +%Y%m%d-%H%M%S)"
      cp -f "$f" "$dest/$base"
      echo "- \`$base\` : pose dans \`$dest\`." >> "$COMPTE_RENDU"
      echo "  **Il n'est pas actif** : il faut l'attacher a un graphique, et ce geste reste le votre." >> "$COMPTE_RENDU"
    fi
    rm -f "$f"
    POSES=$((POSES + 1))
  done
  [ "$POSES" -eq 0 ] && : > /dev/null
fi

# ------------------------------------- pousser, et VERIFIER que GitHub a recu
git config user.name  >/dev/null 2>&1 || git config user.name  "Powerfincash"
git config user.email >/dev/null 2>&1 || git config user.email "powerfincash@users.noreply.github.com"
git fetch -q origin "$BRANCHE" 2>/dev/null
git pull -q --rebase --autostash origin "$BRANCHE" 2>/dev/null || git rebase --abort 2>/dev/null

git add -A -- etat a-poser poses 2>/dev/null
if git diff --cached --quiet; then
  trace "Rien de neuf."
  exit 0
fi
git commit -q -m "Etat du VPS au $(maintenant)" || exit 1

essai=1; delai=2
while [ $essai -le 5 ]; do
  git push -q -u origin "$BRANCHE" 2>/dev/null && break
  sleep $delai; delai=$((delai * 2)); essai=$((essai + 1))
  git pull -q --rebase --autostash origin "$BRANCHE" 2>/dev/null || git rebase --abort 2>/dev/null
done

ici="$(git rev-parse HEAD 2>/dev/null)"
la_bas="$(git ls-remote origin "$BRANCHE" 2>/dev/null | cut -f1)"
if [ -n "$ici" ] && [ "$ici" = "$la_bas" ]; then
  trace "SAUVE ET VERIFIE. $ici"
else
  trace "LE TRAVAIL N'EST PAS SAUVE — le depot distant n'a pas le commit."
  exit 1
fi
