# L'agent de calcul

**Dernier passage : 22/09/2026 a 15h21 — REFUS — ShutdownTerminal n'est pas a 1 : le terminal resterait ouvert et la file se bloquerait.**

**Demandes en attente dans `jobs/` : 0.**

Ce fichier est le temoin de vie de l'agent. Il se reecrit tout seul a chaque passage.
L'agent regarde dans `jobs/` toutes les dix minutes.

> **Si la date ci-dessus a plus de deux heures alors que le PC est allume,
> l'agent ne tourne plus.** Recoller la ligne 3 de [`COMMANDE.md`](COMMANDE.md).

| Passage | Demande | Resultat |
|---|---|---|
| 22/09/2026 15h21 | test_001 | REFUS — ShutdownTerminal n'est pas a 1 : le terminal resterait ouvert et la file se bloquerait |

Journaux detailles des passages : `~/.runner-journaux/` sur le PC.
