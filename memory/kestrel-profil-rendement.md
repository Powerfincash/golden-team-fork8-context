---
name: kestrel-profil-rendement
description: "Kestrel (crécerelle), créé le 19/09/2026 — QUATRIÈME ROBOT MAISON, issu de la reproduction d'UBS (sa nomenclature, 22/09). Profil de rendement : fidélité à UBS débranchée. Partage le binaire d'Eagle-owl, activé par trois paramètres. Sert un jeu isolé, pas le portefeuille ; lit encore les jeux d'UBS donc pas encore autonome"
metadata: 
  node_type: memory
  type: project
  originSessionId: d0e7cce4-cea8-47de-9dd2-1ae784bc5f8a
  modified: 2026-09-19T12:24:53.503Z
---

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

**Les trois réglages** (v1.35, MQL5 fd0871d) : `Fid_ReposeMaxTrades` 20 → 999, `Fid_SwingMortEnDeca` true → false,
`Fid_SwingMortAuDela` true → false. Ils n'agissent que sur les symboles à 2 décimales et sur le seuil de la fenêtre de
repose ; sur les devises les règles restent actives, parce qu'elles y ont été mesurées et qu'elles y gagnent.
**Incohérence à lever** : ce paragraphe dit « seulement les symboles à deux décimales », or le contrôle ci-dessous
donne un JPY D1 différent en Kestrel (2,57) et en fidèle (2,12). L'un des deux est imprécis — à vérifier dans le code
avant de s'appuyer sur la portée exacte des trois réglages.

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
