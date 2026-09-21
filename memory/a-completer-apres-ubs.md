---
name: a-completer-apres-ubs
description: Sa consigne du 06/09 — ce qui reste à trancher APRÈS l'achat d'UBS : le rôle exact du Bitcoin et celui des indices dans le portefeuille
metadata:
  type: project
---

**Sa consigne du 06/09/2026 :** *« reste à compléter par la suite après l'achat de UBS, le rôle exact
du bitcoin et des indices ! »* Achat d'UBS décidé le 06/09 sur la base de [[ubs-hors-or-mesure]],
prévu le soir même.

## 1. Le Bitcoin — rôle à trancher

**Ce qui est mesuré** : les 7 jeux Bitcoin d'UBS apportent **+95 % à creux égal** sur la jambe or,
corrélation −0,09, et portent **87 % de l'apport de 2024** des 17 jeux hors indices. Mais ils gagnent
**0,238 $ par transaction sur 5 696 transactions**, et le point mort est à **26 $ de glissement
aller-retour** au-delà de l'écart du testeur (0,01 lot BTCUSD : 1 $ de mouvement = 0,01 $).

**Ce qui reste à faire** : (a) lire le test `n57_btc_delai` (même Bitcoin, délai d'exécution aléatoire,
lancé le 06/09 à 10h46) ; (b) après l'achat, mesurer le **glissement réel de PU Prime sur BTCUSD en
démo** avant de leur donner du capital. Rappel : les propres signaux Bitcoin de Profalgo sont mauvais,
dont un à 71 % de creux pour 9 %/an. **Déploiement : démarrer sans le Bitcoin.**

## 2. Les indices — rôle à trancher

**Ce qui est mesuré** : les 13 jeux DJ30/NAS100/SP500 sont les **seuls corrélés positivement à l'or**
(+0,33, +0,17, 0,00) et **annulent l'apport des autres** : les 30 jeux ensemble ne donnent que +7 %,
les 17 sans indices en donnent +74 %.

**Pourquoi ce n'est PAS une condamnation** : PU Prime n'a d'historique DJ30/NAS100/SP500 que depuis
**2023**, soit 14 mois sur 48. Leur contribution négative est en partie un artefact de fenêtre courte,
et 94 % de leur résultat vient de la seule année 2024, sans réserve possible.

**Ce qui reste à faire** : trouver un historique d'indices plus long (Dukascopy : S&P et Dow depuis
2011-2012) ou attendre l'accumulation chez PU Prime, puis remesurer sur une fenêtre où une réserve
existe. **Déploiement : démarrer sans les indices.**

Voir [[ubs-hors-or-mesure]], [[portefeuille-trois-jambes]], [[portefeuille-sport-collectif]].

## 3. Terminer le clone Wolf EURUSD en MQL5 — sa consigne du 06/09

**Pourquoi c'est devenu prioritaire** : la mesure du 06/09 ([[portefeuille-trois-jambes]]) place
**Wolf EURUSD et Advanced Scalper USDJPY** comme les deux meilleures jambes hors or, ensemble +96 % à
creux égal. Or Wolf **n'existe légitimement qu'en MT4** (sa copie MT5 est craquée, à ne jamais lancer)
et n'est plus vendu nulle part. Sans clone, la jambe EURUSD reste prisonnière d'une seconde plateforme,
avec marge séparée.

**La spécification est déjà écrite** dans [[wolf-scalper-projet]], décidée le 30/08, jamais construite :

- **Porte LES DEUX ZigZag**, le natif MT5 et un portage fidèle de celui de MT4, le choix étant un
  paramètre. L'algorithme du ZigZag standard est public : le porter n'est pas du décompilage.
- **Un seul paramètre neuf** : `InpSeuilTrailing`. Suivre à `InpTrailing` seulement quand le gain
  courant dépasse ce seuil, sinon laisser le stop initial à 200 points. `InpSeuilTrailing = 0`
  reproduit exactement le vendeur, donc le clone reste validable contre l'original.
  Balayage : 0 (témoin) / 20 / 40 / 80 / 150 points.
- **Sa correction du 30/08, à ne pas oublier** : *« si le ZigZag de MQL5 est mieux pour cet EA, il vaut
  mieux le garder »*. La reproduction transaction par transaction est un **outil de diagnostic**, pas un
  objectif — on garde le meilleur, pas le plus conforme.
- **Critère de jugement** : ni le PF ni le net, mais le **gain net par transaction rapporté au seuil de
  rupture de 1,051 pip aller-retour**. Une variante qui gagne moins au total mais plus par transaction
  est meilleure, elle achète de la marge contre la friction.
- **Précaution qui décide** : gagner sur la fenêtre complète ne suffit pas, il faut **gagner sur les
  deux moitiés**. La réponse du trailing s'est révélée non monotone (1,17 pip à 40, 0,89 à 60, 1,33 à
  200) : optimiser dessus serait choisir du bruit.
- **Piège de courtier à coder explicitement** : `SYMBOL_TRADE_STOPS_LEVEL = 30` chez PU Prime écrase
  toute valeur inférieure, et c'est ce bridage qui fait la performance du vendeur. Chez un courtier sans
  distance minimale (Ultima Markets : 0), il faut écrire 30 ou 40 EXPLICITEMENT, sinon le 20 s'applique
  vraiment et coûte un tiers du résultat.

## 4. Les 5 EA gratuits — choix arrêté le 06/09

**Gold Phantom, Gold Reaper, Luna AI Pro MT5, Daytrade Pro, Indicement.**

| pris | pourquoi |
|---|---|
| **Gold Phantom** | seul moteur or NON reproductible par les jeux UBS (verrouillé, 77 paramètres) ; meilleur rapport mesuré |
| **Gold Reaper** | son choix ; activations propres et le jeu du signal live |
| **Luna AI Pro MT5** | seul produit NON-cassure du catalogue (retour à la moyenne) ; la version MT5 permet de le mesurer en ticks réels au lieu du modèle MT4 qui flatte les scalpeurs de nuit |
| **Daytrade Pro** | ses 3 jeux sont les meilleurs du hors-or mesuré (PF 3,08 EURUSD, 4,26 GBPUSD) |
| **Indicement** | **option sur une case vide**, pas une jambe attendue. Son signal réel est faible : +17,5 %/an pour 27,9 % de creux de solde, PF 1,06, rapport 0,63. Mais indices = classe d'actifs vacante, et c'est mieux qu'un 5e robot or |

**Écartés** : Goldtrade Pro et Goldbot One (l'or une 5e et 6e fois, terrain corrélé à 0,7) ; Apex Trader
et Stability Pro (grilles, mesurées et refusées) ; Gecko (mesuré le 06/09 sur les 3 paires : rapport
annuel 0,06 GBPUSD, ~0 EURUSD, 0,3 USDJPY — éliminé).

**Rappel** : les dossiers `The_Gold_Reaper`, `Daytrade Pro`, `Advanced Scalper`, `Bitcoin Reaper`,
`Indicement`, `ORB Master` existent DÉJÀ dans la bibliothèque de jeux UBS. Prendre ces robots en
gratuit donne des activations séparées et les réglages d'usine, pas une stratégie de plus.


## 08/09/2026 : tache (a) FAITE — le delai ne tue pas le Bitcoin

`n57_btc_delai`, lance le 06/09 et **jamais lu jusqu'a aujourd'hui** : avec delai d'execution aleatoire,
rapport **2,33** contre 2,53 sans delai, soit **-14 % de net**. Degradation normale, pas l'effondrement
redoute. La crainte « 4 jeux sur 7 detruits par la latence » ne se traduit pas au niveau de l'ensemble.

**C'est la brique la plus decorrelee du livre** : -0,01 a +0,03 avec Eagle-owl, les trois Zebra et les
deux Heron. Contribution a Axi Select : rapport **12,49 -> 13,51**, funded +2,68 -> **+2,83 %/mois**,
mois negatifs 5 -> **4**, et les DEUX moities s'ameliorent (13,69 / 13,95).

**Ce qui le maintient dehors, inchange** : point mort a **26 $ de glissement aller-retour** pour un gain
moyen de **0,238 $ par transaction** sur 11 336 transactions. Le delai coute 14 %, le glissement peut
couter 100 %. **Reste la tache (b) : mesurer le glissement reel sur BTCUSD en demo PU Prime** — une
observation de quelques jours, pas un backtest. C'est le seul travail qui separe le portefeuille d'un
gain de 8 % de rapport. Voir `outils/BITCOIN-ETAT-08-09.md`.

**Le clone Wolf EURUSD en MQL5 est FAIT** (son information du 08/09) — cette ligne de la liste tombe.
