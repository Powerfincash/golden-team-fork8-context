# La commande

Des lignes à coller dans **Git Bash**, une fois pour toutes. La première rapatrie tout
maintenant ; la deuxième demande à Windows de recommencer chaque nuit ; la troisième met en
place l'agent de calcul, qui lance vos mesures tout seul.

**Les coller dans l'ordre.** La troisième a besoin de la première : sans elle, vos outils ne
sont pas dans le dépôt et l'agent n'a rien à lancer.

## 1. Rapatrier maintenant

```bash
cd ~ && if [ -d rapatriement-auto/.git ]; then git -C rapatriement-auto pull -q --rebase --autostash; else git clone -q https://github.com/Powerfincash/golden-team-fork8-context rapatriement-auto; fi && bash rapatriement-auto/rapatrier.sh
```

Elle va chercher sur le PC les outils, les réglages `.set`, les configurations, le code des robots
maison, les gabarits de pages, les journaux et l'index des rapports ; puis elle commite, pousse, et
**vérifie que GitHub a bien reçu le commit** avant d'écrire quoi que ce soit.

À la fin, l'une de ces deux lignes, et jamais autre chose :
- `SAUVE ET VERIFIE.` suivi du lien du commit → c'est sauvé, le lien le prouve.
- `LE TRAVAIL N'EST PAS SAUVE` → rien n'est parti, le message dit pourquoi.

Vous pouvez la recoller quand vous voulez : elle ne pousse que ce qui a changé.

## 2. Demander à Windows de recommencer chaque nuit

À coller **une seule fois**, après la première. Elle crée la tâche, l'affiche, et fait un passage
de preuve tout de suite.

```bash
schtasks //Create //TN "Rapatriement Golden Team" //SC DAILY //ST 03:00 //F //TR "\"$(cygpath -w "$(command -v bash)")\" -l \"$HOME/rapatriement-auto/auto.sh\"" && powershell -NoProfile -Command '$t = Get-ScheduledTask -TaskName "Rapatriement Golden Team"; $t.Settings.StartWhenAvailable = $true; Set-ScheduledTask -InputObject $t | Out-Null' && bash ~/rapatriement-auto/auto.sh && echo "C EST EN PLACE — passage de preuve fait"
```

Ce qu'elle met en place, et rien d'autre :
- un passage **chaque nuit à 3 h**, sous votre compte, sans droits administrateur ;
- le **rattrapage** : si le PC est éteint à 3 h, le passage se fait au démarrage suivant, il n'est
  pas perdu ;
- elle survit au redémarrage et ne peut pas se chevaucher avec elle-même.

Elle ne fait **aucun commit s'il n'y a rien de neuf**. Au maximum un par jour.

## 3. Mettre en place l'agent de calcul

À coller **après les deux premières**. Elle crée la tâche, l'affiche, et fait un passage de
preuve tout de suite.

```bash
schtasks //Create //TN "Calcul Golden Team" //SC MINUTE //MO 10 //F //TR "\"$(cygpath -w "$(command -v bash)")\" -l \"$HOME/rapatriement-auto/runner.sh\"" && powershell -NoProfile -Command '$t = Get-ScheduledTask -TaskName "Calcul Golden Team"; $t.Settings.StartWhenAvailable = $true; Set-ScheduledTask -InputObject $t | Out-Null' && bash ~/rapatriement-auto/runner.sh && echo "L AGENT DE CALCUL EST EN PLACE"
```

À partir de là, vous déposez un `.ini` dans le dossier **`jobs/`** du dépôt — depuis le
téléphone si vous voulez — et l'agent s'en occupe dans les dix minutes. Comment faire et où
lire le résultat : [`jobs/LISEZMOI.md`](jobs/LISEZMOI.md).

Ce qu'elle met en place, et rien d'autre :

- un **regard dans `jobs/` toutes les dix minutes**, sous votre compte, sans droits administrateur ;
- **une seule passe à la fois** : tant qu'un test tourne, l'agent ne fait rien d'autre, même
  si le test dure huit heures ;
- **le rattrapage** : si le PC était éteint, l'agent reprend au démarrage suivant, la file
  n'est pas perdue.

Elle n'installe **rien de neuf sur le PC** : elle se sert de vos lanceurs existants,
`lance_chaine.ps1` pour MT5 et `lancer_mt4.sh` pour MT4.

### Si une passe en cours vous gêne dans la journée

Pour que l'agent ne travaille qu'à partir de 22 h, coller ceci — et rien d'autre à changer :

```bash
schtasks //Create //TN "Calcul Golden Team" //SC DAILY //ST 22:00 //F //RI 10 //DU 10:00 //TR "\"$(cygpath -w "$(command -v bash)")\" -l \"$HOME/rapatriement-auto/runner.sh\"" && echo "L AGENT NE TRAVAILLERA QU A PARTIR DE 22 H"
```

### Pour arrêter l'agent de calcul un jour

```bash
schtasks //Delete //TN "Calcul Golden Team" //F
```

## Voir d'un coup d'œil si ça tourne encore

Deux fichiers à la racine du dépôt, un par tâche.

- **[`AUTOMATIQUE.md`](AUTOMATIQUE.md)** — le rapatriement. Sa première ligne donne la date du
  dernier passage et son résultat, suivie des quatorze derniers. **Si cette date a plus de deux
  jours, la tâche ne tourne plus** : recoller la ligne 2.
- **[`RUNNER.md`](RUNNER.md)** — l'agent de calcul. Même principe, plus le nombre de demandes
  en attente. **Si cette date a plus de deux heures alors que le PC est allumé**, il ne tourne
  plus : recoller la ligne 3.

## Si GitHub demande de se connecter

Une fenêtre de connexion GitHub peut s'ouvrir la première fois. Se connecter avec le compte
**Powerfincash** ; Windows retient ensuite le mot de passe et ne le redemande plus.

## Pour tout arrêter un jour

```bash
schtasks //Delete //TN "Rapatriement Golden Team" //F
```

La tâche disparaît ; le dépôt et tout ce qu'il contient restent intacts, et la ligne 1 continue de
marcher à la demande.

## Ce que tout cela ne fera jamais

- Copier un fichier contenant `Lo` + `gin=`, un mot de passe ou une clé d'API. Ces fichiers sont
  écartés et seul leur chemin est noté dans `index/identifiants-exclus.txt`.
- Copier les ticks, les rapports HTML bruts, les journaux géants ou les binaires `.ex4` / `.ex5`.
  Voir [`INVENTAIRE.md`](INVENTAIRE.md) pour le détail et les raisons.
- Toucher à quoi que ce soit sur le PC : ça lit et ça copie, ça n'efface et ne déplace rien.
