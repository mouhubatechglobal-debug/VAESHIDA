# VAESHIDA — RÈGLES DE DÉVELOPPEMENT IA

## 1. Rôle de l'IA

L'IA agit comme assistant technique du projet.

Le directeur du projet reste l'utilisateur.

L'IA doit :
- analyser avant de modifier ;
- respecter l'architecture existante ;
- expliquer les changements importants ;
- éviter les modifications inutiles ;
- tester son travail lorsque cela est possible ;
- signaler clairement les problèmes.

## 2. Règle fondamentale

NE PAS réécrire tout le projet lorsqu'une petite correction suffit.

Avant toute modification :
1. comprendre le code existant ;
2. identifier les dépendances ;
3. identifier les risques ;
4. modifier uniquement ce qui est nécessaire ;
5. vérifier le résultat.

## 3. Luau / Roblox

Le langage utilisé pour les scripts Roblox est Luau.

Le code doit privilégier :
- la lisibilité ;
- la modularité ;
- la sécurité serveur ;
- la réutilisation ;
- les performances ;
- la séparation Client / Serveur / Shared.

## 4. Sécurité

Le client ne doit jamais être considéré comme fiable.

Les décisions importantes doivent être validées côté serveur.

Exemples :
- dégâts ;
- récompenses ;
- monnaie ;
- XP ;
- inventaire ;
- progression ;
- achats ;
- permissions.

## 5. Architecture

Respecter :

src/luau/client
src/luau/server
src/luau/shared

Ne pas mélanger arbitrairement les responsabilités.

## 6. Tests

Une fonctionnalité n'est pas considérée comme terminée simplement parce que le code ne présente pas d'erreur évidente.

Elle doit être testée.

Cycle :

ANALYSER
→ CODER
→ TESTER
→ CORRIGER
→ RETESTER
→ DOCUMENTer

## 7. Git

Faire des commits logiques.

Exemple :

feat: système de combat initial

fix: correction validation dégâts

docs: mise à jour architecture

refactor: séparation combat client serveur

## 8. Interdictions

Ne pas :
- supprimer une fonctionnalité existante sans autorisation ;
- remplacer une architecture entière sans justification ;
- ajouter des dépendances inutiles ;
- exposer des secrets ;
- faire confiance aux données envoyées par le client ;
- déclarer une fonctionnalité terminée sans test.

## 9. Philosophie VAESHIDA

Construire petit.

Tester.

Comprendre.

Améliorer.

Puis seulement passer au système suivant.
