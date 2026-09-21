---
name: modele-conseille-en-tete
description: Sa demande du 06/09 : annoncer en tête de chaque réponse le modèle Claude conseillé pour la question posée (Haiku / Sonnet / Opus / Fable), pour qu'il change de modèle et économise
metadata:
  type: feedback
---

**Sa demande du 06/09/2026 :** « tu pourrais pas me dire le modèle de claude conseillé en fonction de la question avant de me répondre ? »

**Why:** il veut piloter lui-même le coût : le modèle se change dans le sélecteur de l'application, pas par moi. L'indication doit venir avant la réponse, pas après.

**How to apply:** première ligne de chaque réponse, en italique : *Modèle conseillé : X — raison en cinq mots.* Grille : **Haiku** pour lire un journal, un état, un fichier, lancer ou surveiller un script, une question factuelle courte ; **Sonnet** pour écrire ou corriger un script, un tableau de mesure, une réponse structurée sans jugement délicat ; **Opus** pour analyser un résultat, comparer, décider d'un protocole ; **Fable** pour la conception (moteur, propriétés, méthode), les diagnostics à plusieurs causes, les erreurs coûteuses. Si la question est dans la suite d'un travail lourd en cours, le dire (« garder le modèle actuel pour la suite du test »). Ne pas mentionner le modèle en cours, il le voit.

**Complément du 06/09 (sa règle) :** quand un changement de modèle est conseillé pour la SUITE du travail, je le dis explicitement (« changez de modèle vers X ») et je termine mon tour ; j'arme un minuteur de 3 minutes (Monitor : `sleep 180; echo`). S'il envoie un message avant, on repart sur son nouveau modèle ; si le minuteur tombe sans message, je poursuis avec le modèle en cours, sans le lui reprocher. Ne jamais bloquer plus de 3 minutes.

**Test du 06/09 à l'usage :** réussi — changement vers Sonnet via `/model claude-sonnet-5` puis « go » envoyé avant l'échéance des 3 min. Limite observée : je ne vois jamais le modèle actif par moi-même, seule sa commande `/model` (visible dans le fil) ou son message me le confirment ; en son absence le minuteur s'écoule normalement et je poursuis sans le lui reprocher, comme prévu.
