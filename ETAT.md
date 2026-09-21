# État de reprise

> **Ce fichier est le premier à lire, et le seul qui fait foi sur « où on en est ».**
> Les autres fichiers du dépôt sont des archives : ils disent ce qui a été mesuré,
> pas ce qui est vivant. Un chiffre dans une archive sans date est un chiffre périmé.

**À jour au : 21/09/2026**
**Dernier geste : trois démos Vantage MT5 (Daily HighLow Breakout, Ichimoku Strategies EA MT5, Ichimoku Cloud Pro) mesurées en réserve 2025 — voir section 1.**

---

## 1. Décidé — ne pas rouvrir

- **Jambe or, règle du 17/09** : compte propre = UBS SetsB (rapport n121). Tout prop firm
  (classique ou Axi) = Eagle-owl SetsB2 (rapport n132), pour brouiller les pistes.
- **Portefeuille de réserve** : jugé sur ses critères propres (1,8, réserve 2025 positive,
  crible, creux, indépendance). **Jamais comparé au livre UBS** (consigne du 20/09).
- **Argent de Till** : retiré du live le 20/09 après −455 USC sur 12 trades, 0 gagnant.
  L'argent à 62 $ pèse ~2,5 fois son modèle 2021-2024 : problème de dosage et de régime.
- **M5_H retiré** : tient hors échantillon (6,78 contre 6,71 en réserve), seul jeu négatif
  sur les deux moitiés. C'est un **critère d'admission manqué**, pas un retrait pour faiblesse.
- **Viper** : aucun candidat réserve solide. Seuls GBPAUD et AUDCAD sont positifs sur les
  deux périodes, et leurs creux en échantillon (33,1 % / 39,9 %) dépassent la référence 25 %.
  EURAUD éliminé par sa réserve 2025 négative. GBPCHF et EURCHF éliminés (creux 76-83 %).
  **La grille n'est pas le moteur** : sans elle, l'écart est sous le seuil de bruit de 15 %.
- **R Factor : mort comme candidat** (chaîne D terminée le 21/09 à 12h20). Panier 1-ordre
  **−2 875 $** sur 8 croisées, NZDCHF à lui seul −2 269 $ pour 76,1 % de creux. Et surtout :
  **réserve 2025 négative sur les cinq paires mesurées** — EURGBP et USDCAD, les seuls positifs
  en échantillon, s'inversent. Aucune paire ne passe « positif sur les deux périodes ».
- **Le poste retour à la moyenne reste vacant** (Heron seul). Le portefeuille est 100 % cassure.
  Sixième échec d'affilée sur la réserve 2025 (Luna AI, Viper, R Factor, puis les trois démos
  Vantage du 21/09 au soir) : le motif est net, chaque candidat doit être mesuré sur 2025
  **avant** tout le reste — protocole confirmé, pas de raison de le revoir.
- **Trois démos Vantage MT5 mesurées le 21/09 au soir, toutes négatives sur 2025** :
  Daily HighLow Breakout EA (NAS100.r, 886 deals, −0,7 %/an, creux 0,72 %), Ichimoku
  Strategies EA MT5 (EURUSD, 258 deals, −0,0 %/an, creux 0,04 %), Ichimoku Cloud Pro
  (EURUSD, 270 deals, −0,0 %/an, creux 0,03 %). Les deux Ichimoku ont un profil quasi
  identique (probablement même moteur, comme UBS/Advanced Scalper) et un creux si faible
  que les réglages par défaut semblent sous-trader — **éliminés sur la règle 2025 négatif**.
  **Daily HighLow Breakout gardé en observation par décision explicite de Denis** (21/09,
  exception à la règle, à ne pas généraliser) : creux très faible, corrélation au
  portefeuille pas encore mesurée — nécessite l'historique M1 du portefeuille, absent du dépôt.
- **Mécanisme de reprise de session en place** (PR n°1 fusionnée le 21/09) : `ETAT.md`,
  ordre de lecture en tête de `CLAUDE.md`, et `./sauver.sh` comme unique commande de sauvegarde.

## 2. En cours — ce qui tourne seul

- **Rien ne tourne.** La chaîne des trois démos Vantage (réserve 2025) est terminée depuis le
  21/09 20h58 ; ses résultats sont versés dans `RESULTATS_CORRIGES.md`. Terminal Vantage MT5
  local refermé après le test (le lanceur ne ferme jamais un terminal existant : c'est à
  l'utilisateur, il l'a fait deux fois ce soir — avant le premier essai refusé, puis confirmé).

> *Tenir cette section à jour est le point le plus important du fichier : une session
> qui reprend doit savoir en une ligne si une mesure est en vol.*

## 3. Bloqué — et sur quoi exactement

- **Dossier argent** : suspendu à la réserve 2025 des trois jeux Till. 94 % de leur net a été
  réalisé en 2023-2024 et la fenêtre d'optimisation de Till est inconnue. C'est le vrai risque,
  pas les 12 trades live.
- **Corrélations GoldDaily1 et goldtrade_H** : impossibles à calculer ici. Le dépôt ne contient
  **aucune série de trades ni sortie de `parjeu.py`**. À lancer sur le PC.
- **Infrastructure** : une session cloud n'a aucun accès à MetaTrader ni au PC. Recommandation
  posée : un runner sur le VPS piloté par le dépôt (job commité, rapport et série de trades
  repoussés). Reste à dimensionner : quel VPS, quel OS, quel terminal, quels ticks déjà installés.

## 4. Prochain geste — deux en attente, aucun urgent

1. **Corrélations de GoldDaily1 et goldtrade_H contre la jambe or privée** (décidé par Denis
   le 21/09). `outils/parjeu.py` sur les rapports **n121** (UBS SetsB, compte propre) et
   **n132** (Eagle-owl SetsB2, prop firm). Au-delà de **+0,5**, le jeu est redondant et son
   retrait est justifié ; en deçà, le retirer reproduirait une erreur déjà réfutée.
   **Ne peut pas se faire depuis une session infonuagique** : les rapports et `parjeu.py`
   sont sur le PC. C'est à lancer là-bas.
2. **Corrélation de Daily HighLow Breakout EA (NAS100.r) avec le portefeuille**, pour juger
   l'exception posée le 21/09 au soir (négatif seul sur 2025, gardé quand même pour un possible
   effet diversifiant). Nécessite l'historique M1 du portefeuille — absent du dépôt, à lancer
   sur le PC. Sans cette mesure, l'exception reste une hypothèse, pas une décision.

Ensuite, dans cet ordre, sans urgence :

3. Relancer les **réserves 2025 de Sakura et Happy Pound**. Les deux passes du 21/09 ont été
   lancées sans produire de rapport (le log dit à 02:31 : « REFUS : aucun rapport après
   l'attente — ne rien conclure de ce passage »). Leurs verdicts d'origine PASS et *validé*
   n'ont jamais été revus alors que leur facteur de profit est 1,08 et leurs creux 42,2 % et 48,8 %.
4. Corriger le symbole **AUDUSD** — 4 blocs à 0 trade, seul test lancé sur le symbole nu alors
   que tous les autres tournent sur les suffixes `.s`.

**Note** : ces deux mesures (corrélations et Daily HighLow) sont faisables depuis une session
sur le PC — la session du 21/09 au soir en avait l'accès (Bash local, MetaTrader). Non faites
faute de temps, pas faute d'accès ; à reprendre en priorité par la prochaine session sur le PC.

## 5. Ne pas refaire

- **Ne pas réutiliser `FORK8_FINAL.md`** : trois lignes y sont mal attribuées (décalage entre
  « LANCE X » et le rapport lu juste après). `RESULTATS_CORRIGES.md` fait foi.
- **Ne pas comparer deux mesures faites sous des hypothèses d'exécution différentes** (fenêtre,
  lot, modèle de ticks, délai). Erreur commise Zebra avec délai contre Wolf sans délai.
- **Ne pas retirer un jeu sur son résultat en échantillon** : le dosage par jeu a été mesuré
  et réfuté, le rapport ne s'améliore pas par sélection.
- **Aucun écart sous 15 % n'est interprétable** entre deux variantes.
- **Ne pas publier avant d'avoir fini de lire ce qui est déjà sur le disque** (critique du 06/09).

---

## Comment tenir ce fichier

- Il se met à jour **pendant** le travail, pas à la fin : une décision prise s'écrit en section 1
  dans la foulée, une mesure lancée s'écrit en section 2 avant de quitter le clavier.
- Il reste **court** — une page. Ce qui déborde part dans `memory/` et n'est plus qu'un lien d'ici.
- Il ne contient **aucun chiffre qui ne vienne pas de `mesure.py`**.
- Il n'est à jour que **s'il est poussé** : `./sauver.sh "ce qui a changé"`.
