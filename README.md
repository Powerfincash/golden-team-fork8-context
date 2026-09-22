# Golden Team Fork 8 — dépôt de contexte

Ce dépôt est **le pont entre deux sessions**. Une session infonuagique n'a aucun accès au PC :
ce qui n'est pas poussé ici n'existe pas pour la suivante.

## Par où commencer

| Ordre | Fichier | Ce qu'il dit |
|---|---|---|
| 1 | **[`ETAT.md`](ETAT.md)** | Où on en est : décidé, en cours, bloqué, prochain geste. **Seule source sur l'état vivant.** |
| 2 | [`memory/MEMORY.md`](memory/MEMORY.md) | Index des ~73 mémoires. Suivre les liens du sujet du jour, pas tout lire. |
| 3 | [`RESULTATS_CORRIGES.md`](RESULTATS_CORRIGES.md) | Chiffres vérifiés des chaînes MT4 du 20-21/09. |
| 4 | [`CLAUDE.md`](CLAUDE.md) | Consignes de processus : lancement MT4/MT5, mesure, crible, forme des réponses. |

`chaine_mt4_20260920.log` est la pièce justificative brute. On l'ouvre pour contester une ligne
précise, jamais pour se mettre au courant.

## Sauvegarder

```bash
./sauver.sh "ce qui a changé"
```

Date `ETAT.md`, commite, pousse, et **vérifie que le dépôt distant a bien reçu le commit** avant
d'annoncer quoi que ce soit. Tant que le script n'a pas rendu un lien de commit, rien n'est sauvé.

Sur un clone local où l'on commite à la main : `./sauver.sh --installer-hook` pose un hook qui
pousse après chaque commit. Un hook ne se clone pas — à reposer dans chaque nouveau clone.

## Pas de règle d'état dans ce fichier

Aucun chiffre ni aucun état ne doit être recopié ici : ce README a porté pendant une journée une
ligne de résultat fausse (une attribution inversée dans le log) que personne ne pouvait dater.
**L'état vit dans `ETAT.md`, à un seul endroit.**

## Rapatrier ce qui est encore sur le PC

Une seule commande à coller dans Git Bash, dans **[`COMMANDE.md`](COMMANDE.md)**. Elle ramène ici
les outils, les réglages `.set`, les configurations, le code des robots maison, les gabarits de
pages et l'index des rapports, puis vérifie que GitHub a bien reçu le commit.

[`INVENTAIRE.md`](INVENTAIRE.md) dit ce qui entre, ce qui reste dehors, et pourquoi.
[`gabarits/`](gabarits/) contient la page « Quatre Standards » et ses règles : **on la reprend
telle quelle, on ne réinvente jamais sa mise en page.**

> Note : `fork8_context.bundle` est listé dans `.gitignore` et n'est donc **pas** dans ce dépôt.
