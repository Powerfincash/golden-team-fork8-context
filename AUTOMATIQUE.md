# Rapatriement automatique

**Dernière exécution : aucune pour l'instant.**

Ce fichier est le témoin de vie du rapatriement. Il se réécrit tout seul à chaque passage.

La tâche Windows « Rapatriement Golden Team » relance le rapatriement chaque nuit à 3 h.
Si le PC est éteint à cette heure-là, le passage se fait au démarrage suivant.
Elle ne commite que s'il y a du neuf, ou une fois par jour pour dire qu'elle est passée.

> **Si la date ci-dessus a plus de deux jours, la tâche ne tourne plus.**
> Recoller la ligne 2 de [`COMMANDE.md`](COMMANDE.md) dans Git Bash pour la remettre en place.

| Passage | Résultat |
|---|---|
| — | la tâche n'a pas encore été créée sur le PC |

Journaux détaillés des passages : `~/.rapatriement-journaux/` sur le PC (30 derniers jours).
