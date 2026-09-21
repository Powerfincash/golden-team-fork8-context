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
