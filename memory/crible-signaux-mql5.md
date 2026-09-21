---
name: crible-signaux-mql5
description: Crible des signaux MQL5 hors or (05/09/2026) - criteres fixes, 0 sur 11 retenus ; ou est le fichier, comment le refaire sans risque pour le compte
metadata:
  type: project
---

Fait le 05/09/2026 au soir a sa question « pas de robot valable sur EURUSD/GBPUSD/USDJPY ou indices ? ».
Fichier : `forex/outils/CRIBLE-SIGNAUX-MQL5.md`. Methode : liste « Reliability » des signaux MT5
(`/en/signals/mt5/list/page1?preset=11`, lisible cote serveur par WebFetch, donc sans toucher a son adresse ni a
son compte), filtre du tableau (>= 52 semaines, >= 300 tr, pas « gold » dans le nom), puis page de chaque signal.
Criteres : reel, >= 52 sem, >= 300 tr, creux solde ET fonds <= 20 %, ni grille ni moyennage, tenue >= 15 min, or < 30 %.
**Resultat : 0 sur 11.** Les « fiables » de longue duree sont des retours a la moyenne AUDCAD/NZDCAD/AUDNZD avec
creux de fonds 20-47 % et deux grilles declarees. Les moins loin : Precise Pair (23,8 %, 1 an, moitie or), NoPain
(6,9 % solde / 20,6 % fonds). Sa question sur le VPN : refuse (contournement + compte vu depuis l'etranger + IP
partagees deja filtrees) ; la protection est la cadence humaine et l'arret au premier refus. Pages suivantes = tache
de l'agent, taux attendu bas. Voir [[moulinette-proprietes]], [[pas-de-formule-de-portefeuille]].


## 08/09/2026 : crible des tiers de retour a la moyenne CLOS — douze produits, zero retenu

**AOT tombe a son tour** (c'etait le survivant du 06/09) : MQL5 signale lui-meme sur sa fiche de signal
**80 % de la croissance en 6 jours sur 427**. Retirer ces six jours laisse un rapport de 0,23. Son second
signal ICMarkets a ete supprime puis relance a neuf -- les 39 semaines qui servaient de preuve n'existent
plus. **Sa correction du 08/09** : les risques different entre les deux comptes (5 % Darwinex, 10 %
ICMarkets), donc leur creux identique de 28 % ne prouvait AUCUNE robustesse au courtier ; les rapports
reels sont 1,15 et 0,58, un facteur deux. Le document du 06/09 disait le contraire, il est corrige.

**Boring Pips** (103505, nouveau) passe les trois eliminatoires sur le papier mais ses signaux reels
donnent un **creux de fonds de 38,57 % pour 7,25 % de creux de solde** (5,3x) : les pertes sont PORTEES,
profil NoPain. Rejete sur piece mesuree, pas sur la description.

**Luna AI PRO** (possede, MT4, jamais backteste -- le `v_LunaAIPRO.htm` est un export de parametres) :
`MaxOpenTrades=99`, `SetSLTP_AfterEntry=0`, **aucun `StopLoss=`**, `maxdrawdown_enable=0`,
`consecloss_enable=0`. Sa question « c'est sans SL, non ? » etait juste.

**Conclusion** : le retour a la moyenne se vend toujours emballe dans une grille ou une concentration
extreme. **La solution etait maison** -- voir [[retour-moyenne-croisees]].
