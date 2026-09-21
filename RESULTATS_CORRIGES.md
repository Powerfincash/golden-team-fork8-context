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
