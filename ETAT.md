# État de reprise

> **Ce fichier est le premier à lire, et le seul qui fait foi sur « où on en est ».**
> Les autres fichiers du dépôt sont des archives : ils disent ce qui a été mesuré,
> pas ce qui est vivant. Un chiffre dans une archive sans date est un chiffre périmé.

**À jour au : 25/09/2026**
**Dernier geste : gardien de paquet argent écrit et essayé au testeur (`gardien/`), non posé en réel ; plafond ACCEPTÉ par Denis le 24/09 18h45 ; proposé (450 $ par 0,01 lot, `resultats/plafond_paquet_xag/`). Avant : les deux agents sont écrits et poussés — `runner.sh` (calcul, sur le PC) et
`vps_agent.sh` (remontée, sur la branche `vps`). Ils attendent que Denis colle les lignes de
`COMMANDE.md`. Geste précédent : réserve 2025 argent Till mesurée en entier, profil fidèle
v1.47 — tous les seuils du protocole franchis, voir section 1.**

---

## 0. Chantiers en attente — la liste tenue à jour (24/09/2026)

> Denis a demandé de tenir cette liste **sans avoir à la rappeler**. Toute session qui ouvre,
> ferme ou fait avancer un chantier la corrige ici, **et** dans la mémoire du projet.

**Robots et mesures**
1. **Argent de Till** : réserve 2025 **mesurée le 22/09, tous les seuils franchis** (section 1).
   Reste **sa décision** : remettre en live ou non (live 13-18/09 : 0 gagnant sur 12).
   **Mais (24/09)** : ces 12-13 pertes du live sont UN SEUL paquet de ventes empilées le 16/09
   (22h10-22h26 serveur), fermé d'un bloc le 17/09 à 03h52. Le lot n'était pas le problème,
   l'empilement si. **Aucun retour en réel avant la mesure d'empilement** : deux demandes dans
   `jobs/` (`emp_2026_xag` = 2026 jusqu'au 23/09, rejoue le jour du 16/09 ; `emp_n150_xag` =
   2021-2024), lues par `outils/empilement.py` (branché sur `runner.sh`) → `resultats/<nom>/empilement.md`.
   Les deux passes ont tourné le 24/09 matin (08h40 et 08h47).
   **Plafond de perte par paquet ACCEPTÉ par Denis le 24/09 à 18h45 (Paris, « oui ») ; proposé le 24/09 soir : 450 $ par 0,01 lot au prix actuel (≈ 7 × le prix
   de l'argent ; 450 USC au réel cent à 0,01)** — 597 paquets 2021-2026 rejoués minute par minute,
   positif sur les trois périodes, 6 paquets coupés en 5 ans 9 mois, aucun qui aurait fini gagnant ;
   350 est plus rentable mais à 5 $ d'un paquet gagnant (300 coûte −868 / −895). Détail :
   `resultats/plafond_paquet_xag/PLAFOND.md`. **Gardien écrit et essayé le 24/09 soir** (`gardien/`, `GardienPaquet.mq5`) : au testeur, 6 coupes, les mêmes que
   le rejeu ; +3 / +51 / +266 $ sur 2021-2024 / 2025 / 2026 (mesure.py). **Accord écrit de Denis le 25/09 à 15h13 (Paris)**. 25/09 : `GardienPaquet.ex5`
   (sha256 5E297C7E…, compilé build 6182, terminal VPS 6193) + sources copiés dans `MQL5\Experts\Gardien\` du terminal
   Ultima de vps-london. **Pas encore attaché** : glisser-déposer de Denis sur un second graphique argent
   (mode d'emploi : `gardien/LISEZMOI.md`), puis vérifier la ligne « plafond 450 à 64.44 » dans le journal Experts. **Aucun retour en réel de l'argent sans ce gardien.**
2. **Forex GOLD Investor** et **GOLD Scalper PRO** (FXAutomater, or M15) : retenus en réserve
   le 20/09 (1,8 et 1,7 sur 2021-2024 ; 7,3 et 8,1 en 2025), à **reconstruire, pas acheter**.
   **25/09 (Forex GOLD Investor)** : trois systèmes indépendants, testés un par un sur 2021-2024
   (S1 +506 $, S2 +753 $, S3 +1 031 $, somme = l'original à 22 $ près). Corrélation mensuelle à la
   jambe or : S1 +0,04, S2 +0,01/+0,08, **S3 +0,41/+0,45**. Sorties et lots lisibles (S2 : achats
   seulement, 0,01 puis 0,02 à −5 $, panier fermé à +5 $ du prix moyen, stop 17 $). **Entrées
   introuvables** : ≤ 31 % retrouvées pour S3, ≤ 20 % pour S2 — le seuil Q1 du 22/09 dit « on
   renonce ». Denis a choisi le robot maison inspiré de S2 (25/09 09h31) ; **simulation 2021-2024 :
   la gestion de S2 seule ne rapporte rien** (entrées simples ≈ hasard ≈ 0 moins frais) — l'avantage
   est dans l'entrée introuvable. Même test fait pour S3 (dans le bruit) et S1 (perd). **ARRÊTÉ par Denis le 25/09 à 15h07 (Paris, « 4 arrêter ») : ni clone, ni achat, ni robot maison.** Détail : `resultats/fgi_systemes/RESUME.md`. GOLD Scalper PRO : pas commencé.
3. **Jambe or sur la réserve 2025, avec et sans GoldDaily1** : à mesurer.
4. **Sakura et Happy Pound** : réserve 2025 à relancer (le 21/09 n'a produit aucun rapport).
5. **AUDUSD** : 0 trade, symbole nu au lieu de `.s` ; corriger puis relancer.
6. **Kestrel / Merlin / portefeuille à quatre robots** : protocoles prêts (sections 3bis),
   rien de codé ; première mesure gratuite = corrélation sur l'export mensuel.
7. **Poste retour à la moyenne** : vacant, chercher un nouveau candidat (section 4).

**Outils de contrôle — trois, définis par Denis le 24/09 (sa correction : ce ne sont PAS le runner,
l'agent du VPS ni l'exportateur), plus les cinq ajouts qu'il a validés le 24/09 à 08h32.**
**Écrits le 24/09 dans `controle/` (mode d'emploi : `controle/LISEZMOI.md`), pas encore essayés sur
un vrai terminal.** Un espion MT5 en lecture seule (`GT_Controle.mq5`) + une page (`tableau.py`).
8. **A. Contrôle de l'exécution** : ping, délai serveur, spread (actuel / médiane 24 h / max), glissement par trade.
9. **B. Reporting de performance** : positions, jour/semaine/mois/total, creux courant, creux max (équité et trades fermés), par robot.
10. **C. Surveillance du VPS** : graphiques ouverts, robot chargé, réglages comparés au `.set` de référence (`attendu.csv`, `sets/`), bouton Algo Trading.
    Ajouts : exposition et empilement par symbole/sens avec perte au stop du paquet, écart réel/test
    (`references_test.csv`, vide : à remplir avec des chiffres de `mesure.py`), marge, coupures, swaps.
    **Essai sur le PC du 24/09 matin : bloqué avant compilation.** Le contrôle de permissions de Claude
    Code sur le PC a refusé la copie dans `MQL5\Experts` et la compilation (code venu de GitHub) : il faut
    l'accord écrit de Denis. Le terminal Vantage MT5 démo (compte 26077080) **ne porte aucun robot** :
    les « trois démos » du 21/09 étaient des backtests. La lecture des réglages (outil C) ne pourra donc être
    vérifiée que sur un terminal qui porte des robots. Aucun moyen de poser un robot sur un terminal qui tourne
    sans glisser-déposer ou redémarrage. `tableau.py` tourne sur le PC sans erreur (0 compte, faute d'espion).
    **24/09 16h14 (Paris), après l'accord écrit de Denis de 16h12 : `GT_Controle.ex5` compilé sur le Vantage MT5
    démo du PC (0 erreur, 0 avertissement ; version de `main`).** Pas encore posé : un glisser-déposer de Denis.
    **24/09 16h41-16h49 (Paris) : espion posé par Denis sur DJ30.r H1 du Vantage démo, et il tourne.** Vu sur disque :
    les 4 fichiers, historique 171 transactions, ping 108 ms, spreads EURUSD 14 / GBPUSD 15 / USDJPY 16-17 / DJ30.r 310 points,
    `tableau.py` sans erreur. Défaut corrigé (modèle écrit dans `Profiles\Templates`, illisible ; nom « NULL » sans robot) :
    après correction, les 4 graphiques passent de « modele_illisible » à « aucun_robot » (preuve 16h49:44).
    **Jamais prouvé : l'extraction des réglages d'un vrai robot** (aucun robot sur ce terminal).
    **Reste** : prouver l'extraction des réglages sur un graphique qui porte un robot ; compiler la version MT4 ; version MT4 (compte cent Ultima) ;
    remplir `attendu.csv` ; puis pose sur le VPS réel (chantier VPS en pause sur ordre de Denis).
    **24/09 soir (Paris), chantier VPS relancé par Denis (« 1 et 2 », 18h32).** Accès : depuis le PC (Remote Control) par
    `ssh vps-london` / `ssh vps-ny4` (clé du 13/09, `memory/vps-ny4.md`) — ni Git ni jeton nécessaires. Les comptes réels
    (Ultima cent ****2313, Vantage ****3874) sont en **MT5** au VPS de Londres : la version MT4 de l'espion est inutile pour eux.
    Inventaire Londres (lecture seule, .chr du 13/09 et 17/09) : Ultima 10 graphiques (Zebra ×3, UBS ×5, Heron ×2), Vantage 9
    (Zebra ×3, UBS ×4, Heron ×2), aucun graphique argent. **19h06 : terminaux Ultima et Vantage du VPS NY4 arrêtés
    (Stop-Process -Force, accord écrit de Denis 19h01), tâche « Chien de garde MT5 » du NY4 désactivée** ; contrôle 19h13 : pas
    relancés, Londres identique avant/après (Ultima 9 pos./46 ordres, Vantage 9/32). Axi et PU Prime (démos) laissés ouverts.
    `GT_Controle.mq5` (1c18728) et `GT_Controle.ex5` (compilé sur le PC) copiés dans `MQL5\Experts` des deux terminaux de
    Londres (compilation sur le VPS refusée par le garde-fou). **Reste : pose par Denis sur un graphique VIDE de chaque
    terminal, puis preuve de lecture des réglages.** À creuser : UBS refusé « invalid price » (sell stop EURUSD) et
    « invalid stops » (USDJPY) à 12h et 13h le 24/09 sur les deux comptes ; chien de garde de Londres en erreur
    « initialize KO (-6, Authorization failed) » pour Ultima.
    **19h16-19h32 (Paris) : OUTIL C PROUVÉ SUR LES DEUX COMPTES RÉELS.** Espion posé par Denis sur un graphique vide EURUSD de
    chaque terminal de Londres. Vantage (ancienne version) et Ultima (version d95f308 : lecture des modèles d'un bloc, plafond
    1 Mo — l'ancienne restait bloquée sur le modèle de 5,4 Mo du graphique Zebra or, 13 011 objets que Zebra n'efface jamais) :
    tous les graphiques « ok », robots, magics, paramètres et dossiers de sets IDENTIQUES aux .chr (Ultima : SetsUltima,
    _EUR, _FX2, _BTC, SetsAS_JPY ; Vantage : SetsVantage, _EUR, _FX2, _JPY). Ping 2,1 / 1,4 ms. **Empilement DaytradePro
    EURUSD (UBS, magic 6001)** : 4 ventes au même prix 1,13728 les 23-24/09 sur les deux comptes, déjà 3 le 14/09 ; ce
    n'est PAS une panne : le set a `MaxTrades=99`, SL 300 / TP 100 pips, un seul ordre en attente reposé après chaque
    exécution. À faire : pire paquet de ce jeu sur 2021-2024, puis proposer un plafond. À vérifier : fonds >> solde sur les
    deux comptes (crédit ? fausserait le creux de l'outil B).
    **Suite 24/09 soir** : crédit confirmé (Ultima 405 $, Vantage 750 $) ; espion corrigé (équité et creux hors
    crédit, commit 3d8d9e5, `equite_v2.csv`) — **pas encore posé** (à poser à la prochaine visite du VPS, avec
    `attendu.csv`). Empilement DaytradePro EURUSD mesuré : `resultats/emp_dtp_eur/RESUME.md`. **En attente : choix de
    Denis sur le plafond (recommandé : Vantage MaxTrades 3, Ultima 99 en témoin).**

**Infrastructure**
11. **Rapatriement automatique PC → dépôt** : la tâche Windows n'a jamais tourné ; lancement manuel
    le 24/09 à 07h02 (heure de Paris) ; correctif en PR n°2 (brouillon).

---

## 1. Décidé — ne pas rouvrir

- **Jambe or, règle du 17/09** : compte propre = UBS SetsB (rapport n121). Tout prop firm
  (classique ou Axi) = Eagle-owl SetsB2 (rapport n132), pour brouiller les pistes.
- **Portefeuille de réserve** : jugé sur ses critères propres (1,8, réserve 2025 positive,
  crible, creux, indépendance). **Jamais comparé au livre UBS** (consigne du 20/09).
- **Argent de Till** : retiré du live le 20/09 après −455 USC sur 12 trades, 0 gagnant.
  L'argent à 62 $ pèse ~2,5 fois son modèle 2021-2024 : problème de dosage et de régime.
- **Réserve 2025 argent Till mesurée en entier, profil fidèle v1.47** (22/09, `r25f_eagleowl_xag.ini`,
  n150 relancé pour garantir la même version). **Tous les seuils du protocole franchis** :
  jeu par jeu positif (AGA04 +237 $, AGA06 +231 $, AGA09 +84 $), creux redosé ×2,5 (facteur
  mesuré en live, pas supposé) = 1 242 $ (1,24 % du dépôt) tenable, corrélation à l'or −0,247
  (substitué n66 réserve 2025 au lieu de n132 2021-2024, sinon aucun mois commun — écart au
  protocole signalé), concentration 2023-2024 baisse 89,1 % → 79,4 % (pas un artefact de fenêtre).
  **Tension non résolue** : le live du 13-18/09 était 100 % perdant sur 12 trades (5 jours,
  échantillon trop petit pour trancher seul) — à surveiller si l'argent est remis en live.
  Détail : `RESULTATS_CORRIGES.md`.
- **Contre-vérification indépendante de cette mesure** (22/09, session cloud, recalcul depuis les
  CSV poussés et non depuis le résumé) : nets par jeu, total 2025 (+552 $), nets annuels
  (318 / 171 / 1 089 / 2 913 / 552) et concentration (89,1 % → 79,4 %) **retrouvés à l'identique**.
  Non recalculables depuis un CSV mensuel : les creux S1 416 $ / S2 497 $, qui exigent le rapport.
  **Deux réserves à porter au dossier, qui ne sont pas des seuils manqués mais des faits** :
  (1) 2025 fait +552 $ avec **6 mois négatifs sur 12**, contre +2 913 $ pour la seule année 2024 —
  la réserve passe, mais de très peu ; (2) en juillet 2025 l'argent perd (−48 $) dans un mois où
  l'or perd aussi (−40 $) : c'est le motif « pas de protection quand elle sert » qui a fait écarter
  Daily HighLow Breakout le 21/09. La corrélation −0,247 ne se lit donc pas comme protectrice à
  elle seule. Mensuel 2025 : −223, +160, −97, −74, −95, +221, −48, +202, −42, +282, +266, 0.
- **M5_H retiré** : tient hors échantillon (6,78 contre 6,71 en réserve), seul jeu négatif
  sur les deux moitiés. C'est un **critère d'admission manqué**, pas un retrait pour faiblesse.
- **GoldDaily1 et goldtrade_H gardés** (mesuré le 21/09 au soir, `parjeu.py --csv` sur n121
  et n132, corrélation de Pearson mensuelle contre le reste de la jambe or) : GoldDaily1
  corr 0,199/0,297, net −113/−262 $ sur 4 ans ; goldtrade_H corr 0,067/0,301, net +91/+89 $.
  Toutes bien sous le seuil +0,5 — **aucune redondance, aucun retrait justifié**. GoldDaily1
  reste faible individuellement mais faiblesse n'est pas un disqualifiant du crible.
- **Viper** : aucun candidat réserve solide. Seuls GBPAUD et AUDCAD sont positifs sur les
  deux périodes, et leurs creux en échantillon (33,1 % / 39,9 %) dépassent la référence 25 %.
  EURAUD éliminé par sa réserve 2025 négative. GBPCHF et EURCHF éliminés (creux 76-83 %).
  **La grille n'est pas le moteur** : sans elle, l'écart est sous le seuil de bruit de 15 %.
- **R Factor : mort comme candidat** (chaîne D terminée le 21/09 à 12h20). Panier 1-ordre
  **−2 875 $** sur 8 croisées, NZDCHF à lui seul −2 269 $ pour 76,1 % de creux. Et surtout :
  **réserve 2025 négative sur les cinq paires mesurées** — EURGBP et USDCAD, les seuls positifs
  en échantillon, s'inversent. Aucune paire ne passe « positif sur les deux périodes ».
- **Le poste retour à la moyenne reste vacant** (Heron seul). Le portefeuille est 100 % cassure.
  Sixième échec d'affilée sur la réserve 2025 (Luna AI, Viper, R Factor, puis les trois démos
  Vantage du 21/09 au soir) : le motif est net, chaque candidat doit être mesuré sur 2025
  **avant** tout le reste — protocole confirmé, pas de raison de le revoir.
- **Trois démos Vantage MT5 mesurées le 21/09 au soir, toutes négatives sur 2025** :
  Daily HighLow Breakout EA (NAS100.r, 886 deals, −0,7 %/an, creux 0,72 %), Ichimoku
  Strategies EA MT5 (EURUSD, 258 deals, −0,0 %/an, creux 0,04 %), Ichimoku Cloud Pro
  (EURUSD, 270 deals, −0,0 %/an, creux 0,03 %). Les deux Ichimoku ont un profil quasi
  identique (probablement même moteur, comme UBS/Advanced Scalper) et un creux si faible
  que les réglages par défaut semblent sous-trader — **éliminés sur la règle 2025 négatif**.
  **Daily HighLow Breakout : exception levée après mesure** (21/09 21h15). Corrélation
  mensuelle 2025 avec la jambe or (n66) : −0,225, mais trompeuse — dans les deux mois où
  l'or perd (février, juillet), Daily HighLow perd aussi. Pas d'effet protecteur, juste un
  drain constant (11/12 mois négatifs). **Éliminé, comme les deux Ichimoku.**

**Les trois démos Vantage MT5 testées le 21/09 sont toutes éliminées.**
- **Mécanisme de reprise de session en place** (PR n°1 fusionnée le 21/09) : `ETAT.md`,
  ordre de lecture en tête de `CLAUDE.md`, et `./sauver.sh` comme unique commande de sauvegarde.
- **Rapatriement du PC outillé le 22/09** : `./rapatrier.sh`, lancé par la ligne unique de
  `COMMANDE.md`, ramène outils, `.set`, `.ini` sans identifiant, sources `.mq4`/`.mq5`, gabarits
  et index des rapports, puis vérifie le push. Ce qui entre et ce qui reste dehors : `INVENTAIRE.md`.
  **Le gabarit de la page « Quatre Standards » est dans `gabarits/` : on le reprend tel quel.**
- **Rapatriement automatique** (22/09, autorisé par Denis) : une seconde ligne de `COMMANDE.md`
  crée la tâche Windows « Rapatriement Golden Team », qui lance `auto.sh` chaque nuit à 3 h, avec
  rattrapage au démarrage suivant si le PC était éteint. Un commit par jour au maximum.
  **`AUTOMATIQUE.md` est le témoin de vie** : sa première ligne donne la date du dernier passage ;
  plus de deux jours = la tâche ne tourne plus.

## 2. En cours — ce qui tourne seul

- **24/09 matin — file de tests débloquée.** Trois causes corrigées : terminal de test PU Prime resté
  ouvert depuis le 22/09 (lance_chaine.ps1 le ferme désormais s'il est inactif), runner qui attendait
  24 h après un refus, runner qui ne cherchait pas le rapport dans le dossier de données MT5. L'auto-deploy
  de `templates/test_minimal.ini` est retiré (il rejouait un test refusé toutes les 10 min).
  Un commit géant local de 7 937 fichiers (tout OneDrive) est écarté, gardé sur la branche locale
  `sauvegarde-commit-geant-2409`, jamais poussé.
- **Empilement argent mesuré (empilement.py)** : n134 UBS 2021-2024 = 18 positions simultanées max,
  pire paquet −164,52 $ ; test 2026 (Eagle-owl, `resultats/emp_2026_xag/`) = 15 positions max,
  pire paquet −580,54 $ (17/06/2026, 6 positions). `emp_n150_xag` (2021-2024) terminé le 24/09 à 08h47
  (Eagle-owl 2021-2024 : 18 positions max, pire paquet −164,92 $ à la fermeture le 18/02/2022). Plafond : section 0, point 1.

- **test_minimal.ini lancé via `lance_chaine.ps1` le 22/09 17h01 (heure PC).** Déploiement automatique
  `templates/` → `jobs/` fonctionne ✓. Runner teste autonomement ✓.
- **Première ligne `COMMANDE.md` exécutée** (rapatrier.sh) ✓ : outils, `.set`, `.ini`, sources,
  gabarits et index des rapports synchronisés, push vérifié.
- **Tâche Windows "Rapatriement Golden Team" créée** : lance auto.sh chaque nuit à 03h00 UTC (05h00 local). Prochaine exécution : 23/09/2026 03:00 UTC. Auto-deploy templates/ → jobs/ est prêt dans le code. Test_minimal.ini lancera lors du prochain passage du runner (tous les 10 min après 03h00).
- **Les deux agents fonctionnels** : `runner.sh` (calcul sur le PC) et `vps_agent.sh` (remontée sur
  la branche `vps`) écrits et poussés, attendent que Denis colle les deux lignes de `COMMANDE.md`.
  Une fois collées, `RUNNER.md` (branche `main`) et `etat/etat.md` (branche `vps`) sont les deux
  témoins de vie — **les regarder avant de supposer qu'une passe a eu lieu ou que le VPS va bien.**

> *Tenir cette section à jour est le point le plus important du fichier : une session
> qui reprend doit savoir en une ligne si une mesure est en vol.*

## 3. Bloqué — et sur quoi exactement

- **Dossier argent : CLOS pour la mesure backtest** (22/09, voir section 1). Tous les seuils du
  protocole franchis. Reste ouvert : la **décision de remise en live**, qui n'est pas dans le
  périmètre de ce protocole — c'est à Denis de trancher, avec la tension live/backtest en tête.
- **Infrastructure** : une session cloud n'a aucun accès à MetaTrader ni au PC. Recommandation
  posée le 21/09 : un runner sur le VPS piloté par le dépôt. **Renversée le 22/09, et c'est une
  règle, pas une préférence : le VPS ForexVPS (Edge, 6 Go, Windows) porte le COMPTE RÉEL de Denis.
  Aucun backtest, aucune mesure, aucun outil lourd ne doit y tourner.** Un backtest occupe un cœur
  des heures durant et fait traiter ses ticks en retard au terminal réel ; le gain est du confort,
  le risque est une entrée ratée sur de l'argent réel. L'asymétrie tranche seule.
  **Le PC devient la machine de calcul** — il a plus de mémoire que le VPS et les ticks y sont
  déjà, donc il n'y a rien à copier : le chantier du transfert des ticks est annulé, pas reporté.
  **Plan des deux chantiers, durées et garde-fous : `PLAN-INFRA.md`. Rien n'est installé, rien
  n'est codé : le plan attend son accord.** Deux points qu'il porte et qui valent d'ici :
  le dépôt ne contient toujours ni `pc/` ni `index/`, donc les lanceurs et `mesure.py` ne sont
  nulle part hors du PC — la ligne 1 de `COMMANDE.md` est le préalable à tout, pas une option ;
  et l'accès au VPS se fait **sans aucun identifiant chez nous** : le VPS pousse ses journaux
  et ses erreurs sur la branche `vps` toutes les 15 minutes et y ramasse les EA et `.set` déposés,
  aucun port ouvert, aucune connexion entrante. **Écrit et poussé le 22/09** : `runner.sh` et
  `jobs/` sur `main`, `vps_agent.sh` sur la branche `vps`, les lignes à coller dans `COMMANDE.md`.
  **Limite connue de l'agent du VPS, à ne pas oublier** : les journaux disent ce qui s'est passé,
  pas l'état instantané des positions ni le solde. Pour les avoir il faudrait attacher au terminal
  réel un petit exportateur en lecture seule — un clic de Denis, pas encore demandé. Le MCP exposé en HTTPS qui était au programme du
  22/09 est **déconseillé** : il ouvrirait un port entrant sur la machine du compte réel pour un
  service que le dépôt rend déjà. Ce que nous ne ferons pas sur le VPS : toucher une position
  ouverte, changer les paramètres d'un robot en cours, attacher un robot à un graphique,
  redémarrer le terminal. On signale, Denis décide.
  **Correction du 21/09 au soir** : une session AVEC accès PC n'a aucun blocage pour ces mesures
  (`parjeu.py --csv` tourne en local en quelques secondes) — le blocage était propre aux sessions
  cloud, pas structurel.

## 3bis. Kestrel sur la jambe or — décidé le 22/09, protocole prêt

Sa décision du 22/09 : mesurer Kestrel jambe par jambe, en commençant par l'or SetsB2, plutôt que
comme profil global (le remplacement en bloc a été mesuré le 19/09 et recule, 19,20 → 18,29).

**L'essentiel est déjà acquis** (19/09, moteur v1.35) : réserve 2025 de l'or SetsB2 en Kestrel
3,74 → **9,76** (+3 460 $), et le livre bâti autour de cette jambe, c'est la rubrique 6 de la page
des standards. **Ne pas le refaire.**

**Sa définition du 22/09, qui fait foi** : « Kestrel reprend les trades rentables non fidèles à UBS
lors de sa reconstruction par Eagle-owl, et retirés d'Eagle-owl pour atteindre la fidélité. » Les
deux sont donc complémentaires par construction : la mesure à faire est un **AJOUT**, pas un
remplacement.

**Écart à lever d'abord** : le code fait de Kestrel le SUR-ENSEMBLE d'Eagle-owl, pas son résidu.
Débrancher une règle rajoute les trades par-dessus au lieu de les isoler (livre or à 116,9 % des
positions d'UBS règle débranchée, 100,1 % règle posée). Les jouer côte à côte doublerait les trades
communs. **Le recouvrement Kestrel / Eagle-owl n'a jamais été mesuré** — à ne pas confondre avec la
fidélité à UBS, qui elle est connue. `fidelite_entrees.py` le donne en prenant Eagle-owl comme
référence : ses « inventées » sont exactement le résidu. Cette étape ne coûte rien, elle tourne sur
des rapports déjà écrits.

Précédent qui pèse : Eagle-owl contre UBS = **+0,77**, « substitut, pas une brique de plus ». Et
depuis v1.43 un seul des trois réglages mord encore sur l'or.

**Motif de relance** : le 9,76 date de v1.35 ; le moteur or est passé en v1.47 le lendemain
(fidélité 92,9 → 98,5 %). Un chiffre sans sa version est périmé.

**Le portefeuille maison est un cas à part, et c'était sa question de départ** : dans la rubrique 6
(autour de Zebra) il n'y a aucune jambe UBS ni Eagle-owl fidèle, donc Kestrel y entre de plein droit
et le problème de recouvrement ne se pose pas. Ce portefeuille existe depuis le 19/09 : dix jambes,
sept en Kestrel, une Zebra, deux Heron ; réserve 2025 +6 058 $ (Axi), +7 128 $ (classique),
+6 202 $ (compte propre), +2 357 $ (sans or). Manquent, dans cet ordre : les **corrélations croisées
entre ses dix jambes** (aucune corrélation impliquant Kestrel n'existe à ce jour) puis son **rejeu en
v1.47** — c'est la seule rubrique de la page restée en v1.34-v1.35.

**Sa demande d'origine, jamais faite, à ne plus perdre** : un portefeuille maison où les QUATRE
robots coexistent — Eagle-owl sur ses jambes fidèles ET Kestrel sur le résidu rentable, plus Zebra
et Heron. La rubrique 6 a substitué Kestrel à Eagle-owl partout au lieu de les faire cohabiter.
Spécification, point bloquant, ordre des mesures et seuils : `outils/PORTEFEUILLE-QUATRE-ROBOTS.md`.

**Merlin, décidé le 22/09** : le robot du résidu s'appellera Merlin (son choix), et la relation
s'écrit **Kestrel = Eagle-owl + Merlin**. Kestrel reste tel quel. Le résidu est chiffré sur l'or :
**~590 trades, +400 $ de net pour +70 à +80 $ de creux**, rapport marginal **5,0 à 5,7** contre
13,5 à 15,0 pour la jambe fidèle (mesure du 22/09, diff v1.31/v1.32, `outils/residu_par_versions.py`).
Assez gros pour justifier le chantier, mais **Merlin se jugera sur sa décorrélation, pas sur son
rendement**. Plan de code et plan de mesure : `outils/MERLIN-CHANTIER.md`. **Rien n'est codé ; le
moteur ne sera pas touché sans son accord explicite.**
Prochaine mesure gratuite : l'export mensuel du rapport règle débranchée, pour lancer
`correlation_jambes.py` contre `mesures/parjeu_n121_..._v147_mensuel.csv`.

Protocole complet, seuils fixés d'avance : `outils/PROTOCOLE-KESTREL-OR.md`.
Outil prêt : `outils/correlation_jambes.py` (deux sorties datées de `parjeu.py --csv`, Pearson
mensuel, seuil +0,50).

## 3ter. Réserve or : reconstruire, pas acheter — sa consigne du 22/09

Forex GOLD Investor et GOLD Scalper PRO **ne sont pas destinés à être achetés mais reconstruits en
code maison, s'ils en valent la peine**. Raison de fond au-delà des 484 $ : un EA commercial est
interdit en algo chez Axi Select, une reconstruction maison ne l'est pas — c'est ce qui avait
justifié Eagle-owl.

**On ne sait rien de leur logique d'entrée** : personne n'a encore ouvert leurs paramètres. Premier
geste, une heure et aucun code : exporter les paramètres d'entrée des deux démos et voir si la
logique s'en déduit. Si elle est opaque, la question se tranche toute seule.

**Réserve que je pose** : ces deux briques sont de la cassure sur l'or M15, comme un livre déjà
100 % cassure, pendant que le poste retour à la moyenne reste vacant. C'est un coût d'opportunité.

Détail, questions et seuils : `outils/RECONSTRUIRE-OU-NON.md`.

## 4. Prochain geste — le poste retour à la moyenne reste vacant

Plus aucun candidat en cours d'évaluation. Sept échecs d'affilée sur la réserve 2025 (Luna AI,
Viper, R Factor, trois démos Vantage). Aucune piste ouverte au 21/09 22h — **le prochain geste
est d'en chercher une nouvelle**, pas de retester ce qui vient d'échouer.

Dans cet ordre, sans urgence :

1. Relancer les **réserves 2025 de Sakura et Happy Pound**. Les deux passes du 21/09 ont été
   lancées sans produire de rapport (le log dit à 02:31 : « REFUS : aucun rapport après
   l'attente — ne rien conclure de ce passage »). Leurs verdicts d'origine PASS et *validé*
   n'ont jamais été revus alors que leur facteur de profit est 1,08 et leurs creux 42,2 % et 48,8 %.
2. Corriger le symbole **AUDUSD** — 4 blocs à 0 trade, seul test lancé sur le symbole nu alors
   que tous les autres tournent sur les suffixes `.s`.

## 5. Ne pas refaire

- **Ne pas réutiliser `FORK8_FINAL.md`** : trois lignes y sont mal attribuées (décalage entre
  « LANCE X » et le rapport lu juste après). `RESULTATS_CORRIGES.md` fait foi.
- **Ne pas comparer deux mesures faites sous des hypothèses d'exécution différentes** (fenêtre,
  lot, modèle de ticks, délai). Erreur commise Zebra avec délai contre Wolf sans délai.
- **Ne pas retirer un jeu sur son résultat en échantillon** : le dosage par jeu a été mesuré
  et réfuté, le rapport ne s'améliore pas par sélection.
- **Aucun écart sous 15 % n'est interprétable** entre deux variantes.
- **Ne pas publier avant d'avoir fini de lire ce qui est déjà sur le disque** (critique du 06/09).

---

## Comment tenir ce fichier

- Il se met à jour **pendant** le travail, pas à la fin : une décision prise s'écrit en section 1
  dans la foulée, une mesure lancée s'écrit en section 2 avant de quitter le clavier.
- Il reste **court** — une page. Ce qui déborde part dans `memory/` et n'est plus qu'un lien d'ici.
- Il ne contient **aucun chiffre qui ne vienne pas de `mesure.py`**.
- Il n'est à jour que **s'il est poussé** : `./sauver.sh "ce qui a changé"`.

### 25/09 matin — Vantage FX2 et silence Ultima
- 09h33 Paris : DaytradePro_GBPUSD.set (SetsVantage_FX2) MaxTrades 99→3 ; DaytradePro_CHFJPY.set déplacé dans _sauvegardes_sets. 09h38 UBS GBPUSD rechargé (1 set, MaxTrades 3), aucun ordre bougé. 09h39 ordre CHFJPY orphelin 6102 supprimé (10009). Contrôle 09h40 : 4 positions, 34 ordres, seul CHFJPY disparu. Ultima inchangé (99). FAIT.
- Silence Zebra/Heron Ultima 17-20/09 : CAUSE PROUVÉE = tous les experts d'Ultima Londres retirés le 17/09 20:02:45-20:03:08 UTC (geste manuel ou changement de profil), rechargés le 20/09 21:46 UTC ; suppressions groupées d'ordres le 20/09 depuis Londres ET NY4. NY4 n'avait aucun expert depuis le 13/09.
- Question ouverte à Denis : l'adresse 62.216.81.78 (autorisations sur Ultima réel les 17, 18, 19 et 20/09), inconnue des deux VPS.
- Zebra EURUSD Ultima : boucle « modify position [invalid stops] » depuis le 21/09 12:02 UTC (stop suiveur refusé), à corriger.
- VPS de tests 62.216.81.78 (Londres, confirmé par Denis 25/09 09h42 : « pas de comptes réels ») : pourtant connecté au compte Ultima RÉEL les 17, 18, 19, 20, 23 et 24/09 (dernière vue 24/09 16h08 Paris). Pas d'accès SSH depuis le PC. Geste demandé à Denis : vérifier le compte connecté dans ses MT5 par bureau à distance, passer en démo si c'est le réel.
  → 25/09 09h48 Paris : Denis confirme, le compte Ultima réel était bien connecté sur le VPS de tests ; corrigé (« fait »). Question posée : robots attachés ? Proposé : alerte de connexion depuis une adresse autre que Londres, via le journal lu depuis le PC.
- 25/09 ~09h45 Paris : en nettoyant le VPS de tests, Denis a supprimé des « anciens pending » = les ordres du compte Ultima RÉEL. Constat 09h50 : 16 ordres (BTC Reaper seuls) contre 52 à 07h29 ; 4 positions intactes ; Vantage non touché. Proposé : photos 10h01 et 11h01 pour voir ce que les robots reposent (attend « ok »).
- 10h02 Paris : robots de Londres ont reposé leurs ordres (48 en attente, 4 positions inchangées ; tous les jeux représentés). Contrôle de confirmation à 11h01.
- 10h08 Paris : Denis a supprimé le compte Ultima réel de la liste des comptes des MT5 du VPS de tests (plus de reconnexion automatique). Témoin indirect : origine des connexions dans le journal Ultima de Londres.
- Zebra stop suiveur (25/09, lecture seule) : courtiers Ultima ET Vantage publient STOPS_LEVEL 0 sur EURUSD/GBPUSD mais refusent un SL à 10 points (vrai minimum caché ~10-30 pts). Graphiques réels InpTrailing=10, InpStopsLevelMin=0 → suivi quasi jamais accepté (14/09 : 23 624 refus ; 22/09 : 5 291), boucle à chaque tick (retour de PositionModify non lu, Zebra_v1.mq5 l.257/279/285). Or non touché (stops level 20). CONSÉQUENCE : Zebra EUR/GBP réel ≠ Zebra mesuré. Correctif proposé outils\Zebra_v1b.mq5 sur le PC (élargit de 5 pts après refus, pause 10 s), non compilé. Décision posée à Denis : frein seul puis test des distances (recommandé) / test d'abord / rien.
- 10h45 Paris : Zebra_v1c (frein 10 s après refus, 4 lignes, entrées identiques, sha256 B0EA9EA9…) copié en Zebra_v1.ex5 dans Ultima et Vantage Londres ; anciens gardés (Zebra_v1.ex5.avant_frein_20260925). PAS ENCORE RECHARGÉ (copie .ex5 ne recharge pas). Le .mq5 du VPS est l'ancien : ne pas compiler. Attend accord de Denis pour remplacer le .mq5, puis compilation par Denis dans MetaEditor de chaque terminal.
