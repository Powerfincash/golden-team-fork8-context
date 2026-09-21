---
name: pas-de-formule-de-portefeuille
description: "Ce qu'une jambe apporte au portefeuille ne se prédit par aucune formule — deux tentatives réfutées la même nuit, seule la mesure à creux égal décide"
metadata: 
  node_type: memory
  type: project
  originSessionId: ad015105-f722-4c5f-9697-c4b1c268474a
  modified: 2026-09-02T23:27:22.512Z
---

Nuit du 02 au 03/09/2026. J'ai proposé **deux formules** pour décider si un robot
mérite d'entrer au portefeuille. **Les deux ont été réfutées par la mesure en
moins d'une heure.**

| formule | prédiction | mesure |
|---|---|---|
| `qualité(B) > corrélation × qualité(A)` → à corrélation nulle tout candidat rentable entre | Advanced Scalper admis | **il dilue : −0,5 point** partout |
| loi en **√N** puis `√(Q² + q²)` | Revert Edge : +1,5 % | **+22 %** |

La seconde échoue parce qu'un rapport rendement/creux **n'est pas un ratio de
Sharpe** : un creux dépend du chemin, et deux jambes qui reculent à des moments
différents se protègent bien plus que l'algèbre quadratique ne le dit.

**Ce que la mesure dit** (fenêtre commune, creux au jour, aucune correction) :

| | corrélation avec Phantom | rapport propre | apport à creux égal |
|---|---|---|---|
| Revert Edge | −0,087 | 0,87 | **+11,4 pts, soit +22 %** |
| Advanced Scalper | −0,014 | 0,17 | **−0,5 pt** |

Les deux sont décorrélés : **la corrélation ne les départage pas**, la qualité
propre décide. Revert Edge est cinq fois meilleur.

**Le seul protocole qui tienne**, quatre étapes et trois minutes par candidat :
mesurer sa courbe sur fenêtre commune → combiner les courbes quotidiennes →
ramener chaque répartition au creux du portefeuille actuel en jouant le levier
(`outils/plafond.py`) → garder si le rendement monte à creux égal.

La corrélation reste un **filtre d'entrée bon marché** : au-delà de +0,5 un
candidat n'a pratiquement aucune chance, on s'épargne la mesure. En dessous, elle
ne décide de rien.

**Chiffre solide qui en sort** : Gold Phantom 50 / Revert Edge 50 au levier 2,06
donne **62,0 %/an pour 10,2 % de creux** (2012-2020, données importées non
corrigées), contre 50,7 % pour Gold Phantom seul au même creux.

Voir [[levier-et-plafond]], [[backtest-acceptance-criteria]], [[inventorier-avant-de-lancer]].

**Correlations mesurees le 05/09/2026 (nets mensuels, 2021-2024, 48 mois, lot fixe)** : entre moteurs OR, tout est
correle : UBS or x Reaper +0,77, UBS or x Phantom +0,69, Reaper x Phantom +0,69, moteur maison x UBS +0,84 ; pire
mois commun a tous : aout 2024. Trois produits or = un produit et demi. Avec d'autres actifs, correlation NULLE :
UBS or x Wolf EURUSD −0,02, x Advanced Scalper USDJPY −0,08, x Revert Edge SP500 −0,20 (3 a 4 mois negatifs communs
sur 12). C'est la que serait la diversification — mais chaque jambe hors or a son probleme (Wolf jamais verifie en
reel, Advanced Scalper faible, Revert Edge retire). Les 30 jeux hors or d'UBS n'avaient que 2 mois de mesure
(n12) ; passage 2021-2024 lot fixe lance le 05/09 a 13h50 (`n50_ubs_horsor_2124`).

**Or + Wolf, mesure a creux egal (05/09, courbes journalieres 2021-2024, lot fixe)** : Wolf EURUSD seul par 0,01 lot :
+19 $/an pour 9 $ de creux (rapport 2,3, ticks modelises MT4). Ajoute a UBS or avec 12 lots de Wolf pour 1 de l'or :
rapport 4,33 -> 6,13, soit +41 % de rendement a creux egal (+2 082 contre +1 471 $/an) ; sur Reaper : 4,15 -> 5,00
(+21 %). C'est la seule jambe du dossier qui ameliore le rapport de l'or a creux egal — sur papier : Wolf n'a jamais
ete mesure en reel, son avantage vaut ~1 pip et le modele MT4 le flatte. Condition avant d'y croire : essai en avant
de Wolf sur demo au lot minimal. Voir [[wolf-scalper-projet]], [[levier-et-plafond]].
