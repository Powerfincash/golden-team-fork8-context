# Inventaire : ce qui ne vit encore que sur le PC

Dressé le 22/09/2026, à partir de ce que les 73 mémoires, `CLAUDE.md` et `ETAT.md` citent
nommément. Un fichier cité par une consigne mais absent du dépôt est un fichier que la session
suivante ne pourra pas ouvrir — c'est exactement ce qui a coûté deux journées.

La commande de [`COMMANDE.md`](COMMANDE.md) rapatrie tout ce qui est marqué **ENTRE** ci-dessous.

---

## A. Les outils de mesure et de lancement — **ENTRE**

`OneDrive\Documents\forex\outils\`. Sans eux, aucun chiffre du chantier n'est reproductible, et
`CLAUDE.md` en interdit tout autre. Une soixantaine de scripts, tous en texte, quelques centaines
de Ko en tout.

- **Les quatre passages obligés** : `mesure.py` (le seul producteur de chiffre MT5),
  `parjeu.py` (mesure jeu par jeu, contrôlée sur n18 : 3 550 trades, +6 024 $),
  `dejavu.py` (avant toute recherche produit), `avant_publication.py` (avant d'annoncer un chiffre).
- **Les lanceurs, chemin unique** : `lancer_mt4.sh`, `lance_chaine.ps1`, `lancer.sh`,
  `prelance.py` (le refus qui empêche un lancement), `duka_symbole.py` (ticks Dukascopy).
- **La fabrique des Quatre Standards** : `etat_portefeuilles.py`, `standards_variantes.py`,
  `quatre_standards.py`, `maj_standards_html.py`, `turbo_maison.py`, `ter_maison.py`,
  `cinquieme_maison.py`, `plafond.py`.
- **La fidélité Eagle-owl / UBS** : `fidelite_globale.py`, `fidelite_entrees.py`, `compare_eo_ubs.py`.
- **Le reste de l'outillage cité** : `reserve2025.py`, `retour_moyenne.py`, `moulinette.py`,
  `cmp_sets.py`, `set_vers_tester.py`, `regler_tester.py`, `rang_swings_d1.py`, `revue_hebdo.py`,
  `fiche_ea.py`, `deals_export.py`, `lire_rapport.py`, `analyse_rapport.py`, `chien_de_garde.py`,
  `chien_de_garde.sh`, les `diag_*.py`, les `repose_*.py`, les `fc_*.py`, `recompose_or.py`,
  `vie_ordres.py`, `verifier_passe.py`, `source_verifiee.py`, `luna_*.py`.

Deux seulement sont déjà dans le dépôt : `outils/correlation_dailyhl_portefeuille.py` et
`outils/correlation_golddaily1_goldtradeh.py`. Tous les autres manquent.

## B. Les notes de méthode — **ENTRE**

Mêmes dossier, même format. Ce sont des décisions écrites, pas des archives de chiffres.

`CALIBRATION-CRIBLE.md` (tout critère nouveau s'y teste : s'il élimine UBS, Gold Reaper,
Gold Phantom, Wolf ou Advanced Scalper, il est faux), `TESTS-A-REALISER.md` (la file ouverte
depuis le 12/09), `QUATRE-STANDARDS.md` et `QUATRE-STANDARDS-10-09.txt` (la source dont la page
ne doit rien retirer), `MEILLEUR-A-CE-JOUR.md`, `PORTEFEUILLE-ZEBRA-AXISELECT.md`,
`PORTEFEUILLE-06-09-2026.md`, `LIVRE-06-09-2026.md`, `PARAMETRES-PROPFIRM.md`,
`UBS-ANONYMISATION.md`, `KESTREL.md`, `JOURNAL-POWERFIN.md`, `DECOUPLAGE-PIVOTS-REFUTE.md`,
`PROTOCOLE-MOTEUR-MULTI-JEUX.md`, `PROTOCOLE-RETOUR-MOYENNE-CROISEES.md`, `SPEC-CLONE-WOLF.md`,
`CLONE-ADVANCED-SCALPER.md`, `EA-MAISON-VERDICT.md`, `CRIBLE-SIGNAUX-MQL5.md`,
`CRIBLE-EA-NON-MESURES-10-09.md`, `ZEBRA-INDICES.md`, `BITCOIN-ETAT-08-09.md`,
`PREDICTION-LEVIER.md`, `AUDIT-EFFICACITE.md`, `BACKTEST-CE-QUIL-VAUT.md`,
`POURQUOI-CETTE-NUIT-A-RATE.md`, `PROFALGO-CE-QUE-J-AI-TROUVE.md`,
`RESULTAT-UBS-OR-03-09.md`, `RESULTAT-PLAFOND-03-09.md`.

## C. Les gabarits de pages — **DÉJÀ FAIT AUJOURD'HUI**

La page « Quatre Standards — Portefeuille » est désormais dans
[`gabarits/quatre-standards-21-09-2026.html`](gabarits/), avec ses règles dans
[`gabarits/LISEZMOI.md`](gabarits/LISEZMOI.md). Sur le PC, les sources
`outils/quatre_standards_18-09.html`, `quatre_standards.html`, `_bis`, `_ter` rentrent aussi
par la section A.

## D. Les réglages `.set` — **ENTRE**

`ubs_or_14jeux.set`, `as_a5_usdjpy.set`, `AdvScalp_USDJPY.set`, `EURUSD.set` et les jeux
SetsB / SetsB2. Quelques Ko chacun, en texte. **Sans eux, aucun rapport n'est rejouable** : un
rapport dit ce qui s'est passé, le `.set` dit avec quoi.

## E. Les configurations du testeur `.ini` — **ENTRE, sauf celles qui portent un identifiant**

`ruine22.ini`, `ruine22_m1.ini`, `crise2008.ini`, `s_r6_sonde.ini` et les configurations de
chaîne. Un `.ini` du testeur contient parfois le numéro de compte démo : le 22/08/2026 l'un
d'eux s'est retrouvé versionné puis expédié sur OneDrive, et l'historique a dû être réécrit.
La commande écarte donc tout fichier contenant `Lo`+`gin=`, un mot de passe ou une clé, et
n'en note que le chemin.

## F. Le code source des robots maison — **ENTRE (sources seulement)**

`EagleOwl_v1.mq5` et `_v2`, `Zebra_v1.mq5` et `_v5`, `Heron`, `MoteurCassure_v3*.mq5`,
`GoldingClone.mq5` / `GoldingClone4.mq4`, `LazyAlgo`, `MultiStrategyEA` (la copie de
`E62C655E…` est la bonne, pas celle de `B987CBEB…`), `ExportBarres.mq5`, `ImporterBarres.mq5`,
`SondeIndicateur.mq5`, `SessionsDiag.mq5`, `GardienHoraire.mq4`, `OrStraddle.mq4`, `ZigZag.mq4`.

Ils vivent dans les quatre dépôts git des terminaux MetaTrader, plus des `.bundle` dans
`Documents\Sauvegardes-Code`. Tout cela est **sur le PC uniquement** : un `.bundle` local ne
protège pas de la perte de la machine.

## G. Les scripts de sauvegarde — **ENTRE**

`refresh.sh` de `C:\Users\User\Documents\Sauvegardes-Code`, qui écrit sur les quatre emplacements
de sauvegarde et annonce chaque copie.

## H. L'index des rapports de backtest — **ENTRE (l'index, pas les rapports)**

Plus de 462 rapports MT4 et MT5. La commande écrit `index/rapports.tsv` : chemin, taille, date,
pour chacun. C'est ce qu'il faut pour savoir ce qui existe, ce qui a déjà été mesuré et ce qu'on
peut rejouer. Elle écrit aussi `index/inventaire_forex.tsv`, la liste complète du dossier `forex`,
fichier par fichier.

## I. Les journaux de chaîne — **ENTRE jusqu'à 10 Mo**

`chaine_*.log`. Au-delà de 10 Mo, seul le chemin est indexé.

---

# Ce qui reste dehors, et pourquoi

| Ce qui reste sur le PC | Pourquoi |
|---|---|
| **Ticks Dukascopy / Tick Data Suite** (`AppData\Local\Tick Data Suite\Dukascopy\<symbole>`) | Des dizaines de Go de binaire, retéléchargeables en quelques clics dans Tick Data Manager. Un dépôt git ne s'en remet pas, et ils ne portent aucune décision. |
| **Rapports HTML bruts** (462+, en UTF-16) | Lourds, illisibles tels quels, et le chiffre qui compte en est déjà sorti par `mesure.py` et `parjeu.py`, dont les CSV sont déjà dans `mesures/`. On garde l'index, qui suffit à retrouver n'importe lequel. |
| **Journaux de terminal géants** — `20260821.log` fait **11,5 Go** | Le flux distillé est déjà versionné dans `Experts\LazyAlgo\Tools\goldinghedge_stop` (2,5 Mo) : la mesure du stop de panier est rejouable sans le journal. |
| **Binaires `.ex4` / `.ex5` des robots achetés** | Ce sont des licences, pas du contexte. Une session infonuagique ne peut rien en faire, et la règle en vigueur interdit d'exécuter un binaire d'origine inconnue. |
| **Caches `.fxt`, `.hst`, historiques du testeur** | Régénérés par le testeur à chaque passage. |
| **Tout fichier portant un identifiant** (`.ini` de compte démo, `compte thinkforex VPS.docx`…) | OneDrive est lisible par Microsoft et GitHub garde l'historique pour toujours. Incident réel du 22/08/2026. Écartés, chemin noté, contenu jamais copié. |

---

# Ce qu'il restera à faire après, et que la commande ne peut pas faire

- **Le terminal MT4 Vantage complet** (avec ses ticks) devra être copié sur le VPS à la main :
  c'est plusieurs dizaines de Go, ce n'est pas un travail de dépôt git.
- **Le runner sur le VPS** piloté par le dépôt : c'est le chantier prévu, pas un rapatriement.
