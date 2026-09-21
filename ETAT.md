# État de reprise

> **Ce fichier est le premier à lire, et le seul qui fait foi sur « où on en est ».**
> Les autres fichiers du dépôt sont des archives : ils disent ce qui a été mesuré,
> pas ce qui est vivant. Un chiffre dans une archive sans date est un chiffre périmé.

**À jour au : 21/09/2026**
**Dernier geste : audit fork 8 des chaînes MT4 du 20-21/09, résultats Viper/R Factor corrigés.**

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
- **R Factor** : panier perdant, −603 $ sur 7 croisées (9 lancées). Non comme retour à la moyenne.
- **Le poste retour à la moyenne reste vacant** (Heron seul). Le portefeuille est 100 % cassure.

## 2. En cours — ce qui tourne seul

- **Rien ne tourne.** La dernière chaîne MT4 s'est arrêtée le 21/09 à 06:30:03,
  `r_EURAUD_1ordre` lancé sans ligne FIN. Chaîne non terminée.

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

## 4. Prochain geste — un seul

1. **Relancer les réserves 2025 de Sakura et Happy Pound.** Les deux passes du 21/09 ont été
   lancées mais n'ont produit aucun rapport (le log dit lui-même à 02:31 : « REFUS : aucun rapport
   après l'attente — ne rien conclure de ce passage »). Leurs verdicts d'origine PASS et *validé*
   n'ont jamais été revus alors que leur facteur de profit est 1,08 et leurs creux 42,2 % et 48,8 %.
2. Puis : **corriger le symbole AUDUSD** — 4 blocs à 0 trade, c'est le seul test lancé sur le
   symbole nu alors que tous les autres tournent sur les suffixes `.s`.
3. Puis : `parjeu.py` sur n121 et n132, pour les corrélations contre la jambe or privée.

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
