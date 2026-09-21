---
name: audit-efficacite-recurrent
description: Sa demande du 06/09 : l'économie de tokens doit être récurrente, avec des actions d'amélioration proposées régulièrement ; tâche planifiée « audit-efficacite-hebdo » le lundi 08h
metadata:
  type: feedback
---

**Sa demande du 06/09/2026 :** « faudrait le faire de façon récurrente en m'informant des actions d'amélioration pouvant être faites ».

**Why:** un nettoyage unique (index mémoire 8,5 → 4,4 Ko) ne tient pas ; le contexte regrossit à chaque session. Il veut des propositions régulières, pas des corrections à la demande.

**How to apply:** tâche planifiée `audit-efficacite-hebdo` (lundi 08h, dossier `~/.claude/scheduled-tasks/`) qui mesure MEMORY.md, CLAUDE.md, serveurs MCP, gros fichiers et disque, et écrit un rapport daté en tête de `forex/outils/AUDIT-EFFICACITE.md`. Elle ne modifie rien : les actions se proposent, il décide. Quand un rapport tombe, le lui résumer en trois lignes avec les actions à valider. Voir [[prevenir-changement-session]] et [[garde-fous-mesure]].
