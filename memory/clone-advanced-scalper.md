---
name: clone-advanced-scalper
description: "Sa consigne du 10/09/2026 — cloner Advanced Scalper en MQL5 en partant de Zebra, même famille de mécanisme"
metadata: 
  node_type: memory
  type: project
  originSessionId: c8bdaad5-dac5-4fdf-8d5a-2dc87bb80f85
  modified: 2026-09-10T07:11:58.328Z
---

## RÉSOLU LE 10/09 — et sans écrire de clone

**Son idée, meilleure que la mienne** : *« Donc on peut déjà trader advanced scalper USDJPY au départ
de UBS MT5 ? »* Oui. Advanced Scalper et UBS sont **le même moteur du même éditeur** et lisent les
mêmes paramètres. Il a suffi de **traduire le jeu**, pas d'écrire un EA.

**Trois transformations** : `ST1_MagicNumber` → `EA_MagicNumber`, `ST1_Comment` → `EA_Comment`,
`Entry_Timing=60` (minutes MT4) → `16385` (code MQL5). Plus `ForceSymbol`, `ST1_Timeframe=16385`,
`MaxTrades=5`. Méthode qui a fait la différence : **partir d'un jeu UBS qui tourne déjà** et n'y
écraser que ce qu'Advanced Scalper définit — il manquait plus de cent clés autrement.

**Validé 2021-2024** : 1 509 ordres contre 1 473 (+2,4 %), 769 déclenchements contre 717 (+7,3 %),
**SL à 22,0 pips exact sur les 1 509**. Net +1 622 $ contre +1 066,93 $ — écart dû à la donnée
(TDS/MT4 contre ticks réels PU Prime/MT5), pas au mécanisme. **Ce net ne sert PAS à réestimer le
portefeuille.** Détail : `outils/CLONE-ADVANCED-SCALPER.md`.

**En service depuis le 10/09 11:12** sur Ultima MT5, `USDJPY.sc` H1, magic 997, lot 0,01.

**Piège majeur réfuté** : il n'existe **AUCUN** facteur pips→points entre MT4 et MT5 chez cet
éditeur. J'avais supposé qu'un pip MT4 valait 10 points ; mesure : `Exit_stop=220` a produit 2,200 en
prix, soit 220 pips. La réfutation est écrite dans `EagleOwl_v2.mq5` pour qu'elle ne soit pas
réintroduite.

## Ce qui reste : Eagle-owl v2, la voie maison

`EagleOwl_v2.mq5` est écrit (entrée `Format_MT4`). Il ne sert plus au banc — UBS fait le travail —
mais il reste **la seule voie chez Axi Select**, où les EA commerciaux sont interdits en algo. À
valider contre la même cible le jour où cette maison redevient d'actualité.

---

*Consigne d'origine, conservée pour mémoire :* écrire le clone MQL5 d'Advanced Scalper en partant de
Zebra.

## Pourquoi c'est la bonne voie

Advanced Scalper n'existe qu'en **MT4**. Trois solutions étaient sur la table : le laisser sur MT4
(marge séparée), le recopier sur MT5 par un copieur, ou le cloner. Le copieur pose trois problèmes
que le clone supprime d'un coup :

1. **Il risque de transformer le mécanisme.** Un copieur qui réplique les *positions* envoie un
   ordre AU MARCHÉ à la destination — or Advanced Scalper travaille en **ordres en attente**. Ça le
   ferait entrer au pire moment, quand le niveau casse et que l'écart s'ouvre.
2. **Ses stops sont VIRTUELS** (`useVirtualStops=1`, `VirtualSL_Safety_Hardstop_dist=0`) : la
   position copiée n'aurait **aucun stop chez le courtier**. Si la chaîne lâche (MT4 éteint, copieur
   déconnecté), position ouverte sans filet sur du réel.
3. **Il contamine la mesure** : on ne mesurerait plus le glissement d'Ultima mais celui du copieur
   plus celui d'Ultima.

## Ce qui rend le clone facile : c'est la famille de Zebra

Même mécanisme de fond — **cassure de niveau, ordre stop en attente, SL/TP fixes, expiration** :

| | Zebra | Advanced Scalper (`as_a5_usdjpy.set`) |
|---|---|---|
| définition du niveau | ZigZag(12, 5, 3) | `ST1_HL_strength_L=20`, `R=5`, `ST1_countback=120` |
| prix de l'ordre | le pivot EXACT | le niveau ± `ST1_UpDiff=0.5` / `ST1_DownDiff=0` |
| ordres simultanés | 1 par sens | `ST1_MaxPendingOrders=5` |
| distance minimale | `InpStopsLevelMin` | `MinDist_orders=1`, `ST1_MinDist_to_HL=30` |
| expiration | 100 h | `ST1_Expiration_hours=120` |
| stop / objectif | 200 pts / 200 pts | `Exit_stop=22` / `Exit_limit=50` |
| stops | réels | **virtuels** (`useVirtualStops=1`) |
| filtres | aucun | `SpreadFilter=true, MaxSpread=3`, `SkipNFP=true`, `FridayStopHour=18` |

**Les vrais écarts à construire**, au-delà du squelette de Zebra : la définition du niveau par
force gauche/droite (fractale) au lieu du ZigZag, le décalage `UpDiff`/`DownDiff` par rapport au
niveau, les 5 ordres simultanés au lieu d'un, et le filtre d'écart. Les stops virtuels sont à
**mesurer avant de décider** de les reproduire ou de poser des stops réels.

## Références de mesure

Jeu de référence `as_a5_usdjpy.set` (H1, magic 997, commentaire `Adv_Scalp_USDJPY_H1SL22`), mesuré
en `n4_as_USDJPY` sur MT4 Vantage : **+106,7 $, creux 8,3 $, rapport 3,23, corrélation −0,08 avec
l'or**. C'est le **meilleur candidat hors or jamais mesuré** du livre — voir
[[portefeuille-trois-jambes]]. Réserve à ne pas oublier : 2022 apporte la moitié du résultat, et son
rapport sur 21 ans tombe à 0,37.

La recette est celle qui a déjà marché une fois : voir `outils/SPEC-CLONE-WOLF.md` et
[[clone-wolf-or-gbpusd]]. Critère de jugement identique — le **gain net par transaction** rapporté
au seuil de rupture, et il faut **gagner sur les deux moitiés**, pas sur la fenêtre entière.

Une fois cloné : plus de copieur, plus de second terminal, plus de stops virtuels, et la brique
rejoint le compte propre sur MT5 avec marge partagée. Voir [[banc-mesure-ultima]].
