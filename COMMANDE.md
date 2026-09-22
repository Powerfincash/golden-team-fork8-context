# La commande

Deux lignes à coller dans **Git Bash**, une fois pour toutes. La première rapatrie tout
maintenant ; la seconde demande à Windows de recommencer chaque nuit, tout seul.

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

## Voir d'un coup d'œil si ça tourne encore

**[`AUTOMATIQUE.md`](AUTOMATIQUE.md)**, à la racine du dépôt. Sa première ligne donne la date du
dernier passage et son résultat, suivie des quatorze derniers. **Si cette date a plus de deux
jours, la tâche ne tourne plus** : recoller la ligne 2.

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
