---
name: protocole-mesure-unique
description: Sa critique du 06/09 au soir — je mesurais sans cadre, avec des hypothèses héritées des fichiers copiés ; l'hypothèse d'exécution est désormais UNIQUE pour tout le livre
metadata:
  type: feedback
---

**Sa critique du 06/09/2026, la plus dure de la journée** : *« Tout était validé puis plus rien »*,
*« Je ne t'ai jamais demandé de travailler sans cadre. C'est toi qui dois faire correspondre la méthode
à l'objectif »*, *« un trader institutionnel senior, il est pas là le gars »*.

**Why — le mécanisme de la faute, nommé honnêtement :**

1. **Aucun protocole écrit avant de commencer.** Crible pour les EA commerciaux, moulinette pour les
   propriétés, protocole pour le moteur — mais rien pour Zebra. Chaque test improvisé à partir du
   fichier `.ini` le plus proche.
2. **L'hypothèse d'exécution héritée, pas décidée.** Certains `.ini` portaient `ExecutionMode=-1`,
   d'autres `0`. J'ai recopié sans choisir. D'où une comparaison entre Zebra AVEC délai et Wolf SANS,
   publiée comme une conclusion.
3. **Publication à chaque test au lieu d'une fois à la fin.** Huit prises de parole = huit occasions de
   me contredire. Une seule après la batterie complète en aurait produit zéro.
4. **Ses questions prises pour des tâches** au lieu d'entrées dans un protocole permanent.

**How to apply — le cadre, désormais fixe :**

- **Une seule hypothèse d'exécution pour tout le livre : ticks réels + délai aléatoire.** Entre
  optimiste et prudent, prendre le prudent. Soutenue par le seul compte réel connu sur ce mécanisme
  (−21,9 % contre un backtest à PF 1,77).
- **Une seule fenêtre** (2021-2024, celle de la référence UBS), **un seul lot** (0,01), **creux au jour**.
- **Critères d'admission fixés AVANT** : rapport annuel > 1, positif sur les deux moitiés, corrélation
  au livre < 0,5.
- **Dosage au sens du pire des deux moitiés**, jamais au sens du total.
- **Une seule prise de parole**, à la fin, avec un tableau par actif et une décision par actif.
- **Interdit** : ajouter un test en cours de route, changer un paramètre parce qu'un résultat déçoit,
  comparer deux mesures qui n'ont pas les mêmes conditions.
- Outil de garde : `outils/avant_publication.py "<produit>"` liste tout ce qu'il faut avoir lu avant
  d'annoncer un chiffre. Voir [[inventorier-avant-de-lancer]] et [[garde-fous-mesure]].

**Conséquence assumée** : Wolf EURUSD sort du livre (MT4 ne permet pas le délai), Zebra le remplace.
Résultat dans `forex/outils/LIVRE-06-09-2026.md`.


## Deux mesures du 07/09 qui doivent servir à tout le reste

**1. Le bruit du délai d'exécution est de ±15 %.** Cinq passages identiques (598 transactions chacun)
ont donné entre 315 et 365 $. **Aucun écart inférieur à 15 % entre deux variantes ne doit être
interprété.** C'est ce qui a permis de rejeter le plafond journalier : sa réponse (3,13 → 5,59 → 3,13)
tenait entièrement dans ce bruit.

**2. Une simulation après coup n'est pas une mesure.** J'ai annoncé un doublement du rendement prop firm
en coupant la journée à −50 $ dans un tableur. Codé pour de vrai (fermeture effective des positions),
l'effet disparaît et le livre se dégrade. Cause manquante à la simulation : la coupure **réalise** la
perte flottante, donc la journée se solde plus bas que le seuil. **Toute règle de gestion doit être
codée dans l'EA et mesurée, jamais appliquée après coup sur une courbe.**
