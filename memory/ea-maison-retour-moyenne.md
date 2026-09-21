---
name: ea-maison-retour-moyenne
description: L'EA maison retour a la moyenne est clos — et les deux tests qui l'ont tue, a refaire systematiquement
metadata:
  type: project
---

Clos le 03/09/2026. Détail complet dans `forex/outils/EA-MAISON-VERDICT.md`,
moteur dans `forex/outils/retour_moyenne.py`.

**Ce qui était vrai** : un filtre de régime existe. Le rapport de variance glissant
sur 500 barres H1 sélectionne de meilleures entrées — mais **dans le sens inverse
de l'intuition**, il faut entrer quand VR est ÉLEVÉ. Contrôle passé : à proportion
de barres retenues identique, un filtre d'ATR au-dessus de la médiane donne
l'inverse (USDCAD +2 762 contre −405). Ce n'est donc pas un filtre de volatilité.

**Ce qui l'a tué, et c'est la leçon** :

1. **Ne jamais juger une stratégie sur une somme de pips.** La courbe en pips était
   belle (+11 822 pips, creux 2 310) ; le même jeu de transactions ramené au risque
   donne un rapport de **0,2** — exactement l'alternative à battre (10 %/an pour −47 %).
   Les pips venaient des périodes à fort ATR, où chaque pip pèse peu de risque.

2. **Le test de concentration est obligatoire.** Retirer les 50 meilleures
   transactions sur 9 753 : il reste +0,008 R par transaction, indiscernable de zéro.
   Cinquante transactions portaient 73 % de quinze ans de résultat.

**Sa proposition de jambe de tendance, testée et réfutée** : pullback continuation,
négative sur 6 marchés sur 7 (−6 853 pips), et elle perdait précisément les années
qu'elle devait sauver (2018 −1 335, 2020 −1 545, 2022 −2 049). Cause : 40 % de
réussite pour un rapport 3:2, c'est le point mort exact avant frais.

La suite n'est pas un EA maison mais [[levier-et-plafond]].
