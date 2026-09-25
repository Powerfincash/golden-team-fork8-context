# Robots MT5 de démo chargés le 25/09/2026 — crible 2025-2026

Terminal de test PU Prime (compte démo 700023324), téléchargés par Denis entre 12h41 et 12h47 (heure de Paris).
Ticks réels (Model=4), dépôt 100 000 USD, levier 500, ExecutionMode=0, réglages d'origine sauf mention.
Réserve 2025.01.01 → 2026.09.23 (ticks PU Prime sains après le 31/10/2024). Chiffres : `outils/mesure.py`
(tous VERIFIE C1 C2 C3). Positions simultanées : `outils/reglages_positions.py`. Corrélations : P&L journalier
et hebdomadaire réalisé, `outils/correl_jour.py`. Chaînes : `chaine_demos_2509b/c/d.log`.

| Test | Robot, symbole | Réglage | %/an | Creux solde | Trades | PF | Simult. max | Lots |
|---|---|---|---|---|---|---|---|---|
| d04 | Quantum StarMan, EURUSD.p H1 (5 paires) | origine (autolot, risque 3), `InpSuffix=.p` | 2,8 | **29,78 %** (2026) | 757 | – | **39** | 0,67 à 0,8+ |
| d01 | Dark Gold, XAUUSD.p M15 | origine : **EnableGrid=true**, 50 ordres/sens | 3,0 | 2,37 % | 6 845 | – | 27 | 0,01 → 0,10 |
| d05 | Dark Gold | sans grille, 1 ordre/sens, tendance | **−0,7** | 2,09 % | 1 671 | 0,47 | 2 | 0,01 |
| d06 | Dark Gold | sans grille, contre-tendance (StrategyUsed=1) | **−1,3** | 2,72 % | 872 | 0,19 | 2 | 0,01 |
| d03 | Dark Rea, EURUSD.p H1 | origine : **EnableGrid=true**, 10 ordres/sens | 0,2 | 0,02 % | 365 | 2,42 | 8 | 0,01 → 0,08 |
| d07 | Dark Rea | sans grille, 1 ordre/sens | 0,0 (+78 $) | 0,00 % | 169 | 12,6 | 1 | 0,01 |
| d08 | Dark Rea 2021-2024 (ticks générés, voir mémoire) | sans grille | **−0,1** | 0,26 % | 63 | – | 1 | 0,01 |
| d09 | Dark Rea 2021-2024 (ticks générés) | origine, grille | 0,2 | 0,06 % | 560 | – | 10 | 0,01 → 0,10 |
| d02 | Sharpshooter, EURUSD.p H1 | origine (lot 0,01, SL 81, TP 82) | −0,0 | 0,09 % | 144 | **0,97** | 1 | 0,01 |

## Verdicts (règle de Denis du 25/09 : « si grid, on neutralise »)
- **Quantum StarMan : éliminé.** Grille sans aucun réglage pour la couper (seul `InpTradingMethod` 0/1, sens non
  documenté). 39 positions à la fois, creux 29,8 % en 2026 après un pic à ~149 k$.
- **Dark Gold : éliminé.** Sans grille il perd dans les deux sens (tendance PF 0,47, contre-tendance PF 0,19) :
  la grille est le moteur. Structure : petit gain (TakeTarget 50 points), pas de vrai stop (une position à −1 521 $
  pour 0,01 lot), 99 % de gagnants. Le poste « retour à la moyenne » reste vacant.
- **Dark Rea : éliminé.** Sans grille : ~0 en 2025-2026 (169 gagnants sur 169, chance), perte en 2021-2024
  (une seule position à −257 $ efface 62 gains). La grille (jusqu'à 10 positions, lot x10) fait le résultat.
- **Sharpshooter : éliminé pour faiblesse**, pas pour un défaut : une position, pas de grille, mais PF 0,97 sur 144
  trades. Réserve : le vendeur écrit « Contact Us for EA Preset », ses réglages de vente ne sont pas publics ;
  testé aux réglages par défaut seulement.

## Corrélations (réalisé, 2025-2026) — toutes faibles, aucune ne disqualifie
- Dark Gold (grille) contre Gold Reaper 4/5/6, GoldTradePro d, DaytradePro or, EagleOwl or : jour −0,03 à +0,02,
  semaine −0,08 à +0,08.
- Dark Rea (avec et sans grille) contre DaytradePro GBPUSD et CHFJPY, Heron AUDCAD et NZDCAD : jour −0,08 à +0,04,
  semaine −0,11 à +0,14.
- Limite : un robot qui garde ses pertes ouvertes (Dark Gold, Dark Rea) les montre tard dans le réalisé ;
  la corrélation réalisée sous-estime alors le risque commun.

## Incidents de chaîne
- 1er lancement (12h52) : StarMan refusé (`EURAUD` introuvable, les symboles démo portent `.p` → `InpSuffix=.p`),
  et le lanceur, parti depuis un shell d'outil qui s'est fermé, est mort avec lui. Relancé en tâche de fond.
- 2e lancement : le journal `chaine_demos_2509b.log` n'a pas reçu ses lignes (fichier verrouillé par un `tail -F`
  de suivi). Suivre un journal de chaîne par lecture périodique (python), jamais `tail -F`.
