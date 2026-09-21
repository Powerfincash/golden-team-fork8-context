---
name: feedback-template-standards
description: "Ne jamais retirer une donnée du template des quatre standards (capital minimum, mensuel moyen…) — il l'a reproché deux fois le 12-13/09"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: c8bdaad5-dac5-4fdf-8d5a-2dc87bb80f85
  modified: 2026-09-18T05:26:05.931Z
---

**Règle : le template des quatre standards garde TOUTES les données de `QUATRE-STANDARDS-*.txt` et de la sortie
de `etat_portefeuilles.py` — capital minimum, instances, mensuel médian ET moyen, mois négatifs, pire mois, délais.
Rien ne se retire sans le lui dire.**

**Why :** deux reproches en deux jours (« cela y était pourtant, pourquoi l'as-tu enlevé ? » le 12/09 pour le capital
minimum ; « qui te dit de supprimer des infos ? faut à chaque fois recommencer » le 13/09 pour le mensuel moyen).
Reconstruire une page en ne reportant qu'une partie des chiffres lui coûte du temps et de la confiance.

**How to apply :** avant de republier l'artefact « Quatre Standards », diff des rubriques contre le `.txt` et contre
la sortie `etat_portefeuilles.py tout` ; toute rubrique présente à la source est présente dans la page. Si une
rubrique doit disparaître (donnée obsolète), le dire dans le message, pas en silence.

**Consigne du 17/09 (sa demande) : garder toutes les variantes d'une jambe dans la page (SetsB / SetsB2, AdvSc backtest MT4 /
AdvSc au protocole n113, Axi maison SetsB2 / SetsB « pour info ») et mettre EN FOND ROSÉ la variante à privilégier pour chaque
portefeuille type** (compte propre : SetsB ; tout prop firm, classique ou Axi : SetsB2). Les autres variantes restent lisibles.

**Où est le template (18/09) :** source HTML `outils/quatre_standards_18-09.html` (versions précédentes : `quatre_standards.html`
13/09, `_bis`, `_ter` 15/09) ; artefact publié https://claude.ai/code/artifact/3e284374-0491-4826-8d64-5cb8ea8cfa10 (version 14 le 18/09,
alias https://claude.ai/artifact/8gBCb4uY5GdWvemSy48p9V) — pour le republier depuis une autre session, passer cette URL en `url` (lire
d'abord, puis publier), sinon un doublon est créé. Chiffres des variantes : `outils/standards_variantes.py` (jambe or SetsB2 imposée
×1 pour les blocs « règle » : sans contrainte l'optimiseur écartait l'or et le hors tirage était plus bas — 12,95 contre 14,72).
