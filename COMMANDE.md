# La commande

Ouvrir **Git Bash** sur le PC, coller cette ligne, appuyer sur Entrée. C'est tout.

```bash
cd ~ && D="rapatriement-$(date +%Y%m%d-%H%M%S)" && git clone -q https://github.com/Powerfincash/golden-team-fork8-context "$D" && bash "$D/rapatrier.sh"
```

Elle fait tout, dans l'ordre : elle récupère le dépôt, elle va chercher sur le PC les outils, les
réglages, les configurations, le code des robots maison, les gabarits de pages et les journaux,
elle dresse l'index des rapports de backtest, elle commite, elle pousse, **et elle vérifie que
GitHub a bien reçu le commit avant d'écrire quoi que ce soit.**

## Ce qu'on voit à l'écran

- Chaque dossier trouvé s'affiche pendant qu'il est parcouru.
- Un dossier absent ne fait rien planter : la commande passe au suivant.
- À la fin, l'une de ces deux lignes, et jamais autre chose :
  - `SAUVE ET VERIFIE.` suivi du lien du commit → c'est sauvé, le lien le prouve.
  - `LE TRAVAIL N'EST PAS SAUVE` → rien n'est parti, le message dit pourquoi.

## Si GitHub demande de se connecter

Une fenêtre de connexion GitHub peut s'ouvrir la première fois. Se connecter avec le compte
**Powerfincash** ; Windows retient ensuite le mot de passe et ne le redemande plus.

## Pour recommencer plus tard

La même ligne, telle quelle. Elle repart d'un dépôt neuf à chaque fois et ne pousse que ce qui a
changé. Si rien n'a changé, elle le dit et s'arrête.

## Ce qu'elle ne fera jamais

- Copier un fichier contenant `Lo` + `gin=`, un mot de passe ou une clé d'API. Ces fichiers sont
  écartés et seul leur chemin est noté dans `index/identifiants-exclus.txt`.
- Copier les ticks, les rapports HTML bruts, les journaux géants ou les binaires `.ex4` / `.ex5`.
  Voir [`INVENTAIRE.md`](INVENTAIRE.md) pour le détail et les raisons.
- Toucher à quoi que ce soit sur le PC : elle lit et copie, elle n'efface et ne déplace rien.
