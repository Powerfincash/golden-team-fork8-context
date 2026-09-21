---
name: ubs-or-ticks-reels
description: "UBS chargé des 14 réglages or du concepteur = Gold Phantom à 1,5x l'exposition (rapport 3,51 contre 3,33) — le backtest ne réfute pas UBS, et les deux sont concentrés sur 50 positions"
metadata:
  type: project
---

Mesuré le 03/09/2026, XAUUSD.p M15, 99 % ticks réels, 10 000 $, 2021-2022.
Détail dans `forex/outils/RESULTAT-UBS-OR-03-09.md`, outil `analyse_rapport.py`.

| | net | %/an | creux fonds | rapport | PF | positions | 50 meilleures |
|---|---|---|---|---|---|---|---|
| Gold Phantom verrouillé | +5 569 $ | 24,8 % | 7,45 % | 3,33 | 1,54 | 1 816 | 104 % |
| UBS, 14 réglages or | +9 808 $ | 40,9 % | 11,64 % | 3,51 | 1,47 | 1 805 | 85 % |

**CORRIGÉ le 03/09 sur sa remarque : ce n'est PAS Gold Phantom à plus forte
exposition.** Les 14 réglages retracés dans le paquet du vendeur, identité
paramètre par paramètre (`outils/cmp_sets.py`) :

| origine | identité au preset | part du net |
|---|---|---|
| **Gold Reaper** (strategy4_H4, 5/6/7_H1) | 99,4 à 100 % | **47,9 %** |
| Goldtrade Pro (d/E/H) | 99,5 % | 19,9 % |
| Gold Phantom (Gold_a/b/c = strat1/2/3) | 99,4 % | 20,3 % |
| Goldbot One (dailyK) | 99,5 % | 7,0 % |
| Daytrade Pro + volatilité M15 | — | 4,9 % |

**Un mélange de quatre produits dominé par Gold Reaper**, pas une version dopée de
Gold Phantom. La ressemblance des totaux est une coïncidence d'agrégats.

**L'enseignement, plus fort ainsi** : mélanger quatre produits or, dont celui qui
fait 111 %/an en live, ne gagne que **5 % de rapport** sur Gold Phantom seul et
verrouillé. Confirmation directe qu'un combo de robots or ne diversifie rien.

**Concentration structurelle des cassures de tendance** : sans les 100 meilleures
positions (5,5 %), les deux robots sont perdants. Le test de concentration (règle 8)
ne départage pas deux cassures ; il mesure leur dépendance aux grands mouvements.

**Conséquence pour l'achat** : sur l'or, UBS achète le curseur `MaxTrades` et les
réglages Gold Reaper, pas un meilleur moteur. La vraie question à 1 699 $ reste
les 30 stratégies hors or, jamais mesurées.

**Incohérence à trancher** : creux fonds à 20 000 $ = 7,90 % dans `n7_dep_20000.htm`
contre 10,09 % dans [[levier-et-plafond]].

Voir [[profalgo-un-seul-moteur]], [[backtest-refute-ne-confirme-pas]], [[ea-commerciaux-or]].


## Le plancher de lot décide du capital minimum — SA question du 03/09

**Il a demandé de lui-même si un compte cent chez Vantage conviendrait.** Le
vendeur a répondu « oui » sans expliquer, et annonçait par ailleurs 600 $ de
minimum, 1 500 $ recommandé. **Sa question était la bonne, et voici pourquoi.**

Lot moyen mesuré : 0,0506 pour UBS + 14 réglages or à 10 000 $. Le
dimensionnement étant proportionnel au solde :

| solde | lot voulu | effet |
|---|---|---|
| 600 $ | 0,0030 | tout au plancher 0,01, positions **3,3× trop grosses** |
| 1 500 $ | 0,0076 | tout au plancher, **1,3× trop grosses** |
| 2 000 $ | 0,0101 | dimensionnement libre |

**Seuil : 1 976 $ sur compte standard.** En dessous, le robot est sur-exposé, pas
sous-exposé — et vivre au plancher coûte 28 % de rapport, mesuré le même jour
(voir [[maxalloweddd-est-un-lot]] : 3,34 → 2,42 quand 97,7 % des positions sont
au minimum).

**Sur compte cent le plancher vaut 100 fois moins : le seuil tombe à ~20 $.**
Donc sous 10 000 $, le compte cent n'est pas une option, c'est la condition.

**Recoupement, cohérent sans être une preuve (n=2)** : ses deux signaux à petit
dépôt sont ceux aux plus gros creux — Goldbot One 786 $ pour 25,8 %,
Gold Reaper New V2 2 1 603 $ pour 16,9 %.

**Ce qu'il a esquivé DEUX FOIS** : les fichiers de réglages du signal
New V2 2. « Le signal tourne toujours la dernière version » parle du robot, pas
des paramètres. C'est la question qui porte les 111 %/an.
