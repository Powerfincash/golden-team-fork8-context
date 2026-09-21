---
name: lazyalgo-multistrategy-state
description: État des deux projets MQL5 du dossier PU Prime et ce qui a été éliminé
metadata: 
  node_type: memory
  type: project
  originSessionId: abe78243-a1cf-47f1-943b-5af3296434e6
  modified: 2026-08-28T16:55:33.701Z
---

Deux EA dans `MQL5\Experts` du terminal PU Prime (`E62C655E...`), au 21/08/2026 :

**LazyAlgo** — couche exécution/risque complète et testée (sizing 1 %, TP 2R, BE 1R,
coupe-circuit −2 % par actif robuste au redémarrage, GMT auto-détecté, garde d'exposition
par devise, journal MFE/MAE, entonnoir). Trois indicateurs TradingView open-source
transcrits en MQL5 : Dynamic Reactor [CHE], Volume Weighted Momentum (Grumlop),
Protected Highs & Lows [TFO] — specs dans `Reference\INDICATEURS.md`. Le Dynamic Reactor
est **validé contre 13 alertes réelles** de l'utilisateur.
L'indicateur d'origine « LazyAlgo » (auteur futureao) n'expose **aucune sortie alertable**
et sa source est protégée : définitivement non automatisable. Ne pas y revenir.

**MultiStrategyEA** — cinq stratégies H1/H4/M15, instrumenté le 21/08 avec le journal de
contexte + MFE/MAE et l'entonnoir par stratégie. Sauvegarde :
`MultiStrategyEA_backup_20260821_161019`. L'ORB a été **testé et clos** : 82 % de son
profit venait de 2023, 2024 et 2025 plats.

**Why:** une soixantaine de configurations ont été mesurées et écartées ; le README de
LazyAlgo en tient la liste pour éviter de les refaire.

**Prochaine session (prévue) :** évaluer trois EA commerciaux du MQL5 Market que
l'utilisateur surveille — **The Gold Reaper**, **Smart Gold Hunter**, **Wolf Scalper**.
Méthode : télécharger les démos gratuites (elles tournent dans le Strategy Tester), tester
sur les ticks réels XAUUSD.p locaux **sans modifier les réglages du vendeur**, découper
**année par année**, garder 2026.07-08 hors échantillon, et mesurer le drawdown en flottant.
Pour Wolf Scalper, ajouter un test à **spread majoré** : un scalpeur dont la rentabilité
disparaît en passant de 15 à 25 points sur l'or n'a pas d'edge, seulement des conditions
idéales. Aucune évaluation indépendante n'existe sur ces produits — les sites de « revue »
trouvés sont des revendeurs ou affiliés.

**How to apply:** prochain effet mécanique prévu = **fin de mois** (flux de rééquilibrage
contraints). Voir [[backtest-acceptance-criteria]].

**Contrainte machine.** MT5 refuse de démarrer un test tant qu'une instance en exécute un,
et **sort avec le code 0** en n'écrivant aucun rapport : l'échec est silencieux. Toujours
vérifier `tasklist | grep terminal64` avant de lancer, ou passer par une file d'attente.
*Précisé le 28/08/2026 après l'avoir refait :* il ne suffit pas qu'aucune passe ne tourne.
Lancer `terminal64.exe /config:` alors qu'une **instance est simplement ouverte** ne
démarre rien — la commande **ferme le terminal existant** (`Terminal shutdown with 0` au
journal) et aucun rapport n'est écrit. Vérifier l'absence de `terminal64.exe`, pas
seulement de `metatester64.exe`, et fermer le terminal avant de lancer.
*Autre piège du même jour :* le trailing ATR appliqué à chaque tick a produit un
`Tester/logs/<date>.log` de **34 Go** en une heure (deux lignes par tick de `position
modified`). Brider toute modification de SL à un pas minimum avant de lancer une passe
longue, et surveiller la taille du journal.
Un backtest en passe unique n'utilise **qu'un seul agent** (les agents ne se parallélisent
que pour les optimisations) — donc 11 cœurs sur 12 restent inactifs pendant l'attente.
La machine avait 8 Go de RAM (1,2 Go libres, une seconde instance faisait swapper) ;
**passage à 24 Go prévu le 25/08/2026**, ce qui rend viables les instances portables en
parallèle et les optimisations multi-agents. Les fichiers `.ini` doivent reprendre la
section `[Common]` avec `Login=<son numero de compte, jamais ecrit ici>` / `Server=PUPrime-Demo`, sinon le lancement
échoue lui aussi en silence.

## Resultats du 22/08/2026 — combo DR + TFO + VWM porte en MQL5

Mode CONFLUENCE de LazyAlgo, **M5**, 2025.01 → 2026.06, ticks reels, TPI desactive
(temoin), stop structurel sur le niveau protege, plancher 1,5 ATR, TP 2R, BE 1R.
Configs archivees dans `Experts\LazyAlgo\Tester`, rapports `conf_*.htm`.

| Test | n | PF | net | DD equity |
|---|---|---|---|---|
| XAUUSD sans H1 | 202 | 0,90 | −887 | 16,7 % |
| **XAUUSD avec H1** | 123 | **1,11** | +564 | 10,2 % |
| EURUSD sans H1 | 216 | 0,97 | −384 | 19,8 % |
| EURUSD avec H1 | 137 | 1,05 | +365 | 14,2 % |

**Le filtre Dynamic Reactor H1 inverse le signe sur les deux actifs** — premier effet
qui se reproduit sur deux marches differents.

**Elimines par le decoupage temporel :** EURUSD avec H1 (PF 1,51 en 2025 mais **0,74 en
2026**, et tout le gain 2025 vient du seul S2 a PF 2,96) et les deux « sans H1 ».

**Seul survivant : XAUUSD M5 avec H1** — 2025-S1 : 1,05 / 2025-S2 : 1,24 / 2026-S1 :
1,20. Aucun semestre negatif, aucune concentration.

**Reserves lourdes, a ne pas oublier :** 123 trades seulement ; esperance +0,046 R par
trade, de l'ordre de la friction ; 3,7 %/an pour 10,2 % de DD, donc a peine mieux que le
portage de l'or et tres loin des reperes de [[reperes-chiffres-or]]. Et un doute
mecanique : 26 % de gagnants avec un TP a 2R ne devrait pas donner PF > 1 — **c'est
probablement le breakeven a 1R qui produit le resultat, pas la qualite des entrees.**
A tester en desactivant le BE.

**En cours pendant la nuit :** The Gold Reaper aux defauts, puis XAUUSD M5 avec H1 sur
**2023-2024** (`oos_XAU_H1.htm`), deux annees jamais vues. S'il s'effondre, on ferme.

**Les EA commerciaux :** The Gold Phantom et The Gold Reaper se terminent tous deux par
`some error after pass finished` et produisent un rapport VIDE. Seul **Smart Gold
Hunter** a donne un resultat complet (1368 trades, PF 1,43, positif chaque annee). Il
lui reste deux epreuves : le hors-echantillon 2026.07-08 et le test a spread majore.

## 28/08/2026 — levee de doute sur le breakeven (XAUUSD M5 + H1)

**Hors-echantillon 2023-2024 (`oos_XAU_H1.htm`, passe de la nuit du 22 au 23/08) : ne
s'effondre pas.** 145 trades, PF 1,13, +986, DD equity 9,2 %. La condition « s'il
s'effondre, on ferme » n'est pas remplie.

**Test BE desactive** (`InpBreakEvenTriggerR = 0.0`, seul changement, rapport
`nobe_XAU_H1.htm`, journal `LazyAlgo_journal_XAUH1_nobe.csv`), meme fenetre
2025.01-2026.06 :

| | BE actif | BE off |
|---|---|---|
| trades | 123 | 107 |
| PF | 1,11 | 1,04 |
| esperance | +0,075 R | +0,032 R |
| DD equity | 10,2 % | 12,4 % |
| Sharpe | 0,79 | 0,29 |

Decomposition en R — BE actif : TP 33 (+65,22), BE 36 (−0,89), SL 54 (−55,06) = **+9,26 R**.
BE off : TP 37 (+73,00), SL 69 (−70,92), 1 autre (+1,37) = **+3,45 R**.

**Reponse : le BE porte 63 % du resultat, mais pas la totalite.** Les entrees gardent un
residu positif (PF 1,04). Ce n'est donc pas un pur artefact de gestion — c'est un edge
marginal que le BE amplifie. **Aucune des deux versions ne passe les criteres du 21/08**
(≥ 300 trades, ≥ +0,10 R) : ~110 trades et +0,03 a +0,08 R.

*Limite :* les deux populations different de 16 trades (`InpMaxSimultaneousPositions=1` fait
que changer une sortie change les entrees suivantes). C'est une comparaison de deux
systemes, pas une decomposition propre.

**Bug corrige dans `Tools\verifier_passe.py` :** la fenetre `c[:180]` ne couvrait pas le
champ « Nb trades », donc le controle obligatoire annoncait « zero transaction — passe
inexploitable » sur TOUTES les passes, y compris la reference du 22/08. Sauvegarde
`.bak` conservee. Toute passe rejetee sur ce seul critere est a reexaminer.
