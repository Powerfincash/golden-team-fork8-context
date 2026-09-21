---
name: regle-entree-tradingview-powerfin
description: Sa regle d'entree manuelle sur TradingView (mise en page Powerfin, XAUUSD M1) : confluence de quatre indicateurs pour vendre ou acheter, enoncee le 04/09/2026
metadata:
  type: project
---

Regle d'entree qu'il m'a donnee le 04/09/2026 sur sa mise en page TradingView « Powerfin » (XAUUSD, 1 minute, OANDA). Indicateurs charges apres sa simplification du 04/09 (17h48) : Protected Highs & Lows [TFO], LuxAlgo Signals & Overlays (preset None, Confirmation + Exits, sensibilite 10, sans nuages), Dynamic Reactor [CHE] (ruban vert/rouge), AsiaSessionHighLowMidLines 18h-02h, et le TPI en panneau bas. Liquidity Reaper [JOAT] retire le 04/09.

**Vente** quand les quatre sont reunis : signal LuxAlgo vers le bas + petit triangle rouge-brun + Protected Highs & Lows en rouge-brun + « TPI » rouge. (Le triangle appartient a Protected Highs & Lows : quand il a remplace l orange par le rouge-brun le 04/09, le triangle a suivi ; il n y a plus de triangle orange.)
**Achat** quand les quatre sont reunis : signal LuxAlgo vers le haut + petit triangle violet + Protected Highs & Lows en mauve + « TPI » vert.

**Stop loss** : pour un sell, sur la ligne rouge-brun de Protected Highs & Lows (le plus haut protege) ; pour un buy, sur la ligne violette (le plus bas protege). Regle donnee le 04/09 17h56.
**Gestion** (REVISEE le 05/09/2026, apres son « cloture partielle OUI ») : a 1 R de gain, **la moitie de la position est fermee, le stop initial ne bouge pas**, le reste va a 2 R ou au stop. Resultats possibles : -1 R, 0 R, +1,5 R. Remplace la regle du 04/09 18h00 (stop a l entree a 1 R, fermeture a 2 R), gardee dans le menu de la strategie comme variante de comparaison. Voir [[cloture-partielle-neutre]].
**Journee** (regles du 05/09, tirees d un plan SMC H1/M5/M1 qu il m a soumis pour avis) : entrees seulement en session Londres 09-12 et New York 14-18 UTC+2 (fenetres mesurees de [[reperes-m15-puprime]]) ; au plus 3 entrees par jour ; plus d entree quand le jour est a -2 % du capital de debut de journee. Position ouverte hors session ou apres l arret : laissee courir (hypothese).
**Sortie** : on ferme aussi un ordre sell a la croix (X) rouge-brun, et un ordre buy a la croix violette (regle donnee le 04/09 17h53). Ordre de priorite entre la croix et le 2 R non precise : je suppose « le premier des deux ». Les croix ont les couleurs de Protected Highs & Lows, donc viennent vraisemblablement de cet indicateur.

**Filtre news** (04/09 18h13) : pas de trade de 30 min avant a 30 min apres une publication a fort impact. Position deja ouverte : non precise.
**Biais H1** (04/09 18h20, precise 18h35) : le trade se prend dans le sens de la couleur de Protected Highs & Lows en H1 (mauve = achat, rouge-brun = vente).
**Unite de temps retenue pour la mesure : M5** (decide le 04/09 18h10, a cause des 10 000 barres du plan Essential).
**Tracés lisibles par une strategie Pine** (releve du 04/09) : LuxAlgo expose Bullish, Bullish+, Bearish, Bearish+, Bullish Exit, Bearish Exit, Trend Tracer, Trend Catcher, Smart Trail, Neo Lead/Lag (le chiffre 1-4 n est PAS un trace, seulement Bullish vs Bullish+) ; Protected H&L expose un seul « Plot » (le niveau protege, ex. 4 510,93), ses boites/lignes/croix sont des objets graphiques non lisibles, mais le script est open source (MPL, auteur tradeforopp) ; TPI expose « Trend Strength » et « Middle ».
**Ce que le code source de Protected H&L (copie : `forex/outils/ProtectedHighsLows_TFO_source.pine`) apprend** : le triangle (label ▼/▲) est pose sur le plus haut/bas protege au moment de la cassure ; la ligne (plot « trail ») vaut ce meme niveau (track_high apres cassure baissiere, track_low apres cassure haussiere) ; bloc, triangle et ligne decoulent tous du meme etat `bull` (false = rouge-brun, true = mauve). Le script ne dessine AUCUNE croix : les croix sont les sorties LuxAlgo (plots « Bearish Exit » / « Bullish Exit », forme X, position Absolute). Donc TOUT est lisible par une strategie Pine.
**Strategie Pine** : `forex/outils/Powerfin_M5_v1_2.pine` (v1.2 du 05/09, jamais compilee : attendre son retour d erreur). v1.2 = partielle 50 % a 1 R, menu de gestion a trois positions (partielle / stop a l entree / aucune), sessions, 3 entrees/jour, arret -2 %/jour, compteurs « 1 R touche » et « 2 R touche » compares a 50 % et 36,7 %. v1.1 (04/09, stop a l entree) conservee ; v1.0 lisait le TPI en H1, abandonnee. Hypotheses v1.1 : biais H1 = etat Protected H&L calcule par la fonction phlState() en H1 via request.security sur la derniere barre H1 cloturee ; news = liste manuelle dans un input texte ; position ouverte pendant news laissee courir ; signal oppose ignore en position.
**Simulation** : risque 1 % du capital par trade. **Journal** des evenements conformes au scenario : `OneDrive/Documents/forex/outils/JOURNAL-POWERFIN.md` (ouvert le 04/09/2026, premier evenement = sell 11h15). Il veut un historique note evenement par evenement, pas une opinion.

**TradingView** : abonnement Essential (18,09 EUR/mois, vu le 04/09/2026) : 10 000 barres d historique et 5 indicateurs par graphique ; une strategie Pine compte comme un indicateur, donc en retirer un pour la charger. 10 000 barres M1 = ~7 jours d or, M5 = ~5 semaines, M15 = ~3,5 mois.

« TPI » : le panneau du bas, oscillateur autour de zero (vert au-dessus = achat, rouge en dessous = vente), legende « TPI », vraisemblablement l etude GRUMLOP Trend strength. Ne pas confondre avec les etiquettes TP1/TP2/TP3 du Liquidity Reaper.

Le chiffre dans l'etiquette LuxAlgo (1 a 4) est la force du signal par confluence.

**Why:** c'est sa regle manuelle telle qu'il la pratique ; elle n'est pas derivable du code. Elle croise quatre indicateurs, dont LuxAlgo deja mesure (voir [[luxalgo-mesure]] : filtrer degradait).
**How to apply:** lire le graphique selon cette grille quand il me demande « tu vois les signaux ? » ; ne pas la reinterpreter. Si un jour il veut la mesurer, appliquer [[backtest-acceptance-criteria]] et [[backtest-refute-ne-confirme-pas]].
