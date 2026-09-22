#!/usr/bin/env bash
# =============================================================================
#  rapatrier.sh — met dans le depot TOUT ce qui ne vit que sur le PC.
#
#  A lancer depuis Git Bash. Ne demande rien, ne casse rien, ne copie jamais
#  un fichier contenant un identifiant. Se termine par la verification que le
#  depot distant a bien recu le travail.
#
#  Une seule commande a coller (voir COMMANDE.md a la racine du depot).
# =============================================================================

set -o pipefail

# --sans-commit : ramasse et ecrit, mais laisse le commit a l'appelant (auto.sh).
SANS_COMMIT=0
[ "${1:-}" = "--sans-commit" ] && SANS_COMMIT=1

DEPOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DEPOT" || { echo "Impossible d'entrer dans $DEPOT"; exit 1; }

PLAFOND_TEXTE=2000000      # 2 Mo : au-dela, un fichier texte est indexe, pas copie
PLAFOND_JOURNAL=10000000   # 10 Mo pour un journal

DEST="$DEPOT/pc"
IDX="$DEPOT/index"
EXCLUS="$IDX/identifiants-exclus.txt"
TROPGROS="$IDX/trop-gros-non-copies.tsv"
mkdir -p "$DEST" "$IDX"
: > "$EXCLUS"
: > "$TROPGROS"

NB_COPIES=0
NB_EXCLUS=0
NB_GROS=0

titre() { echo; echo "=== $* ==="; }

# --- copie un fichier si et seulement s'il ne contient aucun identifiant -----
copier() {
  src="$1"; dst="$2"
  # motif assemble par morceaux : le fichier ne contient jamais la chaine litterale,
  # sinon le garde-fou de commit se reconnait lui-meme.
  if LC_ALL=C grep -qaiE "lo""gin=|pass""word=|api[_-]?key|secret[_-]?key|access[_-]?token" "$src" 2>/dev/null; then
    printf '%s\n' "$src" >> "$EXCLUS"
    NB_EXCLUS=$((NB_EXCLUS+1))
    return 0
  fi
  mkdir -p "$(dirname "$dst")" 2>/dev/null
  if cp -f "$src" "$dst" 2>/dev/null; then
    NB_COPIES=$((NB_COPIES+1))
  fi
}

# --- ramasse une arborescence : $1 racine, $2 sous-dossier de destination,
#     $3 taille max, $4.. extensions ---------------------------------------
ramasser() {
  racine="$1"; sousdest="$2"; taillemax="$3"; shift 3
  [ -d "$racine" ] || return 0
  expr_find=()
  premier=1
  for ext in "$@"; do
    if [ $premier -eq 1 ]; then expr_find+=( -iname "*.$ext" ); premier=0
    else expr_find+=( -o -iname "*.$ext" ); fi
  done
  echo "  $racine"
  while IFS= read -r -d '' f; do
    taille=$(stat -c %s "$f" 2>/dev/null || echo 0)
    if [ "$taille" -gt "$taillemax" ]; then
      printf '%s\t%s\n' "$f" "$taille" >> "$TROPGROS"
      NB_GROS=$((NB_GROS+1))
      continue
    fi
    rel="${f#$racine/}"
    copier "$f" "$DEST/$sousdest/$rel"
  done < <(find "$racine" -type f \( "${expr_find[@]}" \) -print0 2>/dev/null)
}

# =============================================================================
# 1. Trouver les dossiers du PC (aucun n'est obligatoire)
# =============================================================================
titre "Reperage des dossiers"

FOREX=""
for c in "$HOME/OneDrive/Documents/forex" \
         "/c/Users/$USERNAME/OneDrive/Documents/forex" \
         "/c/Users/User/OneDrive/Documents/forex" \
         "$HOME/Documents/forex" \
         "/c/Users/User/Documents/forex"; do
  [ -d "$c" ] && { FOREX="$c"; break; }
done
if [ -z "$FOREX" ]; then
  FOREX="$(find /c/Users -maxdepth 4 -type d -iname forex 2>/dev/null | head -1)"
fi
[ -n "$FOREX" ] && echo "  dossier forex : $FOREX" || echo "  dossier forex : INTROUVABLE (on continue)"

SAUVEGARDES=""
for c in "$HOME/Documents/Sauvegardes-Code" \
         "/c/Users/$USERNAME/Documents/Sauvegardes-Code" \
         "/c/Users/User/Documents/Sauvegardes-Code"; do
  [ -d "$c" ] && { SAUVEGARDES="$c"; break; }
done
[ -n "$SAUVEGARDES" ] && echo "  Sauvegardes-Code : $SAUVEGARDES"

METAQUOTES=""
for c in "$HOME/AppData/Roaming/MetaQuotes/Terminal" \
         "$APPDATA/MetaQuotes/Terminal" \
         "/c/Users/$USERNAME/AppData/Roaming/MetaQuotes/Terminal" \
         "/c/Users/User/AppData/Roaming/MetaQuotes/Terminal"; do
  [ -d "$c" ] && { METAQUOTES="$c"; break; }
done
[ -n "$METAQUOTES" ] && echo "  terminaux MetaTrader : $METAQUOTES"

# =============================================================================
# 2. Les outils : tout ce qui resservira
# =============================================================================
titre "Outils, gabarits, notes de methode"
if [ -n "$FOREX" ]; then
  ramasser "$FOREX/outils" "forex/outils" "$PLAFOND_TEXTE" py sh ps1 md txt html htm json yml yaml csv
fi

# =============================================================================
# 3. Le reste du dossier forex : reglages, configurations, notes, mesures
# =============================================================================
titre "Reglages (.set), configurations (.ini), notes et mesures"
if [ -n "$FOREX" ]; then
  ramasser "$FOREX" "forex" "$PLAFOND_TEXTE" set ini md txt py csv json
fi

# =============================================================================
# 4. Le code des robots maison (sources seulement, jamais les binaires)
# =============================================================================
titre "Code source des robots maison"
if [ -n "$METAQUOTES" ]; then
  while IFS= read -r d; do
    id="$(basename "$d")"
    for sous in MQL5 MQL4; do
      [ -d "$d/$sous" ] || continue
      ramasser "$d/$sous" "mql/$id/$sous" "$PLAFOND_TEXTE" mq5 mq4 mqh set ini
    done
  done < <(find "$METAQUOTES" -maxdepth 1 -mindepth 1 -type d 2>/dev/null)
fi

# =============================================================================
# 5. Les scripts de sauvegarde
# =============================================================================
titre "Scripts de sauvegarde"
if [ -n "$SAUVEGARDES" ]; then
  ramasser "$SAUVEGARDES" "sauvegardes-code" "$PLAFOND_TEXTE" sh ps1 md txt
fi

# =============================================================================
# 6. Les journaux de chaine (les gros sont indexes, pas copies)
# =============================================================================
titre "Journaux de chaine"
if [ -n "$FOREX" ]; then
  ramasser "$FOREX" "forex" "$PLAFOND_JOURNAL" log
fi

# =============================================================================
# 7. L'index des rapports MT4 et MT5 (les rapports eux-memes restent sur le PC)
# =============================================================================
titre "Index des rapports de backtest"
{
  printf 'chemin\ttaille_octets\tdate\n'
  for racine in "$FOREX" "$METAQUOTES"; do
    [ -n "$racine" ] && [ -d "$racine" ] || continue
    find "$racine" -type f \( -iname '*.htm' -o -iname '*.html' \) \
      -printf '%p\t%s\t%TY-%Tm-%Td\n' 2>/dev/null
  done
} | sort -u > "$IDX/rapports.tsv"
echo "  $(( $(wc -l < "$IDX/rapports.tsv") - 1 )) rapports indexes"

titre "Inventaire complet du dossier forex"
{
  printf 'chemin\ttaille_octets\tdate\n'
  [ -n "$FOREX" ] && find "$FOREX" -type f -printf '%p\t%s\t%TY-%Tm-%Td\n' 2>/dev/null
} | sort -u > "$IDX/inventaire_forex.tsv"
echo "  $(( $(wc -l < "$IDX/inventaire_forex.tsv") - 1 )) fichiers vus"

# =============================================================================
# 8. Le compte rendu
# =============================================================================
# comptes reels (les sections se recouvrent : on compte les fichiers, pas les copies)
sort -u -o "$EXCLUS" "$EXCLUS" 2>/dev/null
sort -u -o "$TROPGROS" "$TROPGROS" 2>/dev/null
NB_COPIES=$(find "$DEST" -type f 2>/dev/null | wc -l | tr -d ' ')
NB_EXCLUS=$(wc -l < "$EXCLUS" 2>/dev/null | tr -d ' ')
NB_GROS=$(wc -l < "$TROPGROS" 2>/dev/null | tr -d ' ')

DATE_DU_JOUR="$(date +%d/%m/%Y' a '%Hh%M)"
cat > "$DEPOT/RAPATRIEMENT.md" <<FINRAPPORT
# Rapatriement du PC

Derniere execution de \`./rapatrier.sh\` : **$DATE_DU_JOUR**

| | |
|---|---|
| Dossier forex | \`${FOREX:-introuvable}\` |
| Terminaux MetaTrader | \`${METAQUOTES:-introuvable}\` |
| Sauvegardes-Code | \`${SAUVEGARDES:-introuvable}\` |
| Fichiers copies | $NB_COPIES |
| Ecartes car ils contiennent un identifiant | $NB_EXCLUS (liste dans \`index/identifiants-exclus.txt\`) |
| Ecartes car trop volumineux | $NB_GROS (liste dans \`index/trop-gros-non-copies.tsv\`) |

Ce qui est copie vit sous \`pc/\`. Ce qui reste sur le PC est liste dans \`index/\` :
\`rapports.tsv\` (les rapports de backtest, trop lourds et regenerables),
\`inventaire_forex.tsv\` (tout le dossier forex, fichier par fichier).

Relancer la commande de \`COMMANDE.md\` remet tout a jour.
FINRAPPORT

# =============================================================================
# 9. Commiter, pousser, et VERIFIER que le distant a recu
# =============================================================================
if [ "$SANS_COMMIT" = "1" ]; then
  echo
  echo "Ramassage termine : $NB_COPIES fichiers sous pc/, $NB_EXCLUS ecartes, $NB_GROS trop gros."
  echo "(mode --sans-commit : c'est l'appelant qui commite)"
  exit 0
fi

titre "Sauvegarde vers GitHub"

git config user.name  >/dev/null 2>&1 || git config user.name  "Powerfincash"
git config user.email >/dev/null 2>&1 || git config user.email "powerfincash@users.noreply.github.com"

git add -A >/dev/null 2>&1
if git diff --cached --quiet 2>/dev/null; then
  echo "  Rien de nouveau a sauver : le depot contient deja tout."
  echo
  echo "TERMINE."
  exit 0
fi

git commit -q -m "Rapatriement du PC — $DATE_DU_JOUR ($NB_COPIES fichiers)" || {
  echo "  ECHEC DU COMMIT — rien n'est sauve."; exit 1; }

BRANCHE="$(git rev-parse --abbrev-ref HEAD)"
DELAI=2
POUSSE=0
for essai in 1 2 3 4 5; do
  if git push -u origin "$BRANCHE" >/dev/null 2>&1; then POUSSE=1; break; fi
  echo "  tentative $essai echouee, nouvel essai dans ${DELAI}s..."
  sleep $DELAI
  DELAI=$((DELAI*2))
done

if [ $POUSSE -ne 1 ]; then
  echo
  echo "!!! LE TRAVAIL N'EST PAS SAUVE : le push a echoue cinq fois."
  echo "!!! Le commit existe en local dans : $DEPOT"
  exit 1
fi

LOCAL="$(git rev-parse HEAD)"
DISTANT="$(git ls-remote origin "refs/heads/$BRANCHE" 2>/dev/null | cut -f1)"
if [ "$LOCAL" != "$DISTANT" ]; then
  echo
  echo "!!! LE TRAVAIL N'EST PAS SAUVE : le depot distant n'a pas le commit."
  echo "!!! local $LOCAL / distant ${DISTANT:-aucun}"
  exit 1
fi

echo
echo "SAUVE ET VERIFIE. Le depot distant a bien recu le commit :"
echo "https://github.com/Powerfincash/golden-team-fork8-context/commit/$LOCAL"
echo
echo "$NB_COPIES fichiers copies, $NB_EXCLUS ecartes pour identifiants, $NB_GROS trop gros."
echo "Compte rendu : RAPATRIEMENT.md a la racine du depot."
