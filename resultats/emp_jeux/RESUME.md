# Empilement réaliste des jeux des comptes réels — 24/09/2026 (bilan 1)

Contexte : inventaire des jeux chargés à Londres (24/09 20h50 Paris) — 9 jeux UBS à MaxTrades=99.
Perte au stop d'une position lue sur les vrais ordres en attente (API MT5, lot 0,01, prix du 24/09).
Chiffres de test : rapports existants sur le PC, ticks réels 2021-2024, PU Prime, lot 0,01 ; sets vérifiés
contre ceux de Vantage (seul écart : magic des sets FX2 dans SetsC_FX2). Paquets comptés par magic.

| Jeu (magic) | rapport | net 4 ans | creux solde | creux fonds | simult. max | paquets ≥2 | pire paquet | max × stop (% solde Vantage 1 505 $) |
|---|---|---|---|---|---|---|---|---|
| Gold Reaper 6 (2006) | n168 | +847 | 88 | 104 | 5 | 137/348 | −54,30 (4 achats 27-28/08/2024) | 917 (61 %) |
| Gold Reaper 5 (2005) | n167 | +678 | 62 | 75 | 5 | 97/411 | −48,48 | 443 (29 %) |
| DaytradePro GBPUSD (6101) | n52 | +341 | – | – | 12 | 20/34 | −32,34 | 276 (18 %) |
| DaytradePro CHFJPY (6102) | n52 | +447 | – | – | 16 | 28/44 | −113,05 (4 achats 07-09/2021) | 262 (17 %) |
| DaytradePro EURUSD (6001) | emp_dtp_eur | +318 | 32 | – | 11 | 54/70 | −31,44 | 330 (22 %) → plafonné à 3 le 24/09 |
| Goldtrade D (1004) | s_gtpd | +297 | 51 | 57 | 3 | 18/135 | −19,56 | 111 (7 %) |
| DaytradePro XAUUSD (50513) | s_dtpor | +313 | 40 | 85 | 4 | 45/118 | −24,58 | 78 (5 %) |
| Heron AUDCAD (maison, sans stop) | n80 | +473 | 94 | 111 | 3 | – | −47,12 | creux fonds 111 |
| Heron NZDCAD (maison, sans stop) | n81 | +111 | 157 | 166 | 3 | – | −43,09 | creux fonds 166 |

Plafond EURUSD vérifié en réel (Vantage) : UBS rechargé à 18:46:13 UTC, sell stop 6001 annulé et non reposé,
aucun autre ordre modifié sur 10 minutes (31 ordres, 9 positions).
En cours : tests mono-jeu Goldtrade H (1008), Goldtrade E (1005), Gold Reaper 4 (2004) ; réserve 2025-2026 de tous.
