# Les robots en attente — état au 22/09/2026

Sa question du 22/09. Ce fichier ne liste que ce qui **attend quelque chose**. Les portefeuilles
retenus et leurs chiffres sont dans la page des standards ; les éliminés sont en bas, pour mémoire,
afin qu'on ne les relance pas.

## A. Retenus pour le portefeuille de réserve — à RECONSTRUIRE, pas à acheter

| Robot | Rapport 2021-2024 | Réserve 2025 | Ce qu'il attend |
|---|---|---|---|
| **Forex GOLD Investor** (XAUUSD M15, lot fixe 0,01) | **1,8** | **7,3** | une décision : reconstruire ou non (voir ci-dessous) |
| **GOLD Scalper PRO** (XAUUSD M15, lot fixe 0,01, AutoMM 0) | **1,7** | **8,1** | idem |

**Sa consigne du 22/09** : ces deux-là **ne sont pas destinés à être achetés mais reconstruits en
code maison, s'ils en valent la peine** — comme UBS l'a été avec Eagle-owl. Raison de fond, au-delà
des 484 $ : **un EA commercial est interdit en algo chez Axi Select**, une reconstruction maison ne
l'est pas. Ce qu'il faut pour trancher est dans `outils/RECONSTRUIRE-OU-NON.md`.

Réserves communes, écrites le 20/09 : deux briques de la **même famille** (cassure/impulsion sur
l'or M15), donc la réserve n'est pas encore diversifiée — il lui manque un retour à la moyenne et
une brique hors or ; réglages du vendeur non explorés ; GOLD Scalper PRO n'a que 41 avis et huit
mois de compte réel, en AutoMM 1 % (d'où les 27 % de creux affichés) ; Forex GOLD Investor n'a pas
de signal public.

## B. En attente d'une réserve 2025 — le verdict ne tient pas sans elle

| Sujet | Où il en est | Ce qu'il attend |
|---|---|---|
| **Les trois jeux argent de Till** (AGA04, AGA06, AGA09) | **retirés du live le 20/09** après −455 USC sur 12 trades, 0 gagnant | leur réserve 2025. **94 % de leur net a été fait en 2023-2024** et la fenêtre d'optimisation du vendeur est inconnue : c'est là qu'est le risque, pas dans les 12 trades |
| **Sakura** | verdict d'origine PASS, jamais revu | sa réserve 2025. La passe du 21/09 n'a produit aucun rapport (« ne rien conclure de ce passage »). PF 1,08 pour 42,2 % de creux |
| **Happy Pound** | verdict d'origine « validé », jamais revu | idem. PF 1,08 pour 48,8 % de creux |

## C. En attente d'être construit

| Robot | Où il en est |
|---|---|
| **Merlin** | nom retenu le 22/09, chantier spécifié dans `outils/MERLIN-CHANTIER.md`, **rien n'est codé**. Le résidu est chiffré (~590 trades, +400 $ sur l'or) mais il se jugera sur sa décorrélation. L'étape gratuite qui peut tout arrêter : la corrélation sur l'export mensuel. |

## D. En attente d'un premier examen — la file ouverte le 12/09

`outils/TESTS-A-REALISER.md` fait foi. Restent ouverts :

- **AOT** — trois réserves à lever avant achat.
- **UBS Range Breakout USDJPY** — candidat à ×5-×10, insensible au délai ; glissement réel à mesurer
  sur le banc Ultima. (Le Range sur l'or est clos.)
- **UBS Volatility Breakout** sur or, EURUSD et BTC — la famille n'a été mesurée que sur indices.
- **Le diagnostic du modèle S/R d'Eagle-owl sur devises**, qui débloque deux entrées d'un coup.

## E. En attente d'une correction d'outillage, pas d'un verdict

- **AUDUSD** : 4 blocs à 0 trade, le seul test lancé sur le symbole nu alors que tous les autres
  tournent sur les suffixes `.s`. À refaire.

## F. Éliminés — ne pas relancer

- **Viper** : aucun candidat solide. GBPAUD et AUDCAD positifs sur les deux périodes mais creux 33,1 %
  et 39,9 %, au-dessus de la référence 25 %. EURAUD éliminé par sa réserve 2025 négative.
- **R Factor** : panier −2 875 $ sur 8 croisées ; **réserve 2025 négative sur les cinq paires mesurées**.
- **Luna AI Pro** : 0,91 en échantillon, réserve 2025 négative (clos le 19/09).
- **Trois démos Vantage MT5**, toutes négatives sur 2025 (21/09) : **Daily HighLow Breakout EA**
  (NAS100.r), **Ichimoku Strategies EA MT5** et **Ichimoku Cloud Pro** (EURUSD). Les deux Ichimoku
  ont un profil quasi identique et un creux si faible qu'ils semblent sous-trader.
- **Crible FXAutomater du 20/09** : Infinity Trader (positions sans stop gardées jusqu'à 83 jours,
  rapport 0,7), Forex Diamond EURUSD, WallStreet GOLD Trader, WallStreet Recovery PRO (récupération
  = moteur, éliminatoire), Wall Street Scalper (1,8 sur 2021-2024 mais 2025 perdante).

**Le motif à retenir** : sept candidats d'affilée sont morts sur la réserve 2025. C'est pour cela
qu'elle se mesure **en premier**, avant tout le reste.

## Ce qui n'attend rien : le poste vacant

Le portefeuille est **100 % cassure**. Le poste **retour à la moyenne** est vacant, Heron mis à part.
Aucun candidat n'est en cours d'évaluation pour ce poste — le prochain geste est d'en chercher un
nouveau, pas de retester ce qui vient d'échouer.
