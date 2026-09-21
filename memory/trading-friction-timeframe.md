---
name: trading-friction-timeframe
description: La friction mesurée sur EURUSD M1 et pourquoi elle condamne le scalping à stop serré
metadata:
  type: reference
---

Coût aller-retour mesuré sur EURUSD.p chez PU Prime : **0,36 pip** (spread + commission),
constaté sur l'écart entre R théorique et R réalisé — les stops sortaient à −1,076 R au
lieu de −1,000.

Part du risque mangée par les frais, et win rate minimal à RR 2 :

| SL | frais / risque | win rate requis |
|---|---|---|
| 3 pips | 12 % | 44 % |
| 7 pips | 5 % | 38 % |
| 30 pips (M15/H1) | 1,2 % | 34 % |

**Why:** sur une soixantaine de configurations testées le 21/08/2026, la **seule** variable
qui prédisait la performance était la taille du stop rapportée aux frais — jamais la logique
du signal. C'est la signature d'entrées sans information.

**How to apply:** avant d'optimiser quoi que ce soit sur du M1, rappeler que passer en
M15/H1 vaut ~4 points de win rate gratuits. L'utilisateur privilégie le M1 pour le nombre
de signaux : lui redire une fois que la fréquence multiplie l'espérance existante mais n'en
crée pas, puis coder le timeframe en paramètre et laisser la mesure trancher.
Voir [[backtest-acceptance-criteria]].

## Friction rapportée à l'ATR — mesuré le 23/08/2026 sur EURUSD

Le chiffre qui tranche la question du timeframe, mesuré sur son propre graphique
TradingView avec 3,6 ticks d'aller-retour (0,36 pip) :

| | friction en ATR | part du mouvement moyen à 50 bougies |
|---|---|---|
| **M1** | **0,501** | **78 %** (mouvement moyen 0,641 ATR) |
| **M15** | **0,099** | environ un sixième |

**Why:** l'ATR d'une minute sur EURUSD vaut moins d'un pip, donc la friction en vaut
la moitié. Sur M1 on part avec quatre cinquièmes du terrain perdus, avant toute
question de qualité de signal. C'est structurel, indépendant de l'indicateur testé.

**How to apply:** ne jamais évaluer un signal en M1 sans afficher d'abord cette ligne.
Il avait choisi M1 « pour avoir des signaux » — raisonnement juste en apparence, mais
TradingView charge un nombre de bougies fixe quel que soit le timeframe : M1 ne donne
pas plus de mesures, il les tasse dans deux semaines au lieu de plusieurs mois.
