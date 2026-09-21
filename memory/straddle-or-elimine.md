---
name: straddle-or-elimine
description: Le straddle de plage sur l'or elimine dans les deux sens - et le gain portable des ordres limite (14 points par entree)
metadata:
  type: project
---

Reconstruction ecrite le 01/09/2026 : `OrStraddle.mq4` (MT4, PU Prime), straddle Buy/Sell
de part et d'autre du prix, **toute la geometrie en multiples d'ATR** (voir
[[or-friction-regime]] : un parametre en points fixes ne se transpose pas d'une epoque a
l'autre sur l'or). Le sens est un parametre : CASSURE = ordres stop, REPLI = ordres limite.

## Le balayage — XAUUSD.s, H1, 2013-2015, ~700 trades, RR tenu fixe a 2

| SL (ATR) | CASSURE | REPLI |
|---|---|---|
| 0,50 | PF 0,63 · −0,177 R | PF 0,68 · −0,148 R |
| 0,75 | PF 0,74 · −0,117 R | PF 0,79 · −0,093 R |
| 1,00 | PF 0,76 · −0,108 R | **PF 0,87 · −0,058 R** |
| 1,50 | PF 0,84 · −0,069 R | PF 0,87 · −0,058 R |

**ELIMINE dans les deux sens.** Le meilleur cas fait −0,058 R contre un critere fixe a
+0,10 R ([[backtest-acceptance-criteria]]) — pas marginal, a l'oppose.

**Why:** le PF monte regulierement avec la taille du stop, exactement comme le predit la
dilution d'une friction fixe. Mais l'avantage BRUT reste nul : la perte par trade egale la
friction a chaque reglage. Une plage d'ouverture ne porte aucune information. Meme mur que
[[reperes-m15-puprime]] : la geometrie est neutre, tout repose sur l'entree.

Prudence sur une lecture intermediaire : sur 126 trades (6 mois de 2015) j'avais lu un
avantage brut de +0,041 R et je l'ai presente comme positif. Avec un ecart-type de ~1 R par
trade, l'erreur type valait 0,09 R — c'etait du bruit. **Ne pas annoncer le signe d'un
avantage sans le comparer a son erreur type.**

## LE RESULTAT PORTABLE : les ordres limite valent 14 points par entree

Glissement mesure a l'entree, meme code, meme fenetre, ~700 entrees chacun :

| | glissement moyen |
|---|---|
| ordres **STOP** (cassure) | **+6,23 points, defavorable** |
| ordres **LIMITE** (repli) | **−7,68 points, FAVORABLE** |

Ecart systematique de **~14 points par entree sur XAUUSD.s** (0,14 $). Sur un stop de
1 ATR H1 (493 points) cela vaut 0,028 R — et cela explique la TOTALITE de l'avantage du
repli sur la cassure ; la part directionnelle oscille entre positive et negative, donc
c'est du bruit.

**How to apply:** chaque fois qu'une entree peut s'ecrire en ordre LIMITE plutot qu'en
ordre STOP, on recupere ~14 points gratuitement sur l'or. Vaut pour n'importe quelle
strategie, y compris [[wolf-scalper-projet]] et [[ea-commerciaux-or]]. Corollaire : un EA
de cassure paie structurellement plus cher qu'un EA de repli, parce qu'il entre par
definition dans un mouvement rapide.

## Specifications relevees au passage (PU Prime MT4, serveur PUPrime-Demo)

| | XAUUSD | XAUUSD.s |
|---|---|---|
| Digits / Point | 3 / 0,001 | 2 / 0,01 |
| lot mini / pas | 0,01 / **0,10** | 0,01 / 0,01 |
| ecart releve (01-02 h serveur) | 130 pts = 0,13 $ | 32 pts = **0,32 $** |
| stops_level | 20 | 20 |

**Ce sont deux contrats differents.** `XAUUSD.s` est celui utilise sur les graphiques.
Un pas de lot de 0,10 sur `XAUUSD` interdit le 0,01 lot — mon arrondi au plus proche
tombait a zero et rendait `erreur 131` a chaque tick (arrondir AU-DESSUS).

## CORRECTION du meme jour — « portable » etait FAUX

J'ai ecrit plus haut que le gain des ordres limite « s'applique a Wolf, a Gold Phantom, a
tout ce qu'on testera ». **C'est faux, et verifie sur les donnees existantes.**

Wolf Scalper est lui-meme un straddle a ordres stop (rapport EURUSD 5 ans : 806 `buy stop`,
804 `sell stop`, 734 annulations, 817 declenchements). Son glissement d'entree, mesure en
appariant prix de pose et prix d'execution du meme ticket : **+0,330 pip de moyenne**
(0,337 et 0,320 sur les deux moities hors echantillon), **mediane 0,000**, pire cas
+42,2 pip. **8 entrees sur 817 (1 %) portent 51 % du glissement total.**

J'ai propose de brider cette queue : gain estime +18 % sur l'avantage net. **Teste, et
refute :**

| glissement | n | P&L moyen |
|---|---|---|
| > 5 pip | 8 | **+8,57** |
| 2 a 5 pip | 6 | **+6,93** |
| 0 a 2 pip | 378 | +2,27 |
| nul ou favorable | 425 | +2,29 |
| tous | 817 | +2,38 |

**Les entrees qui glissent le plus sont les plus rentables — 3,5 fois la moyenne.** On
glisse quand la cassure est violente, et une cassure violente est ce que la strategie
cherche. Brider la queue aurait supprime les meilleurs trades.

**LA REGLE : sur une strategie de CASSURE, le glissement est correle a la qualite du
signal — ce n'est pas un cout parasite, c'est le prix d'entree des meilleurs trades.**
L'economie de glissement n'est un gain net que sur une strategie **sans avantage** (le
straddle or, ou il n'y avait rien a proteger). Ne jamais transposer un gain de friction
d'une strategie a une autre sans verifier a quoi le cout est correle.

Et la lecon de methode : j'ai propose un correctif chiffre (+18 %) **avant** de tester s'il
ne detruisait pas la source du gain. La verification a coute zero seconde de machine — tout
etait dans un rapport deja sur le disque. Voir [[garde-fous-mesure]] et [[methode-de-travail]].

*Piege d'extraction rencontre au passage :* dans un rapport MT4, la **derniere** colonne
d'une ligne de cloture est le SOLDE, l'avant-derniere est le PROFIT. Prendre la derniere
donne ~10 900 pour chaque trade et un classement absurde. Auto-controle obligatoire :
la somme des profits doit egaler le « Profit total net » du rapport (ici 1 941,79 vs 1 941,81).

## SECONDE CORRECTION, meme jour — la « regle » ci-dessus est FAUSSE elle aussi

La regle que je venais d'ecrire (« sur une cassure, le glissement est correle a la qualite
du signal ») est **refutee**. Test correct sur les 817 entrees de Wolf EURUSD :

**rho de Spearman = −0,005, p = 0,88.** Aucune relation entre glissement et resultat.
Glissement > 0 : +2,47 $ de moyenne sur 392 trades. Glissement nul : +2,29 $ sur 425.

**D'ou venait le mirage :** (1) un premier rho de +0,295 produit par une fonction de rangs
qui donnait des rangs DISTINCTS ET ARBITRAIRES a des valeurs identiques — **425 des 817
glissements valent exactement 0**, donc l'ordre des ex aequo fabriquait toute la
correlation ; (2) une moyenne de +8,57 $ calculee sur **14 trades**, dont le test t valait
**1,81** — je l'avais affiche et j'ai conclu quand meme.

**Etat vrai du dossier glissement sur Wolf :** moyenne +0,330 pip, mediane 0,000, 1 % des
entrees portent 51 % du total, et **on ne peut rien dire de ce 1 %** — ni qu'il est plus
rentable, ni qu'il faut le brider. n trop petit dans les deux sens.

## LA FAUTE DE FOND, commise DEUX FOIS le 01/09/2026

1. Matin : « avantage brut +0,041 R » annonce comme positif sur **126 trades**, quand
   l'erreur type valait **0,09 R**.
2. Apres-midi : une regle entiere batie sur **14 trades**, t = 1,81.

**GARDE-FOU : tout chiffre tire d'un sous-groupe doit etre affiche avec son n ET son
erreur type ou son t, dans la meme phrase.** Sans ces deux nombres, la comparaison n'est
pas rapportee, elle est suggeree. Et pour toute correlation : **traiter les ex aequo par
rangs moyens** et confirmer par un test de permutation — un jeu de donnees ou la moitie
des valeurs sont identiques fabrique des correlations a partir de rien.

Voir [[garde-fous-mesure]], [[methode-de-travail]], [[backtest-acceptance-criteria]].
