# Machine de calcul et surveillance du réel : le plan

> Écrit le 22/09/2026, après sa question : *« c'est le VPS où tournent mes robots et mon compte
> réel ? Pas de problème ? »*
> Rien n'est installé, rien n'est codé. Ce fichier est le plan, pas le geste.

---

## La réponse d'abord : si, c'est un problème, et il est sérieux

**Un backtest ne doit jamais tourner sur la machine qui porte le compte réel.** Ce n'est pas une
précaution de principe, c'est la raison pour laquelle personne, en salle de marché, ne fait
tourner la recherche sur la machine d'exécution.

Ce qu'un backtest fait à une machine, concrètement :

- il occupe **un cœur à 100 % pendant des heures**, et lit le disque sans arrêt ;
- pendant ce temps, le terminal réel traite ses ticks **en retard** ;
- vos robots calculent au tick : un retard de quelques centaines de millisecondes au moment
  d'une cassure sur l'or déplace le prix d'entrée, ou fait manquer l'entrée ;
- un VPS ForexVPS est vendu pour sa **latence vers le serveur du broker**. Charger son disque
  et son processeur dégrade précisément ce pour quoi vous le payez.

Et l'asymétrie tranche toute seule :

- ce que vous gagneriez : quelques heures de confort sur une mesure ;
- ce que vous risqueriez : **une entrée ratée sur de l'argent réel**.

Un gain de confort ne se paie pas avec du risque d'exécution. **Règle posée : aucune mesure,
aucun backtest, aucun outil lourd sur le VPS. Jamais.**

Bonne nouvelle : votre PC a plus de mémoire que le VPS, et vos ticks y sont déjà. **C'est lui
la machine de calcul** — et c'est aussi la voie la plus rapide, parce qu'il n'y a rien à copier.

---

# Chantier 1 — le PC devient la machine de calcul

C'est la priorité. Il marche **ce soir**, sans rien transférer, sans rien acheter.

## Étape 1.0 — le préalable, 5 minutes, à faire de toute façon

**Le dépôt ne contient pas encore vos outils.** Vérifié aujourd'hui : il n'y a ni dossier `pc/`
ni dossier `index/`. Donc `mesure.py`, `parjeu.py`, `lancer_mt4.sh`, `lance_chaine.ps1` et
`prelance.py` ne sont nulle part ailleurs que sur votre disque.

Sans eux, l'agent n'aurait rien à lancer.

- Coller la **ligne 1 de `COMMANDE.md`** dans Git Bash.
- Puis la **ligne 2**, qui crée la tâche de nuit.
- Attendre `SAUVE ET VERIFIE.` et son lien.

## Étape 1.1 — l'agent de calcul, 10 minutes, une ligne à coller

Même moule que `COMMANDE.md`, que vous connaissez déjà. Ce que je pousserai quand vous direz oui :

- **`jobs/`** — un dossier. Un fichier `.ini` déposé dedans est une demande de mesure.
- **`runner.sh`** — le programme.
- **`RUNNER.md`** — le témoin de vie, comme `AUTOMATIQUE.md` : sa première ligne dit quand il
  est passé et ce qu'il a fait. Plus de deux heures sans passage = il ne tourne plus.
- **une ligne de plus dans `COMMANDE.md`** — celle qui crée la tâche Windows.

## Ce que l'agent fait tout seul, toutes les 10 minutes, sans vous

1. il met le dépôt à jour et regarde dans `jobs/` ;
2. s'il y a une demande, il recopie le `.ini` au bon endroit dans le terminal ;
3. **il refuse de lancer si le `.ini` est incomplet** — même refus que `prelance.py` ;
4. il lance le testeur MT4 ou MT5 et **attend le rapport**, sans limite de temps ;
5. si aucun rapport n'est sorti, il écrit `REFUS : aucun rapport` et **ne conclut rien** —
   c'est exactement la faute du 21/09 à 02h31, elle ne se reproduira plus en silence ;
6. il exporte la série de trades en CSV avec vos outils ;
7. il commite, pousse, **vérifie que GitHub a bien reçu**, et déplace la demande dans `jobs/faits/` ;
8. il enchaîne sur la suivante.

Vous déposez une demande depuis n'importe où, même du téléphone. Vous lisez le résultat le
lendemain. Une file de huit passes se vide toute seule sur deux ou trois nuits.

## Les deux limites, dites franchement

- **Le PC doit être allumé.** Éteint, rien n'avance. La tâche rattrape au démarrage suivant,
  comme celle du rapatriement, donc rien n'est perdu — c'est seulement décalé.
- **Une passe en cours ralentit votre PC**, comme aujourd'hui quand vous en lancez une.
  Si c'est gênant, on fait démarrer la file à 22 h plutôt qu'en continu : un réglage, pas un chantier.

---

# Chantier 2 — le VPS, en lecture et en dépôt, sans jamais le charger

Votre demande : charger des EA et des `.set`, vérifier chaque matin que tout va bien, voir les
positions et les erreurs de la nuit. Tout cela se fait **sans aucune charge machine** et
**sans que nous détenions le moindre identifiant**.

## Comment j'accède au VPS sans avoir vos identifiants

Je n'y accède pas. **C'est le VPS qui parle au dépôt, et moi je lis le dépôt.**

- Une tâche légère sur le VPS se réveille toutes les 15 minutes. Elle dure **quelques secondes**
  et copie quelques kilo-octets. Aucune charge, rien à voir avec un backtest.
- **Dans le sens VPS → dépôt**, elle pousse : les journaux du terminal de la nuit, les positions
  ouvertes, le solde et l'équité, les erreurs et les déconnexions, la liste des robots attachés
  et leurs réglages en cours.
- **Dans le sens dépôt → VPS**, elle ramasse : tout fichier que j'aurai déposé dans
  `vps/a-poser/` — un `.ex4`, un `.ex5`, un `.set` — et le place dans le bon dossier du terminal.
  Elle écrit ensuite dans `vps/pose.md` ce qu'elle a posé et à quelle heure.
- **Aucun port n'est ouvert sur le VPS. Aucune connexion n'entre.** Le VPS ne fait que sortir
  vers GitHub, exactement comme votre PC le fait déjà pour le rapatriement.
- Le VPS a besoin d'un droit d'écriture sur le dépôt : un **jeton à portée fine**, créé par vous
  sur github.com, limité au seul dépôt `golden-team-fork8-context`, droit « Contents : lecture
  et écriture ». **Ce n'est pas votre mot de passe GitHub et il ne passe jamais par nous.**
  Si un jour cela vous inquiète, vous le supprimez sur github.com : le VPS n'a plus rien,
  dans la seconde, sans même y toucher.

**Je recommande contre le MCP exposé en HTTPS** qui était au programme du 22/09. Il ouvrirait un
port entrant sur la machine qui porte votre compte réel, pour un service de plus à maintenir.
Le dépôt fait le même travail avec zéro surface d'attaque. Si un jour le délai de 15 minutes
devient gênant, on rouvrira la question — pas avant.

## Le point quotidien

- Chaque matin, je lis ce que le VPS a poussé et je vous écris **un point court** :
  les robots qui tournent, les positions ouvertes, ce qui a été exécuté cette nuit,
  et **surtout ce qui cloche** — un robot détaché, une déconnexion, une erreur répétée,
  une marge qui se resserre.
- S'il n'y a rien à signaler, le point le dit en une ligne. Pas de bavardage quotidien.
- Cela peut se caler en routine automatique, à l'heure que vous voulez.

## Ce que je ne ferai pas sur le VPS, et pourquoi

- **Je ne touche à aucune position ouverte.** Ni fermeture, ni modification de stop.
  Je signale, vous décidez. C'est la seule règle tenable quand c'est de l'argent réel.
- **Je ne modifie aucun réglage d'un robot en cours.** Déposer un `.set` neuf, oui ;
  changer en vol les paramètres d'un robot qui a des positions ouvertes, non.
- **Je n'attache pas un robot à un graphique.** La tâche dépose le fichier au bon endroit,
  mais l'attacher demande un clic dans MetaTrader. **Ce clic reste le vôtre, et c'est très bien
  ainsi** : c'est le moment où vous voyez ce qui va se mettre à trader.
- **Je ne relance pas le terminal.** Un redémarrage automatique sur un compte réel, c'est la
  porte ouverte aux mauvaises surprises un dimanche soir.

## Une précaution sur les journaux

Les journaux du terminal réel portent **votre numéro de compte** et le nom du serveur. Le dépôt
est privé, mais ce n'est pas une raison. La tâche masquera le numéro de compte avant de pousser,
et le garde-fou identifiants de `rapatrier.sh` s'appliquera tel quel — un fichier qui contient un
identifiant n'est pas copié, seul son chemin est noté.

---

## L'ordre et le temps

| | Vous êtes devant | Effet |
|---|---|---|
| **1.0** lignes de `COMMANDE.md` sur le PC | 5 min | vos outils entrent au dépôt |
| **1.1** agent de calcul sur le PC | 10 min | les passes tournent la nuit, sans vous |
| **2.1** jeton GitHub à portée fine | 5 min | le VPS peut écrire, et rien d'autre |
| **2.2** tâche de surveillance sur le VPS | 10 min | le VPS se raconte au dépôt, 15 min par 15 min |
| **2.3** premier point du matin | — | je vous écris ce que j'y lis |

**Une demi-heure de votre temps en tout.** Le chantier 1 peut démarrer sans attendre le 2.

---

## Ce qui n'arrivera jamais

- Aucun backtest, aucune mesure, aucun outil lourd sur le VPS du compte réel.
- Aucun accès entrant, aucun port ouvert, aucun identifiant chez nous.
- Aucune action sur une position ouverte, ni sur les paramètres d'un robot en cours.
- Aucun fichier effacé ou déplacé : les tâches lisent et copient, elles ne suppriment rien.
