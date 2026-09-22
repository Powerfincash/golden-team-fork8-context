---
name: kestrel-profil-rendement
description: "Kestrel (crécerelle), créé le 19/09/2026 — QUATRIÈME ROBOT MAISON, issu de la reproduction d'UBS (sa nomenclature, 22/09). Profil de rendement : fidélité à UBS débranchée. Partage le binaire d'Eagle-owl, activé par trois paramètres. Sert un jeu isolé, pas le portefeuille ; lit encore les jeux d'UBS donc pas encore autonome"
metadata: 
  node_type: memory
  type: project
  originSessionId: d0e7cce4-cea8-47de-9dd2-1ae784bc5f8a
  modified: 2026-09-19T12:24:53.503Z
---

**Son intention, dans ses mots (22/09/2026)** : « Kestrel reprend les trades rentables non fidèles
à UBS lors de sa reconstruction par Eagle-owl, et retirés d'Eagle-owl pour atteindre la fidélité à
UBS. » Les deux robots sont donc **complémentaires par construction, pas concurrents** : Eagle-owl
garde ce qui est fidèle, Kestrel récupère le rentable qu'il a fallu jeter pour l'être.

**Écart entre l'intention et ce que fait le code aujourd'hui — à lever avant toute décision.**
Kestrel n'est pas le RÉSIDU d'Eagle-owl, c'est son SUR-ENSEMBLE : débrancher une règle de fidélité
ne fait pas jouer les trades retirés *à la place* des autres, elle les rajoute *par-dessus*. Ordre
de grandeur mesuré le 19/09 : avec la règle en deçà débranchée, le livre or était à **116,9 %** des
positions d'UBS, contre 100,1 % une fois la règle posée. Conséquence pratique : **jouer Kestrel à
côté d'Eagle-owl double les trades communs** au lieu d'ajouter une jambe. Réaliser son intention
demande un mode « résidu » qui ne joue QUE les entrées que les règles de fidélité rejettent.

**Kestrel est un ROBOT MAISON, issu de la reproduction d'UBS.** C'est sa nomenclature, corrigée le 22/09/2026, et
elle fait foi : les robots maison sont **quatre** — Eagle-owl, **Kestrel**, Zebra, Heron.
Précision du 22/09 : **Eagle-owl et Kestrel proviennent tous deux de la reproduction d'UBS ; Zebra et
Heron sont indépendants.** Voir [[robots-maison]]. Ne plus le présenter comme
« un simple profil » ni comme « pas un autre robot » : c'est une erreur que j'ai commise le 22/09 et qu'il a reprise.

Créé le 19/09/2026 sur sa demande « tu crées le bot et tu le nommes ». Nom choisi puis validé par lui : **Kestrel**, la
crécerelle, dans la lignée d'Eagle-owl le grand-duc (il a d'abord demandé la traduction, puis accepté l'anglais
puisqu'Eagle-owl l'est déjà).

**Précision technique, qui ne change pas ce qu'il est** : Kestrel partage le binaire `EagleOwl_v1.ex5` et s'active en
PARAMÈTRES D'ENTRÉE, pas en copie du fichier source. La conséquence, sa remarque devenue règle de maintenance : « ce
qui est vrai pour Eagle-owl l'est aussi pour Kestrel » — un seul code à corriger, un seul chantier, toute la feuille
de route vaut pour les deux. Si un besoin n'était vrai que pour l'un, ce serait le signe qu'il manque un paramètre,
pas qu'il faut un second fichier.

**Kestrel n'est pas « hors or »** (sa question du 22/09, vérifiée dans les mesures) : l'or est au
contraire sa meilleure justification — or SetsB2 3,74 en échantillon contre **9,76 en réserve
2025** (+3 460 $), et neuf jambes au total rejouées en Kestrel pour cette réserve, or et argent
compris. Ce qui est hors or, c'est sa route vers l'autonomie : GBPJPY, EURJPY, AUDUSD, Brent,
des symboles où UBS n'existe pas (voir le dernier paragraphe).

**Deux mesures à ne jamais confondre** :
- **fidélité à UBS** — recouvrement d'un robot avec UBS (`fidelite_entrees.py` : communes, manquées,
  inventées). C'est elle qui vaut 96,5 % pour Eagle-owl.
- **recouvrement Kestrel / Eagle-owl** — recouvrement des deux robots ENTRE EUX, jamais mesuré à ce
  jour. C'est lui qui dit si les deux jambes peuvent cohabiter. Le même outil le donne en prenant
  Eagle-owl comme référence à la place d'UBS : ses « inventées » sont alors exactement le résidu.

**Les trois réglages** (v1.35, MQL5 fd0871d) : `Fid_ReposeMaxTrades` 20 → 999, `Fid_SwingMortEnDeca` true → false,
`Fid_SwingMortAuDela` true → false.

**Portée réelle — tranché le 22/09/2026 ; la phrase « ils n'agissent que sur les symboles à 2 décimales » était
FAUSSE et est retirée.** Les trois agissent sur les devises, et l'un d'eux n'agit QUE sur elles. Le contrôle JPY D1
(2,57 en Kestrel contre 2,12 en fidèle) avait donc raison contre la fiche. Conditions telles que les notes d'adoption
les citent, version par version :

- `Fid_SwingMortAuDela` — règle adoptée en v1.27 sous la restriction `dig == 3 || dig == 5`, et **v1.32 précise que
  les ordres AU-DELÀ ne sont pas touchés par la levée de la restriction décimale**. Elle ne vaut donc que pour les
  symboles à 3 et 5 décimales : les devises, l'argent et l'USO. **Sur l'or (2 décimales) ce réglage ne change rien.**
  C'est l'exact contraire de ce que disait la fiche.
- `Fid_SwingMortEnDeca` — v1.32 (19/09 11 h, MQL5 b5b7915) lève la restriction décimale pour les ordres EN DEÇÀ aux
  quatre endroits du code. Elle vaut donc partout, or compris. Témoins argent, USO, CHFJPY, EUR inchangés ce jour-là
  parce qu'à 3 décimales la règle y était déjà active, pas parce qu'elle les épargne.
- `Fid_ReposeMaxTrades` — seuil de la fenêtre de repose, indépendant du symbole. v1.43 ajoute `if(dig == 2) return
  false;` dans `ReposeFermee` (fenêtre coupée sur l'or et l'argent pour tout le monde), puis v1.45
  `if(Fid_ReposeMaxTrades < 999) return false;` : à 20 le profil fidèle coupe la fenêtre partout, à 999 **Kestrel la
  garde toujours active**. C'est la différence qui se voit sur JPY D1, storyG, USO et AdvSc.

**Base de la conclusion** : les notes d'adoption de [[moteur-multi-jeux]], qui citent les conditions du code
(`dig == 2`, `dig == 3 || dig == 5`, `Fid_ReposeMaxTrades < 999`) et les témoins mesurés à chaque version. Le source
`EagleOwl_v1.mq5` n'est PAS encore dans le dépôt — `rapatrier.sh` existe mais n'a pas été lancé, il n'y a pas de
dossier `pc/`. À confirmer sur le source dès qu'il sera rapatrié.

**Contrôles (19/09)** : JPY D1 reproduit à l'identique la cible v1.31 (1 057 positions, +1 047 $, creux 102,
rapport 2,57 contre 2,12 en fidèle) ; or SetsB2 à 3,77 contre une cible v1.32 de 3,74 et 3,10 en fidèle — un peu mieux
que la cible parce que le correctif v1.34 reste actif.

**À quoi il sert** : un robot AUTONOME sur un jeu isolé. Candidats : or SetsB2 (3,77 contre 3,10), USO v1.02 (2,05
contre 0,57, mais 35,7 % d'entrées non-UBS). CHFJPY n'a rien à débrancher : il est déjà à 2,80 en v1.34 fidèle.

**À quoi il NE sert PAS : le portefeuille.** Mesuré le 19/09 — remplacer les jambes fidèles par les jambes rendement
fait reculer la rubrique Axi de 19,20 à 18,29 et n'apporte rien sans or. Le gain d'un portefeuille vient de l'ajout de
jambes décorrélées, pas du comportement divergent. Voir [[portefeuille-sport-collectif]].

**Limite à redire à chaque fois** : Kestrel lit LES JEUX D'UBS — ses niveaux, décalages, unités, stops. Seuls **13,4 %**
de ses entrées sont absentes de l'historique d'UBS. Ce n'est pas de l'autonomie. Celle-ci passe par des jeux composés
par nous sur des symboles sans UBS (GBPJPY, EURJPY, AUDUSD, Brent) : point 25 de la feuille de route, ouvert depuis que
le problème des re-poses est résolu.

Fiche complète : `outils/KESTREL.md`. Voir [[moteur-multi-jeux]], [[ecarts-rentables-a-garder]].
