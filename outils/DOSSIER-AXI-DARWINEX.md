# Comptes réels Axi Select et Darwinex : dossiers de mise en route

Préparé le 26/09/2026. **Rien n'est ouvert ni installé** : ouverture et pose des robots attendent l'accord
écrit de Denis. Chiffres : uniquement vrais ticks, deux contrôles passés (base_unique.py + symbole de
chaque transaction), source = fil « Relevé des tests de la nuit ». Les règles des courtiers sont citées
avec leur lien ; quand deux sources se contredisent, la source officielle l'emporte et l'écart est dit.

---

## 0. Compte Axi Select : Denis en a déjà un (ouvert, jamais utilisé)

- Le programme dépend d'**AxiTrader LLC** (Saint-Vincent-et-les-Grenadines) :
  [Axi, What is Axi Select](https://help.axi.com/en-US/axiv2--axicorp-prod/article/1YzJXzUf-what-is-axi-select).
  Ce sont donc les règles de la section 1 qui s'appliquent, pas celles d'Axi EU (CySEC).
- Il démarre en **Pre-Seed** : c'est le compte réel à son nom qui construit l'Edge Score (50 requis) avec
  500 $ minimum, avant tout compte financé.
- À vérifier dans le Client Portal, une fois : plateforme du compte (MT4 ou MT5, un seul possible) et type
  (Standard ou Pro), qui fixent le nom des symboles (section 1.4).

---

## 1. Axi Select

### 1.1 Règles qui contraignent le dosage (source officielle : [axi.com, Funded Trader Program](https://www.axi.com/int/funded-trader-program))

| Étape | Capital propre min. | Edge Score | Multiplicateur | Financement max | Part des gains | Objectif | Durée min. | Trades min. | Perte max |
|---|---|---|---|---|---|---|---|---|---|
| Pre-Seed | 500 $ | 50 pour sortir | – | pas de compte financé | – | – | aucune | – | – |
| Seed | 500 $ | 50 | ×10 | 5 000 $ | **0 %** | +7 % | 30 j | 20 | −7 % |
| Incubation | 1 000 $ | 60 | ×10 | 20 000 $ | 40 % | +7 % | 60 j | 40 | −7 % |
| Acceleration | 2 000 $ | 70 | ×25 | 100 000 $ | 50 % | +7 % | 60 j | 50 | −7 % |
| Pro | 5 000 $ | 90 | ×40 | 200 000 $ | 60 % | +7 % | 60 j | 50 | −7 % |
| Pro 500 | 10 000 $ | 90 | ×50 | 500 000 $ | 70 % | +7 % | 60 j | 50 | −7 % |
| Pro M | 20 000 $ | 90 | ×50 | 1 000 000 $ | 80 % | – | – | – | −10 % |

Pre-Seed : [Axi, Pre-Seed](https://help.axi.com/en-US/axiv2--axicorp-prod/article/wCX2oD82-what-is-the-preseed-stage-in-axi-select).
Axi précise que ces conditions sont « indicatives et sujettes à changement ».

- **Perte max −7 % FIXE** : mesurée depuis le capital alloué **au début de l'étape**, pas depuis le plus haut ;
  **latent compris** ; un dépôt en cours d'étape ne l'élargit pas. Seed et Pro : **exclusion immédiate** ;
  autres étapes : quarantaine. [Axi, calcul des 7 %](https://support.devrev.ai/en-US/axiasia--axicorp-prod/article/3Dj0lCCx-how-is-the-7-maximum-loss-calculated-in-axi-select).
  → c'est la contrainte de dosage : le pire creux du livre, **latent intrajournalier compris**, doit rester
  nettement sous 7 % du compte alloué.
- **Robots** : « seuls vos propres EA sont autorisés » ; un EA tiers ne peut servir qu'à des signaux, trades
  passés à la main ; pas de copie. [Axi, EA et Axi Select](https://help.axi.com/hc/en-us/articles/39381948835609-Can-I-use-an-Expert-Advisor-EA-with-my-Axi-Select-Account).
  → livre **100 % maison** (Eagle-owl, Heron). UBS et tout binaire ProfAlgo sont exclus.
- **Trading court interdit** sur Axi Select, HFT et arbitrage aussi ; martingale autorisée ; la couverture
  (positions opposées) est interdite « via l'Axi Trading Platform » (l'appli maison d'Axi, pas MT4/MT5).
  [Axi, stratégies autorisées](https://support.devrev.ai/en-US/axisvg--axicorp-prod/article/30gUWO-L-what-trading-strategies-are-allowed).
  Écart de sources : [TheTrustedProp](https://thetrustedprop.com/prop-firms/axi-select) écrit « positions
  opposées interdites » et « martingale interdite » ; la page officielle dit l'inverse pour la martingale.
  → **deux vérifications** à faire sur nos rapports : durée des positions de chaque jambe (aucune jambe
  scalping) et nombre de moments où Eagle-owl tient un achat et une vente sur le même symbole.
- **Edge Score** : quatre composantes (Skill, Risk, Consistency, Experience), formule non publiée.
  [Axi, Edge Score](https://support.devrev.ai/en-US/axiasia--axicorp-prod/article/KPWOhP1u-how-is-my-axi-select-edge-score-calculated).
- Un seul compte Axi Select, MT4 **ou** MT5 ; compte Standard ou Pro.
  [Axi, rejoindre](https://support.devrev.ai/en-US/axiasia--axicorp-prod/article/o11WQa7E-how-do-i-join-or-register-for-axi-select).

### 1.2 Ce que ça change à notre modèle « challenge 41 jours »

Notre calcul suppose un palier unique +7 % / −7 %. Le vrai chemin est plus long :
Pre-Seed (Edge ≥ 50 sur son propre argent) → Seed (≥ 30 j, ≥ 20 trades, **0 % des gains**) → Incubation
(≥ 60 j, ≥ 40 trades, 40 % des gains, 20 000 $ max). **Premier euro touché : pas avant l'Incubation**,
soit au mieux plusieurs mois. Les 41 jours mesurent seulement le temps de faire +7 % une fois.

### 1.3 Portefeuille (livre Axi sans Zebra, 13,23)

Livre C sans Zebra, 100 % maison. Vrais ticks 2021-2024, deux contrôles passés. Au dosage 100 000 $
(marge 50 %, multiplicateur 9,23) : creux 3,50 %, pire jour −1,82 %, pire mois −2,16 % ; +7 % atteint avant
−7 % dans 100 % des tirages, délai médian 38 jours (`risque_courtiers.py`). Capital minimum imposé par le
lot 0,01 : **10 831 $** (or, AdvSc, argent).

| Jambe | Rapport | Symbole test | Jeux | Lot à 100 k$ | **Lot à 20 k$ alloués** | Durée moy. | Part < 3 min |
|---|---|---|---|---|---|---|---|
| EO or B2 | vt07_n132_vrai | XAUUSD | SetsB2 | 0,092 | 0,02 | 11,9 h | 5,5 % |
| EO EUR | vtj_n117 | EURUSD | SetsC_EUR | 0,277 | 0,06 | 40,9 h | 1,1 % |
| EO CHFJPY | vtj_n118 | CHFJPY | SetsC_FX2 | 0,277 | 0,06 | 176,6 h | 0,6 % |
| EO GBPUSD | vtj_n119 | GBPUSD | SetsC_FX2 | 0,277 | 0,06 | 207,7 h | 0 % |
| EO AdvSc JPY | vtj_n120 | USDJPY | SetsAS_JPY_test | 0,092 | **retirer (voir plus bas)** | 1,8 h | 6,6 % |
| EO argent Till | vtj_n150 | XAGUSD | SetsClient_XAG | 0,092 | 0,02 | 5,1 h | 2,0 % |
| EO JPY D1 | vtj_n153 | USDJPY | SetsClient_JPY_D1 | 0,277 | 0,06 | 29,0 h | 3,4 % |
| EO storyG | vtj_n154 | EURUSD | SetsClient_EUR_storyG | 0,462 | 0,09 | 39,2 h | 7,9 % |
| EO USO H4 | vtj_n155 | USOUSD (WTI) | SetsClient_USO_H4 | 0,277 | 0,06 | 10,2 h | 2,6 % |
| Heron AUDCAD | vtj_n80 | AUDCAD | paramètres dans vtj_n80_heron_audcad.ini | 0,185 | 0,04 | 46,3 h | 0 % |
| Heron NZDCAD | – | NZDCAD | – | 0 | 0 | – | – |

Lots à 20 k$ = lot à 100 k$ × 0,2 arrondi au centième : l'arrondi déforme un peu les poids (jusqu'à
+9 % sur l'or et l'EUR), sans risque au regard de la marge de 50 %. **Ce n'est pas une mesure** : le fil des tests
doit rejouer ce livre aux lots arrondis avant la pose.

**Parcours et capital recommandés**
- **Capital propre 2 000 $** : c'est le seuil d'Acceleration et, à ×10, il donne en Incubation les
  20 000 $ alloués, maximum de l'étape, au-dessus des 10 831 $ imposés par le lot plancher.
- **Seed (5 000 $ alloués max)** : le livre n'y tient pas fidèlement (l'or à 0,01 y serait 2,2 fois trop
  dosé). Mais le Seed paie 0 % et se recommence à volonté : y jouer le livre sans l'or et sans l'argent
  (jambes à 0,01 et plus sur 5 000 $), le temps de valider 30 jours, 20 trades et +7 %. À mesurer avant.
- **Les positions courtes, point à faire trancher par Axi par écrit** : 0 à 7,9 % des positions de
  plusieurs jambes durent moins de 3 minutes (sorties sur fausse cassure ou stop touché aussitôt). Axi
  interdit le « trading court » sans publier de seuil. Question au support avant la pose : « quelle durée
  minimale de détention ? ». **AdvSc JPY est retiré d'office** : c'est un scalpeur (1,8 h en moyenne,
  6,6 % sous 3 minutes) et sa réserve 2025 est perdante. Le livre sans AdvSc est à redoser par le fil
  des tests (vrai recalcul, pas une soustraction).
- La marge à levier 100:1 n'est pas une contrainte à ces lots.

### 1.4 Symboles Axi (compte Standard ; compte Pro = suffixe `.pro` sur devises et métaux)

Source unique : [OnlineForexMaster](https://onlineforexmaster.com/docs/how-to-get-symbols-from-axi-for-standard-and-pro-account/).
**À confirmer dans le Market Watch du compte réel.**

| Jambe | Test (PU Prime) | Axi Standard | Axi Pro |
|---|---|---|---|
| Or | XAUUSD_VRAI | XAUUSD | XAUUSD.pro |
| Argent | XAGUSD_VRAI | XAGUSD | XAGUSD.pro |
| EUR, storyG | EURUSD_VRAI | EURUSD | EURUSD.pro |
| GBP | GBPUSD_VRAI | GBPUSD | GBPUSD.pro |
| JPY D1 | USDJPY_VRAI | USDJPY | USDJPY.pro |
| CHFJPY | CHFJPY_VRAI | CHFJPY | CHFJPY.pro |
| Heron | AUDCAD_VRAI, NZDCAD_VRAI | AUDCAD, NZDCAD | AUDCAD.pro, NZDCAD.pro |
| USO H4 | USOUSD (WTI) | USOIL | USOIL |

Dans chaque `.set` : prendre la version sans `_VRAI` et mettre le ForceSymbol au nom du courtier.

---

## 2. Darwinex

### 2.1 Entité et ouverture

- Résident UE → **Sapiens Markets EU Sociedad de Valores SA**, régulée CNMV (Espagne).
  [Darwinex, régulation](https://help.darwinex.com/where-and-how-is-darwinex-regulated).
- Dépôt minimum 500 EUR/USD/GBP ; **devise du compte choisie une fois pour toutes** ; MT4 ou MT5.
  [Darwinex, ouvrir un compte](https://help.darwinex.com/fr/comment-ouvrir-un-compte-darwinex).
  → **USD recommandé** : toutes nos jambes gagnent en dollars ; un compte en euros ajoute le bruit EUR/USD
  à la VaR, donc au dosage imposé par Darwinex.
- Levier client de détail (règles ESMA) : devises majeures 30:1, matières premières 10:1 à 20:1.
  [Darwinex, actifs](https://help.darwinex.com/assets-available).
- Coût : commission ≈ 0,005 % du nominal (≈ 5 € par lot EURUSD). [Darwinex, coûts](https://help.darwinex.com/execution-costs).

### 2.2 Le moteur de risque : ce qui fixe le dosage

- VaR **mensuelle à 95 %**. [Darwinex, VaR](https://help.darwinex.com/var).
- Le DARWIN est ramené dans une bande de **VaR 3,25 % à 6,5 % par mois**, quel que soit le lot du trader ;
  VaR de la stratégie estimée sur les **45 derniers jours exposés** ; tolère un écart de VaR jusqu'à ×2 ;
  levier maximal du DARWIN (D-Leverage) 9,75 pour des positions de plus d'une heure.
  [Darwinex, moteur de risque](https://help.darwinex.com/risk-manager).
- **Conséquence** : le rendement du DARWIN ne dépend pas de notre lot, il dépend du **rapport gain / VaR**.
  Doubler les lots ne rapporte rien au DARWIN ; seul le livre compte. Notre lot ne fixe que le risque sur
  notre propre argent.
- **Stabilité du risque (Rs)** : notée sur les 12 dernières périodes, pénalise les variations de VaR, pas
  son niveau. [Darwinex, Rs](https://help.darwinex.com/risk-stability-attribute).
  → ne jamais changer les lots ni ajouter/retirer une jambe en cours de route sans raison forte.

### 2.3 Ce qui fait monter la note (DarwinIA)

- Note = rendement du mois (22 %) + rendement cumulé 6 mois (67 %) + creux max sur 6 mois (11 %) ;
  bonus +1/+2/+3 selon l'ancienneté (6-12, 12-18, 18 mois et plus).
  [Darwinex, note DarwinIA](https://help.darwinex.com/the-formula-of-the-darwinia-rating).
- **SILVER** : note ≥ 75 → allocation 30 000 € à 375 000 € pour 3 mois. **GOLD** : plus de 8 mois d'historique,
  rendement 1 an > 20 % et rendement/creux > 2,5 → 50 000 € à 500 000 € pour 6 mois. Commission de
  performance 15 %, trimestrielle, au plus haut. **Capital propre minimum 1 000 $ pendant tout le mois**
  (exclusion sous 900 $). [Darwinex, DarwinIA](https://help.darwinex.com/what-is-darwinia).

### 2.4 Portefeuille (livre Eagle-owl SetsB2 sans Zebra, 12,90)

Lots au dosage « creux 25 % » (capital 1 721 $) : EO or B2 0,01 ; EO EUR, CHFJPY, GBPUSD 0,03 chacun ;
EO argent Till 0,01 ; EO JPY D1 0,03 ; EO storyG 0,15 ; EO USO H4 0,03 ; Heron AUDCAD 0,04 ;
EO AdvSc JPY et Heron NZDCAD à 0. Pire jour −18,3 %, pire mois −14,7 % à ce dosage.

**Mesures (`risque_courtiers.py`, série journalière 2021-2024, 1 033 jours, +22 202 $ aux lots ci-dessus)**
- VaR mensuelle à 95 % : **153 $** ; gain mensuel moyen 457 $ ; rapport gain/VaR **2,99**.
- VaR mensuelle en % du capital, aux mêmes lots : 1 721 $ → 8,9 % ; 2 000 $ → 7,7 % ; **3 000 $ → 5,1 %** ;
  5 000 $ → 3,1 % ; 10 000 $ → 1,5 %.
- Ramené à la VaR cible de 6,5 %, le DARWIN ferait ≈ 19 %/mois ; à 3,25 %, ≈ 9,7 %/mois. **Chiffre de
  backtest, sans le facteur réel/backtest de 1,37 ni le latent intrajournalier** : il sert à classer, pas à promettre.
- **Point faible** : la VaR sur 45 jours varie d'un facteur **3,9** (10e à 90e centile) ; Darwinex tolère 2.
  Le livre Axi fait pire (10,4) : c'est une raison de plus de mettre le livre Eagle-owl propre chez Darwinex.
  Proposition : faire mesurer par le fil des tests un dosage « à VaR égale » par jambe, pour stabiliser
  la VaR (ce qui fait monter la note Rs).

**Capital recommandé : 3 000 $, compte en USD, lots du livre à 1 721 $ inchangés.**
- La VaR mensuelle tombe à 5,1 %, au milieu de la bande 3,25-6,5 % : le moteur de Darwinex n'a presque
  rien à corriger.
- Pour Denis : pire creux 430 $ = 14,3 % ; pire jour ≈ −10,5 % ; pire mois ≈ −8,4 % (règles de trois sur
  les chiffres à 1 721 $). Après le pire creux, il reste ≈ 2 570 $, loin du seuil d'exclusion DarwinIA de 900 $.
- **Reste à vérifier : la marge au levier de détail** (or 20:1, argent et pétrole 10:1) quand plusieurs
  jeux or sont ouverts en même temps. À mesurer avec l'outil d'empilement sur les rapports, avant la pose.

### 2.5 Symboles Darwinex

XAUUSD, XAGUSD, XTIUSD (pétrole WTI) confirmés par [Darwinex, actifs](https://help.darwinex.com/assets-available) ;
devises aux noms standard (EURUSD, GBPUSD, USDJPY, CHFJPY, AUDCAD, NZDCAD) **à confirmer dans le Market
Watch** (42 paires annoncées, liste non publiée sur cette page). USO H4 (USOUSD, WTI, chez PU Prime) → XTIUSD.

---

## 3. Ce qui reste à faire avant l'ouverture

1. Denis : dire si le compte Axi Select existant est MT4 ou MT5, Standard ou Pro (visible dans le Client Portal).
2. Denis ou nous : demander au support Axi la durée minimale de détention ; nous : compter les positions opposées d'Eagle-owl sur un même symbole.
3. Nous : rejouer le livre Axi aux lots arrondis de 20 k$, sans AdvSc ; mesurer la marge Darwinex à 3 000 $.
4. Après ouverture (accord écrit de Denis) : lire les noms de symboles dans le Market Watch, poser les `.set`
   corrigés, contrôler le premier jour avec l'espion.
