---
name: jambe-or-par-compte
description: "Sa logique du 13/09 — comptes prop firm sur la jambe or SetsB2 (Reaper 1+3+4+7+8, empreinte différente), compte propre sur le jeu par défaut SetsB (4+5+6+7)"
metadata: 
  node_type: memory
  type: project
  originSessionId: c8bdaad5-dac5-4fdf-8d5a-2dc87bb80f85
  modified: 2026-09-17T18:46:17.883Z
---

**Sa décision du 13/09/2026 :** la jambe or UBS dépend du type de compte.
- **Comptes prop firm** (classique, et Axi avec UBS) : **`SetsB2`** = Reaper 1+3+4+7+8 + les 10 autres jeux or.
  Performance égale au bruit près (classique hors tirage 12,71 contre 12,87, funded +4,16 %/mois contre +3,74, pire
  mois −1,42 % contre −2,45 ; Axi avec UBS 13,67 contre 13,29), mais **empreinte de transactions différente** de l'EA
  Gold Reaper (des milliers de comptes) et du portefeuille live du vendeur (4+5+6+7).
- **Compte propre** : le **jeu par défaut `SetsB`** (4+5+6+7), aucune raison de changer.

**Rappel ferme du 17/09 (sa formulation) : « tout ce qui est prop firm, classique ou non, est SetsB2, pour brouiller les pistes par
rapport à la version par défaut commerciale ».** Précisé à 19:05 : **prop firm classique ET Axi Select = Eagle-owl sur SetsB2**
(UBS est reconnaissable par les maisons, consigne du 12/09) ; UBS et SetsB ne servent qu'au compte propre.
**Sa décision du 17/09 soir (19:40)** : les lignes turbo « UBS SetsB2 » (2ter 19,98 ; 3 20,68 hors tirage) restent dans la page des
standards **pour info ET comme alternative prop firm tant qu'Eagle-owl n'est pas fidèle à UBS** (tout maison : 12,95 / 11,88, l'écart vient
des jambes clients JPY D1, EUR storyG, USO). Fond rosé sur la variante à privilégier ; la cible reste Eagle-owl SetsB2. Faute du 17/09 :
j'ai calculé le TER maison Axi sur SetsB (n121) et ouvert un chantier entier sur le creux de Reaper 5/6, deux jeux absents de SetsB2 —
avant tout TER ou chantier sur une jambe, relire la règle de compte attachée à cette jambe. Le compte propre seul reste sur SetsB.

**Why :** chez une maison classique, le danger identifié le 06/09 est le refus de paiement pour « stratégie partagée »
(comptes copiés, EA connu), pas le creux. Une empreinte distincte vaut plus qu'un dixième de rapport.

**How to apply :** dans le template et les standards, 3 et 2ter sont mesurés avec SetsB2 (n130), SetsB en ligne
alternative ; le compte propre (1) reste SetsB (n18). Pour Axi maison (Eagle-owl), `SetsB2` demande une vérification
du moteur sans la règle « niveau dépassé » (n132 a tourné avec) avant usage. Jeux : `outils/sets/SetsB2/`,
`Common\Files\SetsB2`. Voir [[tests-a-realiser]] (test 10), [[propfirm-choix-maison]], [[ubs-anonymisation]].
