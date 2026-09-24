# Outils de contrôle — A, B, C et les cinq ajouts

Définition de Denis, 24/09/2026 (ne pas la réinterpréter) :

- **A. Contrôle de l'exécution des trades**, avec tableau de bord : surtout **latence** et **spread**.
- **B. Reporting de la performance** : trades en cours, creux (DD) courant, performances, creux maximal.
- **C. Surveillance de la bonne exécution du VPS** : graphiques, **bons EA et bons sets chargés**.

Ajouts validés le 24/09 : (1) exposition par symbole et par sens avec alerte d'empilement,
(2) écart réel contre test par robot, (3) glissement par trade, (4) marge et coupures broker,
(5) coût des swaps.

## Les pièces

| Fichier | Rôle |
|---|---|
| `GT_Controle.mq5` | L'espion, posé sur **un** graphique de chaque terminal MT5. **Lecture seule** : aucun appel de trading dans le fichier. |
| `GT_Controle.mq4` | Le même espion pour MT4 (compte cent Ultima). Mêmes fichiers. En MT4, pas de délai serveur, et le glissement n'est mesuré que sur stop ou objectif touché. |
| `tableau.py` | Lit les fichiers de l'espion, écrit `tableau.html` (se rafraîchit seul chaque minute) et `resume.json`. |
| `attendu.csv` | Ce qui DOIT être chargé : compte (vide = tous), symbole, période, robot, `.set` de référence, magic, nom. |
| `sets/` | Les `.set` de référence cités par `attendu.csv`. |
| `references_test.csv` | Chiffres du test par robot (magic) pour l'écart réel/test. **Uniquement des chiffres de `mesure.py`/`parjeu.py`, avec leur source.** |
| `seuils.csv` | Les seuils d'alerte. |

## Ce que l'espion écrit

Dans `%APPDATA%\MetaQuotes\Terminal\Common\Files\GT_Controle\<compte>\` :

- `etat.json` (toutes les 5 s) : compte, marge, ping, connexion, bouton Algo Trading, positions
  avec **perte si le stop est touché**, spreads, graphiques ouverts avec robot et réglages ;
- `equite.csv` (chaque minute) : solde, équité, marge, ping — base du creux vécu ;
- `spreads.csv` (chaque minute) : spread min / moyen / max par symbole ;
- `executions.csv` (à chaque exécution) : prix demandé, prix obtenu, **glissement** en points et
  en argent, **délai serveur** en ms, spread et ping au moment de l'exécution ;
- `historique.csv` (toutes les 15 min) : toutes les transactions, avec swaps et commissions ;
- `coupures.csv` : chaque perte de connexion au courtier, début, fin, durée.

Les réglages d'un robot sont lus en sauvegardant un modèle du graphique (fichier écrit puis
effacé) : rien n'est changé sur le graphique.

## Limites connues, à ne pas oublier

- Le **creux sur l'équité** ne commence qu'au premier relevé de l'espion. Avant, seul le creux
  sur trades fermés (reconstruit depuis l'historique) existe, et il sous-estime le vrai creux.
- Le **glissement d'une entrée au marché** n'est mesurable que si le robot envoie un prix dans sa
  demande. Sinon la case reste vide : rien n'est inventé.
- Le **délai serveur** est le temps entre la pose de l'ordre et son exécution chez le courtier ;
  la latence réseau est le **ping**. Les deux ensemble font la latence d'exécution.
- L'écart réel/test n'est jugé qu'à partir de 20 trades fermés (réglable).
