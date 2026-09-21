#!/usr/bin/env bash
# sauver.sh — « sauvé » veut dire « disponible partout », pas « commité ici ».
#
#   ./sauver.sh "ce qui a changé"
#
# Un seul geste : met ETAT.md à la date du jour, commite tout, pousse, et VÉRIFIE
# que le dépôt distant a bien reçu le commit avant de dire quoi que ce soit.
# Un script de sauvegarde qui échoue en silence est pire que pas de sauvegarde.
#
#   ./sauver.sh --installer-hook   pose un hook qui pousse après chaque commit
#                                  (pour les clones locaux où l'on commite à la main)
#   ./sauver.sh --force "..."      passe outre le garde-fou des identifiants

set -u

racine=$(git rev-parse --show-toplevel 2>/dev/null) || {
  echo "ÉCHEC : pas un dépôt git." >&2; exit 1; }
cd "$racine" || exit 1

# ---------------------------------------------------------------- hook local
if [ "${1:-}" = "--installer-hook" ]; then
  mkdir -p .git/hooks
  cat > .git/hooks/post-commit <<'HOOK'
#!/usr/bin/env bash
# Pose par sauver.sh --installer-hook : rien ne reste sur cette machine seule.
branche=$(git rev-parse --abbrev-ref HEAD)
echo "[hook] envoi de $branche vers origin..."
if git push -u origin "$branche" >/dev/null 2>&1; then
  echo "[hook] POUSSÉ : $(git rev-parse --short HEAD)"
else
  echo "[hook] ÉCHEC DU PUSH — le travail n'est PAS sauvé. Lancer ./sauver.sh" >&2
fi
HOOK
  chmod +x .git/hooks/post-commit
  echo "Hook posé : chaque commit de ce clone sera poussé automatiquement."
  echo "Note : un hook ne se clone pas. À reposer dans chaque nouveau clone."
  exit 0
fi

force=0
if [ "${1:-}" = "--force" ]; then force=1; shift; fi
message=${1:-"point de sauvegarde"}

# -------------------------------------------------------- date de l'état
if [ -f ETAT.md ]; then
  aujourdhui=$(date +%d/%m/%Y)
  sed -i.bak -E "s#^\*\*À jour au : .*\*\*#**À jour au : ${aujourdhui}**#" ETAT.md
  rm -f ETAT.md.bak
fi

git add -A

if git diff --cached --quiet; then
  echo "Rien de nouveau à commiter."
else
  # ------------------------------------------- garde-fou identifiants
  if [ "$force" -eq 0 ]; then
    # Motif assemblé par morceaux : la ligne ci-dessous ne doit pas se
    # reconnaître elle-même quand on commite ce script.
    motif='lo''gin=|pass''word=|api''_key|secret''_key|tok''en[[:space:]]*='
    fuite=$(git diff --cached -U0 \
      | grep -E '^\+' \
      | grep -inE "$motif" || true)
    if [ -n "$fuite" ]; then
      echo "REFUS : des identifiants semblent partir dans le commit." >&2
      echo "$fuite" | head -5 >&2
      echo "Faux positif ? relancer avec : ./sauver.sh --force \"$message\"" >&2
      git reset >/dev/null
      exit 1
    fi
  fi
  git commit -q -m "$message" || { echo "ÉCHEC du commit." >&2; exit 1; }
  echo "Commité : $(git rev-parse --short HEAD)"
fi

# ------------------------------------------------------------------ push
branche=$(git rev-parse --abbrev-ref HEAD)

# Un clone `--depth 1` ne suit que sa branche d'origine : les autres branches
# n'ont alors aucune reference de suivi, et tout controle base sur @{u} annonce
# « non pousse » a tort. On elargit le refspec une fois pour toutes.
if [ "$(git config --get remote.origin.fetch)" != '+refs/heads/*:refs/remotes/origin/*' ]; then
  git config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
fi
attente=2
pousse=1
for essai in 1 2 3 4 5; do
  if git push -u origin "$branche" >/dev/null 2>&1; then pousse=0; break; fi
  echo "Push refusé (essai $essai). Nouvelle tentative dans ${attente}s..."
  sleep "$attente"; attente=$((attente * 2))
done

# --------------------------------------------- vérification côté distant
local_sha=$(git rev-parse HEAD)
distant_sha=$(git ls-remote origin "refs/heads/$branche" 2>/dev/null | cut -f1)

if [ "$pousse" -ne 0 ] || [ "$local_sha" != "$distant_sha" ]; then
  echo >&2
  echo "########################################################" >&2
  echo "# LE TRAVAIL N'EST PAS SAUVÉ. Il n'existe que sur cette machine." >&2
  echo "# local  : ${local_sha:0:7}" >&2
  echo "# distant: ${distant_sha:0:7}" >&2
  echo "########################################################" >&2
  exit 1
fi

url=$(git remote get-url origin | sed -E 's#(git@|https://)github.com[:/]#https://github.com/#; s#\.git$##')
echo
echo "SAUVÉ — le dépôt distant a le même contenu que cette machine."
echo "Branche : $branche"
case "$url" in
  https://github.com/*) echo "Commit  : $url/commit/$local_sha" ;;
  *)                    echo "Commit  : ${local_sha:0:7} sur $url" ;;
esac
