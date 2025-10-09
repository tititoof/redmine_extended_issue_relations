# Redmine Extended Issue Relations

Ce plugin surcharge l'autocomplétion des demandes liées afin d'afficher le projet et permet de rechercher par nom de projet.

## Installation

1. Copier le dossier `redmine_extended_issue_relations` dans `plugins/`.
2. Relancer Redmine :
   ```bash
   bundle exec rake redmine:plugins RAILS_ENV=production
   touch tmp/restart.txt   # si Passenger
   ```
3. Aller sur une issue et tester l’ajout d’une relation.

## Exemple d’affichage

```
[Projet A] Bug #12: Erreur 500
[Projet B] Tâche #45: Migration de la base
```

## Fonctionnalités

- Recherche par **ID** d’issue
- Recherche par **sujet**
- Recherche par **nom de projet**
- Compatible PostgreSQL et MySQL/MariaDB
