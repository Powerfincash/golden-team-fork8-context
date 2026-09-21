---
name: profalgo-un-seul-moteur
description: "Les quatre robots or de Profalgo sont un seul moteur à quatre niveaux d'exposition — Gold Phantom est verrouillé, UBS est le moteur ouvert"
metadata: 
  node_type: memory
  type: project
  originSessionId: ad015105-f722-4c5f-9697-c4b1c268474a
  modified: 2026-09-03T06:21:36.894Z
---

Établi le 03/09/2026 en analysant ses **305 fichiers de réglages** (paquet
`UPDATED_SETS_UBS_V7_0`) et ses **29 signaux live**. Rapport complet dans
`forex/outils/PROFALGO-CE-QUE-J-AI-TROUVE.md`.

**Un seul moteur, quatre niveaux d'exposition.** Gold Phantom et Gold Reaper :
même architecture à 9 stratégies, mêmes familles D1/H4/H1, **64 à 73 % de
paramètres identiques**. Ce qui les sépare est `MaxTrades` :

| | positions/stratégie | creux live |
|---|---|---|
| Goldbot One | 1 | 25,8 % |
| Gold Phantom | 1 à 5 | 8,6 % (7 mois) |
| Gold Reaper | 5 à 99 | 17 à 46 % |
| Goldtrade Pro | 99 partout | 32,0 % |

**Donc un combo de robots or ne diversifie rien** — même moteur, même métal.
Ses propres combos le confirment : rapport moyen 1,66 contre 1,52 pour ses
simples, et le meilleur simple (Gold Reaper New V2, 6,53) écrase le meilleur
combo (2,45).

**Gold Phantom expose 77 paramètres, un `.set` du paquet en porte 229.** Aucun
paramètre de stratégie n'est exposé. Les produits vendus sont le moteur
**Ultimate Breakout System** verrouillé sur des presets — l'en-tête des fichiers
le dit : « Ultimate_Breakout_EA_WSC_V1.0 ». **Les 305 réglages sont inutilisables
avec Gold Phantom.**

**Le paquet couvre 14 marchés** (XAUUSD 115 jeux, BTCUSD 35, EURUSD 29, US30 28,
USTEC 21, USDJPY 20, US500 15, TSLA 14, XAGUSD, DE40, XTIUSD…) et **deux
mécanismes** : cassure S/R (189 jeux, surtout D1/H1) et **cassure de volatilité**
(116 jeux, **M15 à 103**, entrée sur DevFactor × ATR). Sur 305 jeux, **un seul**
a la grille activée, isolé et nommé « G ».

**Son portefeuille live : 44 stratégies, 8 marchés, l'or ne pèse que 32 %**, et
la répartition entre les deux mécanismes est exactement 22/22.

**Prix** : UBS 1 699 $ (10 activations, **+ 5 de ses autres EA gratuits**), ou
location **999 $/an**. Robots individuels 649 à 949 $. Trois robots or séparés
coûtent 1 947 $ pour des presets redondants.

**Le Bitcoin est à rayer** : ses trois signaux BTC sont mauvais, dont un à 71 %
de creux pour 9 %/an.

Voir [[ea-commerciaux-or]], [[backtest-refute-ne-confirme-pas]], [[levier-et-plafond]].
