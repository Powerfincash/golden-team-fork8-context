# Demander une mesure

Déposer un fichier `.ini` dans ce dossier, et c'est tout. L'agent de calcul du PC le prend
dans les dix minutes qui suivent.

Cela marche depuis le téléphone : sur github.com, ouvrir ce dossier, **Add file**,
**Upload files**, puis **Commit changes**.

## Ce qui se passe ensuite, tout seul

1. L'agent lit le `.ini` et **refuse de lancer** s'il lui manque quelque chose. Le refus est
   écrit dans `resultats/<nom>/refus.md` et dit exactement ce qui manque.
2. Sinon il lance la passe **par le lanceur qui existe déjà** — `lance_chaine.ps1` pour MT5,
   `lancer_mt4.sh` pour MT4 — jamais le terminal à la main.
3. Il contrôle à cinq minutes que le test a bien démarré, et le note.
4. Il attend le rapport, sans limite de temps utile.
5. **S'il n'y a pas de rapport, il écrit `REFUS : aucun rapport` et ne conclut rien.**
6. Sinon il appelle `mesure.py` et `parjeu.py --csv`, range tout dans `resultats/<nom>/`,
   pousse, et vérifie que GitHub a bien reçu.
7. Il déplace votre demande dans `jobs/faits/` et enchaîne sur la suivante.

Vous pouvez en déposer dix d'un coup : elles se font l'une après l'autre.

## Ce que le `.ini` doit contenir, sinon c'est refusé

`Expert`, `Symbol`, `Period`, `FromDate`, `ToDate`, `Report` — et, pour MT5,
`ShutdownTerminal=1`, sans quoi le terminal resterait ouvert et bloquerait la file.

`r25f_eagleowl_xag.ini`, à la racine du dépôt, est un exemple qui passe.

## Où lire le résultat

Dans **`resultats/<nom du job>/`** :

- `resultat.md` — ce que dit `mesure.py`, et rien d'autre ;
- `parjeu.csv` — la série jeu par jeu ;
- `rapport.htm` — le rapport, s'il fait moins de 2 Mo ;
- `journal-lanceur.log` — le journal du lanceur, qui dit pourquoi quand ça s'est mal passé.

**Aucun chiffre ne sort de l'agent lui-même.** Ils viennent tous de `mesure.py`. S'il affiche
NON VERIFIE, il n'y a pas de chiffre.

## Voir si l'agent tourne encore

**[`RUNNER.md`](../RUNNER.md)** à la racine. Première ligne : date du dernier passage et nombre
de demandes en attente. Plus de deux heures alors que le PC est allumé, il ne tourne plus.
