---
name: zebra-indices
description: Zebra sur DAX/SP500/DJ30/NAS100 — trois fermes, NAS100 candidat mais non admis faute d'historique ; le classement suit exactement l'ecart/ATR
metadata:
  type: project
---

Mesure du 07/09/2026, ticks reels + delai aleatoire, lot 0,10 (minimum indices), 2023-11-21 → 2025-12-30.
Document `forex/outils/ZEBRA-INDICES.md`.

**L'historique de ticks des indices chez PU Prime commence le 20/11/2023.** Deux ans un mois : la regle
maison (quatre ans, deux moities, une reserve) ne peut pas s'appliquer. On observe, on ne valide pas.

**Seize passages, quatre profondeurs (6/12/24/48) x quatre indices.** Rapport rendement/creux :
GER40 −0,40 a −0,23 ; SP500 −0,47 a −0,30 ; DJ30 +0,31 a +0,54 ; NAS100 +0,12 a +1,48.

**Le classement des quatre indices reproduit exactement leur classement par ecart/ATR H1** : NAS100
2,2 %, GER40 4,0 %, DJ30 5,5 %, SP500 6,3 % — contre **0,65 % sur l'or**. Zebra vit d'un suivi tres
serre ; ce n'est pas le marche qui casse le mecanisme, c'est la friction. Voir [[or-friction-regime]]
et [[wolf-scalper-projet]].

**NAS100 seul** : voisinage de neuf reglages (stop 1600/3200/4800 x suivi 370/550/900) **positif 9 fois
sur 9**, meilleur au stop le plus serre (1600/370, rapport 3,04). Les deux moities donnent 4,63 et 2,19.
C'est un avantage reel, pas un accident de reglage.

**Non admis au livre malgre cela**, trois raisons : pas de reserve possible ; recouvrement de treize mois
seulement avec la fenetre du portefeuille (2021-2024), donc contribution non mesurable ; lot minimal 0,10
au lieu de 0,01, brique dix fois plus grossiere qui ne se dose pas sur un petit compte.

**A refaire fin 2027**, quand l'historique atteindra quatre ans. Rien a changer aux [[quatre-standards]].


## 08/09/2026 : NAS100 FERME — et le chemin TDS vers MT5 est ouvert

**Sa question** : « TDS ne donne pas l'historique des indices ? » Si. Et mieux : les donnees etaient
**deja importees dans MT5** comme symboles personnalises, depuis le 02/09.

**Chemin, a reutiliser** : TDS alimente MT4 (terminal Vantage F1BBCAAC, mappage Dukascopy deja configure
pour les 4 indices + le petrole) -> export M1 en CSV -> `ImporterBarres.mq5` cree le symbole personnalise
MT5 en copiant les specs d'un symbole modele. Resultat : **NAS100_15, DJ30_15, SP500_15** (3,5-3,7
millions de barres M1 chacun, **2011 -> 2026**) et XAUUSD_22.

**RESERVE PERMANENTE de ce chemin** : l'importateur pose des BARRES M1 (`CustomRatesUpdate`), pas des
ticks. Le testeur genere donc ses ticks, ce qui **flatte un suivi serre** comme celui de Zebra. Ce chemin
sert a REFUTER, jamais a valider.

**Resultat (n70)** : Zebra sur NAS100_15, 14,3 ans, stop 1600 / suivi 370 : net **+92,4 $**, creux 28,5 $,
**rapport 0,23** — contre 3,04 sur les 2,1 ans qui avaient servi a le regler, et 4,29 pour Zebra sur l'or.
2012-2020 : **+6,4 $ en neuf ans**, six annees negatives. 2021-2024 : +88,2 $. **Tout le resultat est dans
la fenetre de mesure** : les « 9 reglages positifs sur 9 » etaient un signal de PERIODE, pas de mecanisme.

**La famille indices est close pour Zebra** (GER40, SP500, DJ30 fermes sur la friction ; NAS100 sur
l'historique long).

**Ce que ca ouvre** : TDS a aussi **AUDCAD, AUDNZD et NZDCAD** telecharges — le trio du retour a la
moyenne de [[retour-moyenne-croisees]]. La note du 06/09 « NZDCAD absent » etait vraie pour PU Prime MT5,
fausse pour TDS. Quinze ans permettraient de trancher ce que le test de concentration a fait echouer
trois fois.
