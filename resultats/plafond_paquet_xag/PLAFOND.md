# Plafond de perte par paquet — argent Till (24/09/2026)

**Proposition : 450 $ par tranche de 0,01 lot, au prix actuel de l'argent (64,44 $ le 23/09).**
Au réel sur le compte cent, à 0,01 lot : **450 USC** (le paquet du 16/09 fait −459,99 $ au test
et −455 USC au réel, même échelle). Quand le prix bouge, le plafond suit : **7 × le prix de l'argent**
(450 / 64,44 ≈ 7) ; à 55 $ → 385, à 75 $ → 525. Pour un lot double, plafond double.

## D'où vient le chiffre

- Trois rapports de test, profil fidèle v1.47 (Eagle-owl, jeux AGA04/06/09, 0,01 lot, ticks réels) :
  `emp_n150_xag` (2021-2024), `r25f_eagleowl_xag` (2025), `emp_2026_xag` (2026 jusqu'au 23/09).
  Chiffres globaux de `mesure.py`, VÉRIFIÉ sur les trois : soldes finaux 104 491 / 100 552 / 104 284.
- **597 paquets** (435 + 92 + 70) rejoués **minute par minute** sur l'historique M1 du courtier
  (PU Prime, fichiers `.hcc` du terminal de test) pour connaître la **pire perte en cours** de chaque
  paquet, pas seulement sa perte à la fermeture.
- **Contrôles** : somme des paquets = solde final de `mesure.py` au centime près sur les trois rapports
  (4 490,97 / 551,57 / 4 284,12) ; 6 204 transactions sur 6 224 tombent dans leur barre minute.
- Chaque paquet est **ramené au prix actuel** (× 64,44 / prix à l'ouverture du paquet) : une même
  variation en % coûte 2,5 à 2,8 fois plus de dollars à 64 $ qu'à 23-25 $.

## Les pires paquets, ramenés au prix actuel (par 0,01 lot)

| Paquet | Positions max | À la fermeture | Pire en cours |
|---|---|---|---|
| vente 16/09/2026 (le paquet réel) | 12 | −475 | **−632** |
| achat 03/12/2025 | 9 | −504 | −627 |
| achat 17/06/2026 | 6 | −526 | −612 |
| vente 22/03/2021 | 13 | −467 | −599 |
| achat 18/02/2022 | 14 | −450 | −552 |
| vente 03/08/2026 | 6 | −472 | −533 |

Le 16/09 est descendu à −632 avant de fermer à −475 : **le pire risque n'est pas la perte finale**.

## Impact de chaque plafond sur le résultat (ramené au prix actuel)

| Plafond | 2021-2024 | 2025 | 2026 | Paquets coupés qui auraient fini gagnants |
|---|---|---|---|---|
| 300 | **−868** | **−895** | +642 | 2 (achat d'oct. 2024 descendu à −345 puis fini à +847 ; vente d'oct. 2025 descendue à −334 puis finie à +716) |
| 350 | +223 | +78 | +392 | 0 |
| 400 | +73 | −22 | +142 | 0 |
| **450** | **+17** | **+54** | **+122** | **0** |
| 500 | −83 | +4 | −28 | 0 |
| 600 | 0 | −96 | −200 | 0 |

Résultat sans plafond, même base : +10 627 / +608 / +3 666.

**Pourquoi 450 et pas 350** : 350 rapporte plus, mais il est à 5 $ du précipice — l'achat d'octobre 2024
est descendu à −345 avant de finir très gagnant, et à 300 on le coupe (−868 et −895). 450 est le seul
seuil **positif sur les trois périodes** avec 100 $ de marge au-dessus de ce paquet. Il coupe 6 paquets
en 5 ans et 9 mois (environ un par an), aucun n'aurait fini gagnant, et le pire paquet passe de −632 à −450.

**Sans ramener au prix** (le test tel quel) : 2021-2024 inchangé (aucun paquet n'atteint 450 à 23 $),
2025 +9,48, 2026 +5,86.

## Ce que ce plafond ne fait pas

- **Ce n'est pas un gain**, c'est une assurance : +193 $ sur 5 ans 9 mois au total. Il borne la queue.
- Sur le paquet du 16/09 lui-même, il n'aurait sauvé que 25 $ (−450 au lieu de −475) : ce paquet est
  remonté. Il protège contre le même paquet **qui ne remonte pas**.
- Hypothèses non vérifiées : fermeture au plafond exact (12 positions à fermer d'un coup = glissement
  possible) ; après la coupe, le robot peut rouvrir sur le même niveau, non modélisé ; le test est le
  clone Eagle-owl, pas UBS lui-même (il reproduit le paquet réel du 16/09 à 5 $ près).
- UBS n'a pas ce réglage : il faudra un gardien externe qui ferme le paquet (à choisir, pas fait).

Outil : `outils/plafond_paquet.py` ; sortie complète : `balayage.txt`.
