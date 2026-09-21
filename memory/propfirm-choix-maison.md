---
name: propfirm-choix-maison
description: Son choix du 06/09 — Axi Select et Darwinex Zero en priorité ; sur les maisons à challenge classique le vrai danger est le refus de paiement pour stratégie partagée, pas le creux
metadata:
  type: project
---

**Sa décision du 06/09/2026 :** *« mieux Axi Select et Darwinex, même si son spread sur l'or est
élevé »*. Détail complet et chiffres : `forex/outils/PARAMETRES-PROPFIRM.md`, section 8.

**Le danger des maisons à challenge classique n'est pas le creux, c'est le REFUS DE PAIEMENT.**
FundedNext exige une stratégie *distincte* sans transactions identiques entre comptes ; les maisons
comparent les horodatages d'entrée sur toute leur base avec des fenêtres de 1 à 5 secondes. Un
best-seller utilisé aux réglages d'usine par des milliers d'acheteurs devient une « stratégie
partagée ». Cas documenté : 200 000 $ perdus pour ce motif, pas pour un dépassement. **Gold Reaper est
vendu avec l'argument « PROP FIRM READY » et compte 105 avis** — notre exposition est réelle.

**Darwinex Zero et Axi Select n'ont pas cette clause** : robots autorisés sans restriction, pas de
jours minimum, pas d'interdiction du week-end. Ce sont des programmes d'ALLOCATION sur score, pas des
challenges à élimination, et leur notation récompense le creux maîtrisé — exactement notre profil
(5 mois négatifs sur 48, pire à −2,7 %, rapport 9,6). Il a déjà un compte démo Darwinex dans son MT4.

**Deux points techniques à retenir** : (1) Darwinex **normalise le risque** avant d'allouer, donc le
dimensionnement ×15 vaut pour une maison à seuil, pas là-bas — le profil compte, pas la taille des
lots ; (2) **sa réserve : l'écart sur l'or est élevé chez Darwinex**, à vérifier avant d'y porter la
jambe or qui est la plus grosse. Voir [[reperes-m15-puprime]].

## Axi Select : pas de risque de strategie partagee, confirme 07/09/2026

L'utilisateur confirme qu'Axi Select n'a pas de probleme de "strategie partagee" (deja note dans
[[quatre-standards]] / `PARAMETRES-PROPFIRM.md` section 8 : programme d'allocation, aucune clause sur
les transactions identiques entre utilisateurs). Consequence directe : la reserve qui poussait a batir
un portefeuille Zebra-seul (sans EA commercial) tombe pour cette maison precisement.

**Decision** : a 5 000 USD chez Axi Select, reintroduire UBS or + UBS hors-or a cote de Zebra. Gain
mesure : rendement corrige reel 27,1 %/an (Zebra seul) -> **46,8 %/an** (Zebra + UBS or + hors-or), a
drawdown identique (6,85 %). Voir `outils/PORTEFEUILLE-ZEBRA-AXISELECT.md` section 6.

Le Zebra-seul reste la bonne base pour toute maison a challenge classique ou le risque documente
(Gold Reaper "PROP FIRM READY", detection d'horodatages 1-5 secondes) s'applique reellement.

## CORRECTION 07/09/2026 (soir) : Axi Select interdit les EA commerciaux en algo

**Annule la section precedente.** L'utilisateur rapporte qu'Axi Select interdit l'usage de robots
commerciaux en mode algorithmique -- tolere seulement si les trades sont passes manuellement (a
confirmer contre le reglement officiel). La note du 07/09 apres-midi ("pas de risque de strategie
partagee") etait donc fausse pour l'usage vise ici (trading algo).

**Consequence directe** : chez Axi Select, en algo, seul du code MAISON peut tourner -- Zebra (or,
GBPUSD, EURUSD), jamais UBS ni Advanced Scalper tant qu'ils ne sont pas clones en code propre. Retour
au scenario A (Zebra seul) de `outils/PORTEFEUILLE-ZEBRA-AXISELECT.md`, le scenario C (avec UBS) n'est
plus la configuration recommandee pour cette maison.

**A verifier** : le statut de Darwinex Zero n'a pas ete revise -- la question se pose potentiellement
aussi la-bas, a confirmer separement avant de s'y fier pour du trading algorithmique de robots tiers.
