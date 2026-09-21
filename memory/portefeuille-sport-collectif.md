---
name: portefeuille-sport-collectif
description: Sa philosophie posée le 06/09 — le portefeuille est un sport d'équipe, un candidat se juge sur ce qu'il apporte au collectif à creux égal, pas sur sa valeur individuelle ; prudent sans être dogmatique
metadata:
  type: feedback
---

**Sa formulation du 06/09/2026 :** *« Je partage la philosophie du concepteur d'UBS. Il faut être
prudent mais pas dogmatique à tout va, et surtout pragmatique, en voyant le portefeuille mais ses
individualités ! Nous traitons le problème comme un sport d'équipe avec ses interactions, pas comme un
sport individuel. »*

**Why:** mes cribles jugeaient chaque robot comme un joueur solo — rendement, facteur de profit, creux
propre — et éliminaient donc les bons équipiers. Deux mesures le prouvent, pas une opinion :

- **Advanced Scalper**, éliminé le 02/09 pour ne rendre que 14 %/an, s'est révélé décorrélé de Gold
  Phantom (−0,08 à +0,08 sur 198 mois) : la meilleure jambe trouvée de la semaine.
- Le 06/09, le crible d'étape 1 aurait éliminé **UBS deux fois** (son manuel dit « any market, any
  timeframe », ses 14 jeux portent `EnableGrid`) — le produit qui donne 83 %/an.

**How to apply.**

1. **Le critère d'entrée est la contribution, pas la qualité propre.** Un candidat se mesure à **creux
   égal** contre le portefeuille actuel ([[pas-de-formule-de-portefeuille]]) : on garde s'il fait monter
   le rendement pour le même creux. Revert Edge, de rapport propre 0,87, ajoutait +22 %.
2. **Le vrai disqualifiant est la redondance, pas la faiblesse.** Corrélation au-delà de +0,5 avec une
   jambe en place : on s'arrête, c'est un doublon. Nos jambes or corrèlent à 0,7 entre elles ; trois
   produits or font un produit et demi.
3. **Mais l'équipe ne porte pas un joueur nul.** La corrélation ne départage pas deux décorrélés :
   Advanced Scalper (corr −0,014, rapport 0,17) **diluait** de 0,5 point là où Revert Edge (corr −0,087,
   rapport 0,87) ajoutait 22 %. La corrélation est un filtre d'entrée bon marché, la qualité propre
   décide ensuite. **Ni le dogme du rendement, ni le dogme de la décorrélation.**
4. **Le poste vacant guide la recherche.** Le portefeuille est aujourd'hui **100 % cassure** : un
   retour à la moyenne médiocre peut valoir mieux qu'une excellente cassure de plus.
5. **Prudent sans être dogmatique** : avant d'écarter, une seule question — *que me manque-t-il pour le
   mesurer ?* Voir [[calibration-crible]] dans `outils/CALIBRATION-CRIBLE.md`.

## 15/09/2026 — Comment se pourvoit le poste, mesuré sur deux jours
Apports hors tirage au compte propre : **argent (jeux Till, moteur UBS) +3,8** ; Range USDJPY +0,95 ; pétrole H4 +0,36 ; Scalp C +0,2 ;
or Till en plus 0 ; moteurs nouveaux (MRA H-L pièce de monnaie, Position Trader et Game Changer grilles, Onyx redondant) 0.
**Un symbole nouveau avec le moteur connu bat un moteur nouveau sur un symbole connu.** Chercher d'abord des marchés (jeux écrits
pour le symbole : `Client sets`, platine, cuivre, gaz…), pas des mécanismes. La transposition littérale d'un jeu à un autre
symbole a échoué (test 8) ; les jeux faits pour le symbole ont réussi (argent). Le retour à la moyenne sur devises a un avantage
réel de 1-2 pips (Scalp IC, Longterm AUD/NZD/CAD, Heron) qui ne survit qu'au coût ECN : question de courtier, pas de stratégie — **mesuré le 15/09 : réfuté pour Heron** (H1, cibles ATR : 1,5 → 0,3 pip ne vaut que +0,2 à +0,8 hors tirage) ; la friction n'est éliminatoire que pour le retour à la moyenne scalpé. Voir `outils/TESTS-A-REALISER.md` tests 11-18.
