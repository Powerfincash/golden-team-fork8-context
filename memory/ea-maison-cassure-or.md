---
name: ea-maison-cassure-or
description: Decision du 04/09/2026 - construire un EA maison de cassure sur l'or, reproduction ouverte du mecanisme Profalgo, pour l'independance et pour pouvoir le challenger ; criteres fixes d'avance
metadata:
  type: project
---

Decide par lui le 04/09/2026 vers 09h10 : « cela vaut la peine pour l'independance vis-a-vis de
Profalgo et pour etre libre de le challenger, voire l'ameliorer par d'autres pistes ».

**Le mecanisme a reproduire** (lisible dans les sets UBS, jamais code par nous) : cassure S/R
(`Run_Strategy=1`, ordres stop empiles, `MaxTrades`/`MinDist_orders`) et cassure de volatilite
(`Run_Strategy=2`, bougie > `DevFactor` x ATR en M15), geometrie quasi symetrique
(`Exit_stop` 1300 / `Exit_limit` 1700 points sur l'or), stops virtuels, plafond d'ecart, NFP,
vendredi. Ce que Phantom n'expose pas et qu'on veut piloter : le nombre d'entrees simultanees
(12 en une minute le 30/05/2024) et le dimensionnement.

**Criteres fixes d'avance** (avant tout backtest) : >= 300 transactions sur 2021-2024 en ticks
reels XAUUSD.p ; rapport rendement / creux max de solde (pic glissant, `mesure.py`) >= 6,0, la
valeur de Gold Phantom mesuree le 04/09 ; plateau de reglages voisins, pas un pic. S'il echoue,
la piste maison est fermee par un chiffre.

**RESULTAT 04/09 09h57 (verifie C1-C4)** : v1 (H1 3/3, distances fixes) PF 1,01 = zero, parce
qu'infidele au jeu ; v2.01 fidele a `DaytradePro_XAUUSD` (niveaux W1 force 4/2, cadence D1, ordres
408 h, distances x ATR_W1(30)/2900) : **PF 1,51, 60 % de reussite, mais 65 transactions en 4 ans et
rapport 0,74** (t ~ 1,6). Piste « un EA = un jeu » FERMEE par la regle d'arret. Ce que ca etablit :
le rapport 5-7 de Reaper/UBS est celui d'un portefeuille de 9 a 14 jeux, pas d'un jeu. Un moteur
multi-jeux serait un autre projet, a sa decision. Piege trouve en passant : a l'ouverture D1 (01h00)
le marche est ferme, il faut reessayer au tick suivant (14 896 refus sinon).

**How to apply:** protocole ecrit et soumis avant de lancer ; une version numerotee a la fois ;
mesurer avec `mesure.py` uniquement. Voir [[meilleur-a-ce-jour]], [[deux-livrables-attendus]],
[[backtest-acceptance-criteria]], [[profalgo-un-seul-moteur]], [[mt5-pieges-outillage]].
