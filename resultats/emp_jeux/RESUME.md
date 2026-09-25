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

## Bilan 2 (24/09/2026 20h58-23h11 Paris) : 14 tests mono-jeu, mesure.py VÉRIFIÉ, réserve = 01/01/2025 → 23/09/2026

| Jeu (magic) | net 2021-24 / réserve | creux fonds 2021-24 / réserve | simult. max | max × stop (% 1 505 $) |
|---|---|---|---|---|
| DaytradePro GBPUSD (6101) | +341 / **−131** | – / 289 | 12 / 10 | 276 (18 %) — seul jeu UBS perdant en réserve ; paquets 7-13 perdants |
| DaytradePro CHFJPY (6102) | +447 / +73 | – / 123 | 16 / 12 | 262 (17 %) |
| Gold Reaper 6 (2006, MaxTrades 5) | +847 / +860 | 104 / 162 | 5 / 4 | 917 (61 %) — stop 183 $ / position |
| Heron NZDCAD (sans stop) | +111 / −0,62 | 166 / 96 | 3 | non borné |
| Heron AUDCAD (sans stop) | +473 / +132 | 111 / 110 | 3 | non borné |
| Gold Reaper 5 (2005) | +678 / +609 | 75 / 129 | 5 / 4 | 443 (29 %) |
| DaytradePro XAUUSD (50513) | +313 / +290 | 85 / 67 | 4 / 7 | 136 (9 %) |
| Goldtrade D (1004) | +297 / +577 | 57 / 130 | 3 | 111 (7 %) |
| Goldtrade H (1008) | +170 / +372 | 59 / 172 | 3 | 95 (6 %) |
| Gold Reaper 4 (2004) | +491 / +1 009 | 70 / 108 | 3 | 65 (4 %) |
| Goldtrade E (1005) | +246 / +92 | 31 / 70 | 2 | 44 (3 %) |

Lecture (Claude) : les jeux or MaxTrades 99 n'empilent en pratique que 2 à 7 positions ; le vrai problème de
Gold Reaper 6 et 5 est la TAILLE du compte Vantage (1 505 $, sous le capital minimum de 2 865 $ calculé le 17/09),
pas le réglage. Prochaines mesures proposées : GBPUSD et CHFJPY 99/3/1 sur les deux fenêtres ; Heron avec stop ATR 3 et 5.
Fichiers complets sur le PC : Documents\forex\resultats\emp_jeux\.

## Bilan 3 (25/09/2026 matin) : plafonds DaytradePro GBPUSD et CHFJPY, 12 tests VÉRIFIÉ
net / creux de fonds / simultanées max

| Jeu | MaxTrades | 2021-2024 | réserve 01/2025 → 23/09/2026 |
|---|---|---|---|
| GBPUSD 6101 | 99 (réel) | +338 / 273 / 12 | −131 / 289 / 10 |
| GBPUSD 6101 | 3 | +185 / 118 / 3 | −23 / 115 / 3 |
| GBPUSD 6101 | 1 | +75 / 59 / 1 | +16 / 38 / 1 |
| CHFJPY 6102 | 99 (réel) | +450 / 233 / 16 | +73 / 123 / 12 |
| CHFJPY 6102 | 3 | +173 / 125 / 3 | −23 / 99 / 3 |
| CHFJPY 6102 | 1 | +76 / 61 / 1 | −27 / 70 / 1 |

Comptes au 25/09 07h29 Paris : Vantage solde 1 505,04 $, 9 positions (4 ventes EURUSD, 5 Heron −5,48 $) ;
Ultima idem ; NY4 Ultima/Vantage toujours fermés.

## Bilan 4 (25/09/2026 08h34 Paris) : Heron avec stop ATR, 8 tests VÉRIFIÉ
net / creux de fonds / simultanées max

| Heron | 2021-2024 | réserve 01/2025 → 23/09/2026 |
|---|---|---|
| AUDCAD sans stop (réel) | +473 / 111 / 3 | +132 / 110 / 3 |
| AUDCAD stop 3 ATR | +263 / 116 / 3 | −19 / 97 / 3 |
| AUDCAD stop 5 ATR | +384 / 120 / 3 | +82 / 102 / 3 |
| NZDCAD sans stop (réel) | +111 / 166 / 3 | −1 / 96 / 3 |
| NZDCAD stop 3 ATR | −205 / 264 / 3 | −204 / 228 / 3 |
| NZDCAD stop 5 ATR | −31 / 219 / 3 | −83 / 124 / 3 |

Un stop dégrade Heron (retour à la moyenne : coupé, il ré-entre aussitôt, 9 à 16 entrées par épisode au lieu de 3).
Proposition (Claude, 25/09) : Vantage — GBPUSD MaxTrades 3 ; CHFJPY retiré (gain de réserve dû aux seuls gros paquets,
plafonné il devient perdant) ; Heron AUDCAD inchangé ; Heron NZDCAD : mesurer d'abord sa corrélation avec AUDCAD
(redondance > +0,5 = vrai disqualifiant du crible), pas de retrait sur la seule faiblesse. Ultima garde tout en témoin.
