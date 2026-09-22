# À poser sur le VPS

Déposer ici un fichier et l'agent le placera dans le bon dossier du terminal, au passage
suivant, dans le quart d'heure.

| Ce qu'on dépose | Où il va |
|---|---|
| `*.ex5`, `*.mq5` | `MQL5/Experts` du terminal MT5 |
| `*.ex4`, `*.mq4` | `MQL4/Experts` du terminal MT4 |
| `mt5-*.set` | `MQL5/Presets` |
| `mt4-*.set` | `MQL4/Presets` |

Un `.set` qui ne commence ni par `mt4-` ni par `mt5-` n'est pas posé : l'agent ne devine pas.

**Un fichier posé n'est pas actif.** Il faut l'attacher à un graphique, et ce geste reste
celui de Denis. Si un robot du même nom apparaît dans les journaux, l'agent ne l'écrase pas :
il pose à côté, sous `<nom>.nouveau.<extension>`, et l'écrit dans `poses/`.

Ce dossier se vide tout seul une fois la pose faite.
