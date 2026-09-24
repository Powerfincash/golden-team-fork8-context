# DaytradePro_EURUSD (jeu UBS, magic 6001) — empilement, 24/09/2026

Test sur le PC de Denis, 24/09/2026 19h39-19h55 (Paris) : Ultimate Breakout System avec CE SEUL jeu
(copie du set réel `SetsVantage_EUR\DaytradePro_EURUSD.set`, ForceSymbol=EURUSD.p), EURUSD.p M15,
ticks réels (Model=4), 2021.01.04 → 2024.12.31, lot 0,01, dépôt 100 000, protocole n134.
Seule différence entre variantes : `MaxTrades`. mesure.py : VÉRIFIÉ (C1 C2 C3) pour les trois.
Paquets comptés par un script local (empilement.py du dépôt refusé par le garde-fou du PC),
contrôlé : entrées = sorties, total = mesure.py.

| MaxTrades | deals | net 4 ans | creux solde | simultanées max | paquets ≥2 | pire paquet multiple |
|---|---|---|---|---|---|---|
| 99 (réglage réel) | 374 | +317,62 $ | 31,88 $ | 11 ventes / 9 achats | 54 / 70 | −15,64 $ (3 ventes, 12/2024) |
| 3 | 258 | +147,74 $ | 31,60 $ | 3 / 3 | 40 / 56 | −15,64 $ |
| 1 | 122 | +50,08 $ | 31,52 $ | 1 / 1 | 0 / 61 | — |

- Creux de solde identique partout : deux stops complets isolés (09/2021, 06/2022, ~−31 $).
- Aucun paquet multiple n'a touché le stop de 300 pips en 4 ans ; l'empilement fait l'essentiel du gain.
- Creux de FONDS non mesuré (pas d'historique M1) : c'est lui qui compte pour un paquet.
- Risque théorique au stop, 0,01 par position : 99 → 11 × 30 ≈ 330 $ ; 3 → ≈ 90 $.
- Réel au 24/09 : 4 ventes à 1,13728 sur Ultima et Vantage (≈ 120 $ au stop sur Vantage, 8 % du solde).
- En cours : mêmes variantes 99 / 3 sur 2025 et 2026 (hors échantillon), avant toute proposition en réel.

Fichiers sur le PC : `Documents\forex\resultats\emp_dtp_eur\` (rapports, ini, sets, journaux, paquets.py).
