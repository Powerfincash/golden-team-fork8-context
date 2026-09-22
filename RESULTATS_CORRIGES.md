# Résultats Viper/R Factor — corrigés (21/09, suite à l'audit fork 8)

**Erreur trouvée par fork 8** : décalage dans le log entre "LANCE X" et le rapport affiché juste après (le script lisait parfois le .htm du test PRÉCÉDENT avant que le nouveau soit écrit). L'artifact d'origine attribuait le rapport Happy Pound à Viper EURAUD_2025, et le rapport Viper EURAUD 2021-2024 à Viper GBPAUD_2025. Vérifié par le nombre de ticks modélisés (143M = 4 ans, ~30M = 2025 seul).

## Viper, résultats vérifiés

| Test | 2021-2024 | Réserve 2025 |
|------|-----------|--------------|
| EURAUD | 1221 tr, +1 628 $, chute 10,3 % | 361 tr, **−625 $**, chute 29,9 % |
| GBPAUD | 1046 tr, +1 682 $, chute 33,1 % | 289 tr, +613 $, chute 22,5 % |
| GBPCHF | 686 tr, **−1 092 $**, chute **82,8 %** | 196 tr, +528 $, chute 38,9 % |
| EURCHF | 1087 tr, **−1 907 $**, chute **75,8 %** | 284 tr, +570 $, chute 10,5 % |
| AUDCAD | 754 tr, +378 $, chute 39,9 % | 234 tr, +420 $, chute 13,0 % |
| AUDUSD | 0 trade (3 passes) — **test raté**, pas un résultat |

**Verdict fork 8** : seuls GBPAUD et AUDCAD positifs sur les deux périodes, mais creux en échantillon (33,1 % / 39,9 %) dépassent la référence 25 % → dosés au pire, perdent l'essentiel de l'intérêt. EURAUD éliminé par la réserve (négative). GBPCHF/EURCHF éliminés par l'échantillon (creux 76-83 %).

**Grille** : pas le moteur. Sans grille, EURAUD +1 638 $ vs +1 628 $, AUDCAD +400 $ vs +378 $ — écart sous le seuil de bruit 15 %. Viper passe cet éliminatoire mais retirer la grille ne rapporte rien.

**Conclusion : Viper n'a pas de candidat réserve solide.**

## R Factor, panier

| Paire | Net $ |
|-------|-------|
| EURAUD | −197 |
| EURCAD | −186 |
| EURCHF | +8 |
| EURGBP | +361 |
| GBPCHF | **−1 230** |
| USDCAD | +338 |
| USDCHF | +305 |
| **Total panier** | **−603 $** |

**Verdict fork 8** : R Factor perdant en panier, GBPCHF porte la perte. Comme candidat retour à la moyenne : **non**.

## Corrélations B3/B4 — la question a changé

Aucune série de trades ni sortie parjeu.py dans ce dépôt pour calculer les corrélations.

**M5_H** : déjà tranché par la mémoire moteur-multi-jeux du 08/09 — retrait tient hors échantillon (6,78 contre 6,71 en réserve), seul jeu négatif sur les deux moitiés (−0,32 / −0,32). **Échoue un critère d'admission, ce n'est pas un retrait pour faiblesse.** Pas besoin de corrélation.

**GoldDaily1 et goldtrade_H** : rien d'équivalent. La même mémoire dit que le dosage par jeu a été réfuté (rapport ne s'améliore pas par sélection). **Les retirer sur leur résultat en échantillon reproduirait une erreur déjà réfutée.**

## Mise à jour 21/09 12h20 — Chaîne D terminée (1-ordre + réserve 2025)

**R Factor 1-ordre** (NZDCHF ajouté à Market Watch, testé pour la première fois) :
EURAUD −198 $/18,6 %, EURCAD −186 $/13,2 %, EURCHF +8 $/9,3 %, EURGBP +361 $/6,3 %,
GBPCHF −1 234 $/43,3 %, **NZDCHF −2 269 $/76,1 %**, USDCAD +338 $/2,1 %, USDCHF +305 $/4,9 %.
Panier total : **−2 875 $** (NZDCHF catastrophique, pire que la grille normale).

**R Factor réserve 2025** : TOUT négatif sur les 5 paires avec résultat —
EURAUD −427 $, EURCAD −265 $, EURCHF −48 $, EURGBP −106 $, GBPCHF −566 $.
NZDCHF/USDCAD/USDCHF 2025 : échec technique, aucun rapport produit.

**Verdict final : R Factor mort comme candidat réserve.** Même EURGBP et USDCAD (seuls
positifs, faible creux en échantillon) s'inversent en négatif sur la réserve 2025. Aucune
paire ne passe le critère minimal "positif sur les deux périodes".

## 21/09 20h58 — Trois démos Vantage MT5, réserve 2025 mesurée en premier

Crible d'entrée passé par les trois (aucune grille comme moteur, symboles cohérents,
aucun vendeur douteux identifié) — voir palmarès/symbole/grille dans `memory/`.

| Robot | Symbole | Deals 2025 | Rendement/an | Creux |
|-------|---------|-----------|---------------|-------|
| Daily HighLow Breakout EA | NAS100.r | 886 | −0,7 % | 0,72 % |
| Ichimoku Strategies EA MT5 | EURUSD | 258 | −0,0 % | 0,04 % |
| Ichimoku Cloud Pro | EURUSD | 270 | −0,0 % | 0,03 % |

**Tous négatifs sur 2025.** Règle du protocole : négatif sur 2025 = éliminé sans autre passe.

- **Ichimoku Strategies EA MT5** et **Ichimoku Cloud Pro** : éliminés. Profils quasi
  identiques (deals proches, creux quasi nul, rendement quasi nul) — probablement le
  même moteur sous deux noms, comme UBS/Advanced Scalper. Réglages par défaut : sous-trading
  suspect (creux 0,03-0,04 % sur un an), pas un vrai test de la stratégie.
- **Daily HighLow Breakout EA** : décision de Denis (21/09) — gardé en observation malgré
  le résultat négatif, pour mesurer sa corrélation avec le portefeuille (creux très faible,
  0,72 %, pourrait diversifier même en étant légèrement perdant seul). **Exception explicite
  à la règle "négatif 2025 = éliminé sans autre passe", à ne pas généraliser.**
  Mesure de corrélation non encore faite — nécessite l'historique M1 du portefeuille.

## 21/09 21h05 — Corrélations GoldDaily1 / goldtrade_H, mesurées

Contrairement à ce que pensait l'artifact précédent, le dépôt contenait déjà des sorties
`parjeu.py` (dossier `mesures/`), mais dans le mauvais format (résumé annuel par jeu, pas la
série mensuelle nécessaire à une corrélation). Relancé proprement : `outils/parjeu.py <rapport>
--csv` sur **n121** (EagleOwl_v1, XAUUSD.p, compte propre SetsB) et **n132** (SetsB2, prop firm),
ticks réels, 2021-2024. CSV bruts dans `mesures/parjeu_n121..._v147_mensuel.csv` et
`..._n132..._v147_mensuel.csv`. Script de corrélation : `outils/correlation_golddaily1_goldtradeh.py`
(Pearson mensuel, jeu agrégé sur tous ses sous-niveaux de prix contre le reste du panier).

| Jeu | n121 (compte propre) | n132 (prop firm) |
|-----|----------------------|-------------------|
| GoldDaily1 | corr **0,199**, net −113 $ (48 mois actifs/48) | corr **0,297**, net −262 $ |
| goldtrade_H | corr **0,067**, net +91 $ (47/48) | corr **0,301**, net +89 $ |

**Verdict : aucune redondance (seuil +0,5), aucun retrait justifié.** GoldDaily1 reste faible
individuellement (net négatif sur les deux comptes) mais le crible ne retire pas sur faiblesse,
seulement sur redondance. Retirer ces jeux sur leur résultat en échantillon reproduirait
l'erreur du dosage par jeu déjà réfutée (mémoire `moteur-multi-jeux.md`, 08/09).

## 21/09 21h15 — Corrélation Daily HighLow Breakout / jambe or, mesurée : exception levée

Série mensuelle 2025 extraite (`diag_sorties.positions`) pour n66 (jambe or, réserve 2025) et
d01_dailyhlbreakout_2025 (NAS100.r). Script : `outils/correlation_dailyhl_portefeuille.py`.

| Mois | Or (n66) | Daily HighLow Breakout |
|------|----------|--------------------------|
| 2025-02 | −155 $ | **−54 $** |
| 2025-07 | −40 $ | **−38 $** |
| (10 autres mois) | positifs pour l'or | négatifs pour DHL sauf un quasi-nul |

Corrélation mensuelle : **−0,225**. Trompeuse : ne vient pas d'un effet protecteur mais du fait
que DHL est négatif quasi tout le temps (11/12 mois) pendant que l'or a de gros mois positifs.
**Dans les deux mois où l'or perd, DHL perd aussi** — aucune protection du creux, effet
inverse (drain constant qui aggraverait légèrement le max DD).

**Verdict : l'exception posée le 21/09 (gardé « au cas où ») ne tient pas à la mesure. Daily
HighLow Breakout EA est éliminé, comme les deux Ichimoku, sur la règle négatif 2025 = éliminé.**

**Conclusion de la session du 21/09 : les trois démos Vantage sont toutes éliminées.**

## 22/09 14h — Réserve 2025 argent Till, profil FIDÈLE v1.47, mesurée en entier

Protocole complet exécuté : `outils/PROTOCOLE-ARGENT-RESERVE2025.md`. Config créée :
`r25f_eagleowl_xag.ini` (copie de n150 avec dates 2025, sans surcharge `Fid_ReposeMaxTrades`
= profil fidèle par défaut, confirmé v1.47 par le `#property version "1.47"` du .mq5 compilé
le 20/09 12h04). n150 (référence 2021-2024) relancé aussi pour garantir la même version —
il datait d'avant la compilation v1.47 (11h38 vs 12h04), risque de comparer deux versions.

### A. Jeu par jeu (2025, agrégé sur tous les sous-niveaux de prix via parjeu.py --csv)
AGA04 +237 $, AGA06 +231 $, AGA09 +84 $ — **les trois positifs, aucun ne sort**.

### B. Redosage sur la volatilité courante (facteur ×2,5, mesuré en live — pas une hypothèse)
Creux au pire des deux moitiés (S1 jan-juin 416 $, S2 juil-déc 497 $) au lot 0,01 backtest :
**497 $**. Redosé ×2,5 : **1 242 $ (1,24 % du dépôt de référence 100 000 $)** — tenable.
Le facteur ×2,5 vient de `memory/banc-mesure-ultima.md` (17/09) : stops réels ~2,5× plus
gros qu'en moyenne 2021-2024, mesuré sur le glissement live, pas supposé.

### C. Corrélation à la jambe or — écart au protocole signalé
Le protocole demandait n132 (or 2021-2024) : **aucun mois commun avec l'argent 2025**,
corrélation non interprétable sous cette forme. Substitué par n66 (or SetsB, réserve 2025,
même fenêtre temporelle) : **corrélation de Pearson mensuelle -0,247** — bien sous le seuil
+0,50, aucune redondance.

### D. Concentration 2023-2024 dans le net, avant/après ajout de 2025
2021 +318 $, 2022 +171 $, 2023 +1 089 $, 2024 +2 913 $, 2025 +552 $.
Avant 2025 : part 2023-2024 = **89,1 %**. Après 2025 : part 2023-2024 = **79,4 %**.
**Baisse confirmée — pas un artefact de fenêtre réglée par le vendeur.**

### Verdict : tous les seuils du protocole sont franchis
| Critère | Seuil | Résultat | Verdict |
|---|---|---|---|
| Réserve 2025 agrégat | positive | +552 $ | PASS |
| Réserve 2025 jeu par jeu | chaque jeu positif | 3/3 positifs | PASS |
| Creux redosé | tenable | 1 242 $ (1,24 %) | PASS |
| Corrélation à l'or | ≤ +0,50 | -0,247 | PASS |
| Concentration 2023-2024 | doit baisser | 89,1 % → 79,4 % | PASS |

**Tension non résolue, à ne pas taire** : le live du 13-18/09 (12 trades, 5 jours,
`memory/banc-mesure-ultima.md`) était **100 % perdant** (−455 USC, percentile 0 de la
référence n134). Le backtest 2025 fidèle passe tous les seuils sur l'année entière, mais
l'échantillon live (5 jours) reste trop petit pour être rassurant à lui seul — surveiller si
l'argent est remis en live.

Outils : `outils/argent_reserve2025.py`. CSV mensuels : `mesures/parjeu_r25f_eagleowl_xag_v147_mensuel.csv`,
`mesures/parjeu_n150_eagleowl_xag_v147_mensuel.csv`.
