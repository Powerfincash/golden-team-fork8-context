#!/usr/bin/env bash
# =============================================================================
#  runner.sh — l'agent de calcul du PC.
#
#  Il regarde dans jobs/, prend la demande la plus ancienne, la lance PAR LE
#  LANCEUR QUI EXISTE DEJA (jamais terminal.exe a la main : erreur repetee les
#  30/08 et 18/09, consignee dans CLAUDE.md), attend le rapport, appelle
#  mesure.py et parjeu.py, pousse le tout, et verifie que GitHub a recu.
#
#  Il ne conclut JAMAIS rien tout seul : aucun chiffre ne sort d'ici, ils
#  viennent de mesure.py. Pas de rapport = "REFUS : aucun rapport".
#
#  A installer par la ligne 3 de COMMANDE.md, jamais a lancer a la main.
# =============================================================================

set -u

DEPOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DEPOT" || exit 1

CONF="$HOME/.golden-team-runner.conf"
VERROU="$HOME/.golden-team-runner.lock"
JOURNAUX="$HOME/.runner-journaux"
mkdir -p "$JOURNAUX" 2>/dev/null

PLAFOND_PASSE=$((24 * 3600))   # une passe ne bloque pas la file plus de 24 h
PLAFOND_RAPPORT=2000000        # au-dela, le rapport HTML n'est pas pousse (INVENTAIRE.md)
CONTROLE_DEMARRAGE=300         # le premier resultat se controle a 5 min (CLAUDE.md)

maintenant() { date '+%d/%m/%Y a %Hh%M'; }
trace()      { printf '%s\n' "$*"; }

# ------------------------------- pousser, et VERIFIER que le distant a recu
# Meme exigence que sauver.sh : un commit local n'est pas une sauvegarde.
pousser() {
  git add -A -- jobs resultats RUNNER.md 2>/dev/null
  if git diff --cached --quiet; then
    trace "Rien de neuf a pousser."
    return 0
  fi
  git commit -q -m "$1" || { trace "ECHEC du commit."; return 1; }
  local essai=1 delai=2
  while [ $essai -le 5 ]; do
    git push -q -u origin main 2>/dev/null && break
    trace "Push refuse (essai $essai) ; nouvelle tentative dans ${delai}s."
    sleep $delai; delai=$((delai * 2)); essai=$((essai + 1))
    git pull -q --rebase --autostash origin main 2>/dev/null || git rebase --abort 2>/dev/null
  done
  local ici la_bas
  ici="$(git rev-parse HEAD 2>/dev/null)"
  la_bas="$(git ls-remote origin main 2>/dev/null | cut -f1)"
  if [ -n "$ici" ] && [ "$ici" = "$la_bas" ]; then
    trace "SAUVE ET VERIFIE. https://github.com/Powerfincash/golden-team-fork8-context/commit/$ici"
    return 0
  fi
  trace "LE TRAVAIL N'EST PAS SAUVE — le depot distant n'a pas le commit."
  return 1
}

# ------------------------------------------ le temoin de vie, lisible d'un coup
ecrire_temoin() {
  local resultat="$1" job="${2:-}" lignes=""
  [ -f "$DEPOT/RUNNER.md" ] &&     lignes="$(grep -E '^\| [0-9]{2}/[0-9]{2}/[0-9]{4}' "$DEPOT/RUNNER.md" 2>/dev/null | head -13)"
  local attente
  attente="$(ls -1 "$DEPOT"/jobs/*.ini 2>/dev/null | wc -l | tr -d ' ')"
  {
    echo "# L'agent de calcul"
    echo
    echo "**Dernier passage : $(maintenant) — ${resultat}.**"
    echo
    echo "**Demandes en attente dans \`jobs/\` : ${attente}.**"
    echo
    echo "Ce fichier est le temoin de vie de l'agent. Il se reecrit tout seul a chaque passage."
    echo "L'agent regarde dans \`jobs/\` toutes les dix minutes."
    echo
    echo "> **Si la date ci-dessus a plus de deux heures alors que le PC est allume,"
    echo "> l'agent ne tourne plus.** Recoller la ligne 3 de [\`COMMANDE.md\`](COMMANDE.md)."
    echo
    echo "| Passage | Demande | Resultat |"
    echo "|---|---|---|"
    echo "| $(date '+%d/%m/%Y %Hh%M') | ${job:-—} | ${resultat} |"
    [ -n "$lignes" ] && printf '%s\n' "$lignes"
    echo
    echo "Journaux detailles des passages : \`~/.runner-journaux/\` sur le PC."
  } > "$DEPOT/RUNNER.md"
}

# --------------------------------------------------------------- le verrou
# Une passe peut durer des heures ; la tache se represente toutes les 10 min.
if [ -f "$VERROU" ]; then
  pid_en_cours="$(cat "$VERROU" 2>/dev/null)"
  if [ -n "$pid_en_cours" ] && kill -0 "$pid_en_cours" 2>/dev/null; then
    trace "Une passe est deja en cours (pid $pid_en_cours) : rien a faire."
    exit 0
  fi
  trace "Verrou orphelin trouve, il est retire."
  rm -f "$VERROU"
fi
echo $$ > "$VERROU"
liberer() { rm -f "$VERROU"; }
trap liberer EXIT

# ------------------------------------------------- ou vivent outils et terminaux
# Detecte une fois, retenu ensuite. Rien a regler a la main.
detecter() {
  [ -f "$CONF" ] && . "$CONF"

  if [ -z "${FOREX:-}" ] || [ ! -d "${FOREX:-/introuvable}" ]; then
    for candidat in \
      "$HOME/OneDrive/Documents/forex" \
      "${USERPROFILE:-/introuvable}/OneDrive/Documents/forex" \
      "$HOME/Documents/forex" \
      "$DEPOT/pc/forex"
    do
      [ -d "$candidat" ] && { FOREX="$candidat"; break; }
    done
  fi

  if [ -z "${OUTILS:-}" ] || [ ! -d "${OUTILS:-/introuvable}" ]; then
    if [ -n "${FOREX:-}" ] && [ -d "$FOREX/outils" ]; then OUTILS="$FOREX/outils"
    elif [ -d "$DEPOT/pc/outils" ]; then OUTILS="$DEPOT/pc/outils"
    fi
  fi

  # Le terminal MT4 et son dossier de donnees, pour lancer_mt4.sh.
  if [ -z "${MT4_EXE:-}" ] || [ ! -f "${MT4_EXE:-/introuvable}" ]; then
    MT4_EXE="$(find "/c/Program Files (x86)" "/c/Program Files" -maxdepth 3 \
      -iname 'terminal.exe' -print -quit 2>/dev/null)"
  fi
  if [ -z "${MT4_DONNEES:-}" ] || [ ! -d "${MT4_DONNEES:-/introuvable}" ]; then
    for d in "${APPDATA:-/introuvable}/MetaQuotes/Terminal"/*/; do
      [ -d "$d/tester" ] && [ -d "$d/experts" ] && { MT4_DONNEES="${d%/}"; break; }
    done
  fi

  {
    echo "# Ecrit par runner.sh — chemins de CETTE machine, jamais dans le depot."
    echo "FOREX=\"${FOREX:-}\""
    echo "OUTILS=\"${OUTILS:-}\""
    echo "MT4_EXE=\"${MT4_EXE:-}\""
    echo "MT4_DONNEES=\"${MT4_DONNEES:-}\""
  } > "$CONF"
}
detecter

# ------------------------------------------------------- se remettre a jour
git config user.name  >/dev/null 2>&1 || git config user.name  "Powerfincash"
git config user.email >/dev/null 2>&1 || git config user.email "powerfincash@users.noreply.github.com"
git fetch -q origin main 2>/dev/null
git checkout -q main 2>/dev/null
git pull -q --rebase --autostash origin main 2>/dev/null || git rebase --abort 2>/dev/null

# ------- auto-deploy : copier les templates .ini vers jobs/ avant de traiter
if [ -d "$DEPOT/templates" ]; then
  for template in "$DEPOT"/templates/*.ini; do
    [ -f "$template" ] && {
      nom_template="$(basename "$template")"
      cp -f "$template" "$DEPOT/jobs/$nom_template"
      trace "Auto-deploy : $nom_template copie dans jobs/"
    }
  done
fi

# ---------------------------------------------------- la demande la plus ancienne
JOB="$(ls -1 "$DEPOT"/jobs/*.ini 2>/dev/null | head -1)"
if [ -z "$JOB" ]; then
  trace "Aucune demande dans jobs/ : rien a faire."
  ecrire_temoin "rien a faire" "" ; exit 0
fi
NOM="$(basename "$JOB" .ini)"
JOURNAL="$JOURNAUX/$(date +%Y%m%d-%H%M%S)-$NOM.log"
exec > >(tee -a "$JOURNAL") 2>&1
trace "=== $(maintenant) — demande : $NOM ==="

# --------------------------------------- lire le .ini (MT5 l'ecrit en UTF-16)
LISIBLE="$(mktemp)"
if head -c2 "$JOB" | od -An -tx1 | grep -qi 'ff fe'; then
  iconv -f UTF-16LE -t UTF-8 "$JOB" 2>/dev/null | tr -d '\r' > "$LISIBLE"
else
  tr -d '\r' < "$JOB" > "$LISIBLE"
fi
valeur() { grep -iE "^[[:space:]]*$1[[:space:]]*=" "$LISIBLE" | head -1 | cut -d= -f2- | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'; }

EXPERT="$(valeur Expert)"
SYMBOLE="$(valeur Symbol)"
PERIODE="$(valeur Period)"
DU="$(valeur FromDate)"
AU="$(valeur ToDate)"
RAPPORT="$(valeur Report)"
FERMETURE="$(valeur ShutdownTerminal)"

# ----------------------------------------- le refus AVANT le lancement (prelance)
refuser() {
  trace "REFUS : $1"
  mkdir -p "$DEPOT/jobs/refuses"
  git mv -f "$JOB" "$DEPOT/jobs/refuses/$(basename "$JOB")" 2>/dev/null || \
    mv -f "$JOB" "$DEPOT/jobs/refuses/"
  mkdir -p "$DEPOT/resultats/$NOM"
  { echo "# $NOM — REFUSE"; echo; echo "**$(maintenant)**"; echo;
    echo "REFUS : $1"; echo; echo "Rien n'a ete lance. Aucun chiffre a conclure."; } \
    > "$DEPOT/resultats/$NOM/refus.md"
  ecrire_temoin "REFUS — $1" "$NOM"
  pousser "Refus de la demande $NOM : $1"
  exit 0
}

manque=""
for couple in "Expert:$EXPERT" "Symbol:$SYMBOLE" "Period:$PERIODE" \
              "FromDate:$DU" "ToDate:$AU" "Report:$RAPPORT"; do
  cle="${couple%%:*}"; val="${couple#*:}"
  [ -z "$val" ] && manque="$manque $cle"
done
[ -n "$manque" ] && refuser "le .ini n'a pas de$manque"

case "$EXPERT$RAPPORT" in
  *..*|/*|*:\\*) refuser "Expert ou Report sort de son dossier ($EXPERT / $RAPPORT)" ;;
esac

case "$(printf '%s' "$EXPERT" | tr 'A-Z' 'a-z')" in
  *.ex5) PLATEFORME=MT5 ;;
  *.ex4) PLATEFORME=MT4 ;;
  *)     refuser "impossible de dire si c'est MT4 ou MT5 : Expert=$EXPERT" ;;
esac

if [ "$PLATEFORME" = MT5 ] && [ "$FERMETURE" != "1" ]; then
  refuser "ShutdownTerminal n'est pas a 1 : le terminal resterait ouvert et la file se bloquerait"
fi
[ -z "${OUTILS:-}" ] && refuser "les outils sont introuvables — coller d'abord la ligne 1 de COMMANDE.md"

trace "Plateforme : $PLATEFORME — $SYMBOLE $PERIODE, du $DU au $AU, rapport $RAPPORT"

# ------------------------------------------------------------- le lancement
DEBUT="$(date +%s)"
TEMOIN_TEMPS="$(mktemp)"   # sert de repere de date pour trouver le rapport

if [ "$PLATEFORME" = MT5 ]; then
  [ -z "${FOREX:-}" ] && refuser "le dossier forex est introuvable"
  [ -f "$OUTILS/lance_chaine.ps1" ] || refuser "outils/lance_chaine.ps1 est introuvable — rapatriement pas encore fait"
  cp -f "$JOB" "$FOREX/$NOM.ini" || refuser "impossible d'ecrire $FOREX/$NOM.ini"
  trace "Lancement par lance_chaine.ps1 -Inis $NOM"
  powershell.exe -NoProfile -ExecutionPolicy Bypass \
    -File "$(cygpath -w "$OUTILS/lance_chaine.ps1")" -Inis "$NOM" &
else
  [ -f "$OUTILS/lancer_mt4.sh" ] || refuser "outils/lancer_mt4.sh est introuvable — rapatriement pas encore fait"
  [ -n "${MT4_EXE:-}" ] && [ -f "$MT4_EXE" ] || refuser "terminal.exe de MT4 introuvable"
  [ -n "${MT4_DONNEES:-}" ] && [ -d "$MT4_DONNEES" ] || refuser "le dossier de donnees de MT4 est introuvable"
  trace "Lancement par lancer_mt4.sh --attendre"
  bash "$OUTILS/lancer_mt4.sh" "$MT4_EXE" "$MT4_DONNEES" "$JOB" --attendre &
fi
PID_LANCEUR=$!

# ------------------------------- le controle des 5 minutes (consigne CLAUDE.md)
chercher_rapport() {
  for racine in "${FOREX:-}" "${MT4_DONNEES:-}" "$(dirname "${MT4_EXE:-/x}")" "$HOME"; do
    [ -d "$racine" ] || continue
    trouve="$(find "$racine" -maxdepth 3 \( -iname "$RAPPORT.htm" -o -iname "$RAPPORT.html" \) \
              -newer "$TEMOIN_TEMPS" -print -quit 2>/dev/null)"
    [ -n "$trouve" ] && { printf '%s' "$trouve"; return 0; }
  done
  return 1
}
journal_lanceur() {
  [ -d "${FOREX:-/x}" ] || return 1
  find "$FOREX" -maxdepth 2 -iname 'chaine_*.log' -newer "$TEMOIN_TEMPS" \
    -printf '%T@ %p\n' 2>/dev/null | sort -rn | head -1 | cut -d' ' -f2-
}

sleep "$CONTROLE_DEMARRAGE"
JL="$(journal_lanceur)"
if [ -n "$JL" ]; then
  trace "Journal du lanceur : $JL"
  grep -qiE 'test demarre|test démarré|started with configuration' "$JL" 2>/dev/null \
    && trace "Le test a bien demarre." \
    || trace "ATTENTION : a 5 minutes, le journal ne dit pas que le test a demarre."
else
  trace "ATTENTION : aucun journal de lanceur trouve a 5 minutes."
fi

# ------------------------------------ attendre le rapport, sans limite utile
trace "Attente du rapport (plafond de securite : 24 h). Le terminal n'est jamais interrompu."
TAILLE_PRECEDENTE=-1
STABLE=0
CHEMIN_RAPPORT=""
while :; do
  ECOULE=$(( $(date +%s) - DEBUT ))
  [ "$ECOULE" -gt "$PLAFOND_PASSE" ] && break
  if CHEMIN_RAPPORT="$(chercher_rapport)"; then
    TAILLE="$(stat -c %s "$CHEMIN_RAPPORT" 2>/dev/null || echo 0)"
    if [ "$TAILLE" = "$TAILLE_PRECEDENTE" ] && [ "$TAILLE" -gt 0 ]; then
      STABLE=$((STABLE + 1))
      [ "$STABLE" -ge 2 ] && break     # inchange depuis 60 s : il est ecrit
    else
      STABLE=0
    fi
    TAILLE_PRECEDENTE="$TAILLE"
  fi
  sleep 30
done
wait $PID_LANCEUR 2>/dev/null

# --------------------------------------------------- pas de rapport = refus
mkdir -p "$DEPOT/resultats/$NOM"
[ -n "${JL:-}" ] && [ -f "$JL" ] && cp -f "$JL" "$DEPOT/resultats/$NOM/journal-lanceur.log"

if [ -z "$CHEMIN_RAPPORT" ] || [ ! -f "$CHEMIN_RAPPORT" ]; then
  trace "REFUS : aucun rapport apres l'attente — ne rien conclure de ce passage."
  { echo "# $NOM — REFUS"; echo; echo "**$(maintenant)**"; echo;
    echo "REFUS : aucun rapport apres l'attente (duree $((ECOULE / 60)) min).";
    echo; echo "**Ne rien conclure de ce passage.** La passe n'a pas produit de rapport :";
    echo "elle n'a donc produit aucun chiffre, ni bon ni mauvais.";
    echo; echo "Le journal du lanceur est a cote, c'est lui qui dit pourquoi."; } \
    > "$DEPOT/resultats/$NOM/refus.md"
  mkdir -p "$DEPOT/jobs/refuses"; mv -f "$JOB" "$DEPOT/jobs/refuses/"
  ecrire_temoin "REFUS — aucun rapport" "$NOM"
  pousser "REFUS sur $NOM : aucun rapport apres l'attente"
  exit 0
fi

trace "Rapport trouve : $CHEMIN_RAPPORT"

# ------------------------- le chiffre vient de mesure.py, jamais d'ici
if [ -f "$OUTILS/mesure.py" ]; then
  trace "mesure.py..."
  python "$OUTILS/mesure.py" "$(cygpath -w "$CHEMIN_RAPPORT" 2>/dev/null || echo "$CHEMIN_RAPPORT")" \
    > "$DEPOT/resultats/$NOM/mesure.txt" 2>&1
else
  echo "mesure.py introuvable : AUCUN CHIFFRE. Le rapport brut est a cote." \
    > "$DEPOT/resultats/$NOM/mesure.txt"
fi

if [ -f "$OUTILS/parjeu.py" ]; then
  trace "parjeu.py --csv..."
  python "$OUTILS/parjeu.py" "$(cygpath -w "$CHEMIN_RAPPORT" 2>/dev/null || echo "$CHEMIN_RAPPORT")" --csv \
    > "$DEPOT/resultats/$NOM/parjeu.csv" 2>"$DEPOT/resultats/$NOM/parjeu-erreurs.txt"
  [ -s "$DEPOT/resultats/$NOM/parjeu-erreurs.txt" ] || rm -f "$DEPOT/resultats/$NOM/parjeu-erreurs.txt"
fi

# le HTML brut n'entre que s'il est petit (INVENTAIRE.md)
TAILLE_R="$(stat -c %s "$CHEMIN_RAPPORT" 2>/dev/null || echo 0)"
if [ "$TAILLE_R" -le "$PLAFOND_RAPPORT" ]; then
  cp -f "$CHEMIN_RAPPORT" "$DEPOT/resultats/$NOM/rapport.htm"
else
  echo "Rapport de $((TAILLE_R / 1000)) Ko laisse sur le PC : $CHEMIN_RAPPORT" \
    > "$DEPOT/resultats/$NOM/rapport-non-copie.txt"
fi

{ echo "# $NOM"; echo; echo "**Passe terminee le $(maintenant), en $((ECOULE / 60)) minutes.**"; echo;
  echo "| | |"; echo "|---|---|";
  echo "| Robot | \`$EXPERT\` |"; echo "| Symbole | $SYMBOLE $PERIODE |";
  echo "| Fenetre | du $DU au $AU |"; echo "| Rapport | \`$RAPPORT\` |"; echo;
  echo "## Ce que dit mesure.py"; echo; echo '```'; cat "$DEPOT/resultats/$NOM/mesure.txt"; echo '```'; echo;
  echo "> Les chiffres ci-dessus sortent de \`mesure.py\` et de lui seul.";
  echo "> S'il affiche NON VERIFIE, il n'y a pas de chiffre."; } \
  > "$DEPOT/resultats/$NOM/resultat.md"

mkdir -p "$DEPOT/jobs/faits"; mv -f "$JOB" "$DEPOT/jobs/faits/"
ecrire_temoin "passe terminee en $((ECOULE / 60)) min" "$NOM"
pousser "Passe $NOM terminee — rapport, mesure et serie poussés"
