#!/usr/bin/env bash
# =============================================================================
#  auto.sh — ce que la tache planifiee Windows lance chaque nuit.
#
#  Elle met le depot a jour, relance le rapatriement, et ne commite QUE s'il
#  y a du neuf ou si la trace du jour n'est pas encore ecrite. Un commit par
#  jour au maximum, jamais plus.
#
#  Installee par la ligne 2 de COMMANDE.md. Lancee a la main, elle affiche
#  sa progression a l'ecran.
# =============================================================================

DEPOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DEPOT" || exit 1

JOURNAUX="$HOME/.rapatriement-journaux"
mkdir -p "$JOURNAUX" 2>/dev/null
JOURNAL="$JOURNAUX/$(date +%Y%m%d-%H%M%S).log"

TRACE="$DEPOT/AUTOMATIQUE.md"
AUJOURDHUI="$(date +%d/%m/%Y)"
MAINTENANT="$(date +%d/%m/%Y' a '%Hh%M)"

executer() {

echo "=== $MAINTENANT — rapatriement automatique ==="

git config user.name  >/dev/null 2>&1 || git config user.name  "Powerfincash"
git config user.email >/dev/null 2>&1 || git config user.email "powerfincash@users.noreply.github.com"

# --- 1. se remettre a jour sur le depot ------------------------------------
git fetch -q origin main 2>/dev/null
git checkout -q main 2>/dev/null
if ! git pull -q --rebase --autostash origin main 2>/dev/null; then
  git rebase --abort 2>/dev/null
  echo "Mise a jour depuis GitHub impossible ; on continue sur la copie locale."
fi

# --- 2. ramasser, sans commiter -------------------------------------------
echo "Ramassage des fichiers du PC en cours (plusieurs minutes la premiere fois, ne pas fermer la fenetre)..."
SORTIE="$(bash "$DEPOT/rapatrier.sh" --sans-commit 2>&1)"
CODE=$?
echo "$SORTIE"

if [ $CODE -ne 0 ]; then
  RESULTAT="ECHEC du ramassage"
else
  # du neuf = un changement ailleurs que dans le compte rendu horodate
  NEUF="$(git status --porcelain -- pc index gabarits mesures outils 2>/dev/null | wc -l | tr -d ' ')"
  if [ "$NEUF" -gt 0 ]; then
    RESULTAT="$NEUF fichiers ajoutes ou modifies"
  else
    RESULTAT="rien de nouveau"
  fi
fi

# --- 3. la trace : au plus une par jour -----------------------------------
DERNIERE_TRACE=""
[ -f "$TRACE" ] && DERNIERE_TRACE="$(grep -oE '^\| [0-9]{2}/[0-9]{2}/[0-9]{4}' "$TRACE" 2>/dev/null | head -1 | tr -d '| ')"

if [ "$NEUF" = "0" ] && [ "$DERNIERE_TRACE" = "$AUJOURDHUI" ] && [ $CODE -eq 0 ]; then
  echo "Rien de nouveau et la trace du jour est deja ecrite : aucun commit."
  git checkout -- RAPATRIEMENT.md 2>/dev/null
  git checkout -- index 2>/dev/null
  echo "=== termine ==="
  return 0
fi

ANCIENNES=""
if [ -f "$TRACE" ]; then
  ANCIENNES="$(grep -E '^\| [0-9]{2}/' "$TRACE" 2>/dev/null | head -13)"
fi

{
  echo "# Rapatriement automatique"
  echo
  echo "**Derniere execution : $MAINTENANT — $RESULTAT.**"
  echo
  echo "La tache Windows « Rapatriement Golden Team » relance le rapatriement chaque nuit a 3 h."
  echo "Si le PC est eteint a cette heure-la, le passage se fait au demarrage suivant."
  echo "Elle ne commite que s'il y a du neuf, ou une fois par jour pour dire qu'elle est passee."
  echo
  echo "> **Si la date ci-dessus a plus de deux jours, la tache ne tourne plus.**"
  echo "> Recoller la ligne 2 de [\`COMMANDE.md\`](COMMANDE.md) dans Git Bash pour la remettre en place."
  echo
  echo "| Passage | Resultat |"
  echo "|---|---|"
  echo "| $MAINTENANT | $RESULTAT |"
  [ -n "$ANCIENNES" ] && echo "$ANCIENNES"
  echo
  echo "Journaux detailles des passages : \`~/.rapatriement-journaux/\` sur le PC (30 derniers jours)."
} > "$TRACE"

# --- 4. commiter, pousser, verifier ---------------------------------------
git add -A >/dev/null 2>&1
if git diff --cached --quiet 2>/dev/null; then
  echo "Rien a commiter."
  echo "=== termine ==="
  return 0
fi

git commit -q -m "Rapatriement automatique — $MAINTENANT — $RESULTAT" || {
  echo "ECHEC DU COMMIT."; return 1; }

echo "Envoi vers GitHub en cours..."
ATTENTE=2
POUSSE=0
for essai in 1 2 3 4 5; do
  if git push -q -u origin main 2>/dev/null; then POUSSE=1; break; fi
  echo "  envoi refuse (tentative $essai), on reprend les nouveautes de GitHub et on recommence..."
  # si GitHub a recu un autre commit entre-temps (l'agent de calcul, une session),
  # le push est refuse tant qu'on ne l'a pas integre : on l'integre, puis on reessaie.
  git pull -q --rebase origin main 2>/dev/null || git rebase --abort 2>/dev/null
  sleep $ATTENTE; ATTENTE=$((ATTENTE*2))
done

LOCAL="$(git rev-parse HEAD)"
DISTANT="$(git ls-remote origin refs/heads/main 2>/dev/null | cut -f1)"
if [ "$POUSSE" -ne 1 ] || [ "$LOCAL" != "$DISTANT" ]; then
  echo "LE TRAVAIL N'EST PAS SAUVE : local $LOCAL, distant ${DISTANT:-aucun}."
  echo "=== termine (echec du push) ==="
  return 1
fi

echo "SAUVE ET VERIFIE : https://github.com/Powerfincash/golden-team-fork8-context/commit/$LOCAL"
echo "=== termine ==="
return 0

}

# lancee par la tache Windows : tout va au journal. Lancee a la main dans une
# fenetre : on affiche aussi a l'ecran, sinon la fenetre reste vide jusqu'a la fin.
if [ -t 1 ]; then
  executer 2>&1 | tee "$JOURNAL"
  CODE_FINAL=${PIPESTATUS[0]}
else
  executer > "$JOURNAL" 2>&1
  CODE_FINAL=$?
fi

# menage : on garde 30 jours de journaux
find "$JOURNAUX" -type f -name '*.log' -mtime +30 -delete 2>/dev/null

exit $CODE_FINAL
