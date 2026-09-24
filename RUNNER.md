# L'agent de calcul

**Dernier passage : 24/09/2026 a 08h40 — passe terminee en 6 min.**

**Demandes en attente dans `jobs/` : 1.**

Ce fichier est le temoin de vie de l'agent. Il se reecrit tout seul a chaque passage.
L'agent regarde dans `jobs/` toutes les dix minutes.

> **Si la date ci-dessus a plus de deux heures alors que le PC est allume,
> l'agent ne tourne plus.** Recoller la ligne 3 de [`COMMANDE.md`](COMMANDE.md).

| Passage | Demande | Resultat |
|---|---|---|
| 24/09/2026 08h40 | emp_2026_xag | passe terminee en 6 min |
| 24/09/2026 08h33 | emp_2026_xag | REFUS — aucun rapport |
| 22/09/2026 15h21 | test_001 | REFUS — ShutdownTerminal n'est pas a 1 : le terminal resterait ouvert et la file se bloquerait |

Journaux detailles des passages : `~/.runner-journaux/` sur le PC.
