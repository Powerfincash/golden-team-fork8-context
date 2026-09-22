# La branche `vps`

Cette branche n'existe que pour le VPS qui porte le **compte réel**. Elle est volontairement
séparée de `main` : le VPS ne voit jamais les mesures, les rapports ni les séries de trades,
et n'a donc rien de lourd à télécharger.

> **Rappel de la règle posée le 22/09 : aucun backtest ne tourne sur cette machine.**
> Le calcul est sur le PC. Un backtest y occuperait un cœur des heures durant et ferait
> traiter ses ticks en retard au terminal réel. Voir `PLAN-INFRA.md` sur la branche `main`.

## Ce qu'il y a ici

- **`etat/etat.md`** — l'état du VPS, réécrit toutes les quinze minutes : robots vus,
  erreurs récentes, pertes de connexion, derniers mouvements.
  **Si sa date a plus d'une heure, l'agent ne tourne plus sur le VPS.**
- **`etat/journaux/`** — les journaux des terminaux, **masqués du numéro de compte**,
  quatorze jours glissants.
- **`a-poser/`** — déposer ici un `.ex4`, `.ex5`, `.mq4`, `.mq5` ou `.set`. L'agent le place
  dans le bon dossier du terminal au passage suivant, puis vide ce dossier.
  Un `.set` doit commencer par `mt4-` ou `mt5-`, sinon l'agent ne sait pas où il va
  et ne le pose pas.
- **`poses/`** — le compte rendu daté de chaque pose : ce qui a été posé, où, et ce qui
  ne l'a pas été.

## Ce que l'agent ne fait jamais, et c'est voulu

- Il ne touche **aucune position ouverte**.
- Il ne change **aucun réglage d'un robot en cours**.
- Il **n'attache aucun robot à un graphique** : un fichier posé n'est pas actif. Ce clic
  reste celui de Denis, et c'est le moment où il voit ce qui va se mettre à trader.
- Il n'arrête, ne relance et ne met à jour **aucun terminal**.
- Il **n'écrase jamais le fichier d'un robot qui apparaît dans les journaux** : il pose la
  nouvelle version à côté, sous `<nom>.nouveau.<extension>`, et le dit dans `poses/`.

## Ce qu'il ne voit pas, et qu'il faut savoir

**L'état instantané des positions et le solde.** Les journaux disent ce qui s'est passé,
pas ce qui est ouvert maintenant. Pour l'avoir, il faudrait attacher au terminal un petit
exportateur en lecture seule, qui ne passe aucun ordre — un clic de Denis, pas encore demandé.

## Rien n'entre sur cette machine

Aucun port ouvert, aucune connexion entrante. Le VPS ne fait que **sortir** vers GitHub, avec
un jeton limité à ce seul dépôt, révocable d'un clic sur github.com.
