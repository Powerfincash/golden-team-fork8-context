---
name: retour-moyenne-croisees
description: Piste ouverte le 06/09 à sa demande — retour à la moyenne sur AUDNZD/AUDCAD/NZDCAD, la famille absente du portefeuille ; protocole en trois étapes avec friction éliminatoire
metadata:
  type: project
---

**Ouverte le 06/09/2026.** Protocole complet : `forex/outils/PROTOCOLE-RETOUR-MOYENNE-CROISEES.md`.
À exécuter quand le testeur MT5 sera libre, après la chaîne n51-n56.

**Sa remarque qui l'a ouverte** : les paires favorables avaient déjà été listées dans le crible MQL5.
Vérifié — **4 des 11 signaux « fiables » criblés le 05/09 tradent exactement AUDNZD / AUDCAD / NZDCAD**
en retour à la moyenne (Deux ex machina, RAZOR EA, Tharos II, MagicGW audcad). Des opérateurs
indépendants tenant plusieurs années ont convergé sur ce trio : ce n'est pas une intuition isolée.

**Pourquoi la piste mérite d'exister malgré [[ea-maison-retour-moyenne]]** : le portefeuille est
**entièrement composé de cassures** (UBS, Reaper, Phantom, moteur maison), d'où leurs corrélations de
0,7 et leur pire mois commun, août 2024. Le retour à la moyenne est la famille structurellement absente.

**Trois faits qui tempèrent, à ne pas oublier** : les 4 signaux ont tous été REFUSÉS (creux de fonds
20-47 %, deux grilles déclarées, 29 pertes consécutives) ; la carte des 625 rapports donne cette famille
négative ; et EURGBP, croisé corrélé de la même logique déjà testé, est le marché où la concentration
était la pire (une transaction = 5,7 % de quinze ans).

**Données** : ticks réels PU Prime disponibles pour AUDNZD (93 Mo) et AUDCAD (116 Mo) ; **NZDCAD absent**
chez PU Prime, à chercher ailleurs (Dukascopy). Barres MT4 H1 à exporter par `ExportBarres.mq5`.

**Ordre imposé, arrêt à chaque échec** : (1) friction sur ticks réels, éliminatoire si > 15 % de
l'amplitude capturée ; (2) règle identique à `retour_moyenne.py`, aucun réglage par paire ; (3) les deux
contrôles qui ont tué la version précédente appliqués d'emblée — concentration (retirer le meilleur 1 %,
espérance résiduelle ≥ +0,05 R, t ≥ 3) et rapport en risque ≥ 0,5, réserve 2024. Puis seulement l'apport
à creux égal ([[pas-de-formule-de-portefeuille]]).


## 08/09/2026 : TRANCHÉ — AUDCAD et NZDCAD passent, AUDNZD et AUDCHF non

**Sa question « TDS ne donne pas l'historique ? » a debloque la mesure.** MT5 avait deja NZDCAD depuis
2017 et AUDCAD depuis 1996 ; il manquait juste l'export H1 (script `ExportBarresH1`, lance depuis un
graphique en direct -- **pas depuis le testeur**, ou `CopyRates` ne rend que la fenetre chargee, piege
verifie ce jour).

| paire | ans | trades | rapport | esperance | **sans le top 1 %** | concentration |
|---|---|---|---|---|---|---|
| **AUDCAD** | 16,7 | 4 409 | **0,53** | 5,54 | **4,51** | **20 %** OK |
| **NZDCAD** | 9,7 | 2 580 | 0,21 | 2,42 | **1,25** | 49 % OK |
| AUDNZD | 16,6 | 4 078 | 0,07 | 1,46 | 0,39 | 74 % limite |
| AUDCHF | 16,7 | 4 464 | 0,01 | 0,75 | **-1,33** | 277 % ECHEC |

**AUDCHF est le contre-exemple qui compte** : meme code, meme periode, meme famille -- esperance
NEGATIVE des qu'on retire 1 % des trades. Ce n'est pas le mecanisme qui decide, **c'est le marche**.

**Reserve 2025-2026 TENUE** (premiere piste de la journee qui resiste) : AUDCAD 1,65 en echantillon /
**1,54 en reserve** ; NZDCAD 0,52 / **0,54**. Nuance : le niveau depend du regime (0,22 en 2017-2020),
c'est le SIGNE qui est stable, positif sur quatre decoupages.

**Contribution a Axi Select** (correlations **+0,01 a +0,07**, les plus basses jamais mesurees ici) :
rapport 11,21 -> **12,49**, funded +2,25 -> **+2,68 %/mois**, mois negatifs 7 -> **5**, a creux identique.
Dosage modeste (x2 chacun) : ces briques amortissent, elles ne portent pas le rendement.

**Reste a faire** : ecrire l'EA MQL5 (les courbes viennent d'un moteur Python). Chantier justifie par la
mesure, et **c'est du code maison donc utilisable en algo chez Axi Select**. Voir [[propfirm-choix-maison]].
