# hollybike

## Base de donnée

### Changelog
Pour générer le changelog liquibase entre la base de production et votre base locale, vous devez lancer le script Gradle `diffChangelog`.

Pour le lancer, le script nécessite des paramètres passés par variables d'environnements.

| Nom             | Valeur                   |
|-----------------|--------------------------|
| DB_URL          | url base de prod         |
| DB_USER         | user base de prod        |
| DB_PASSWORD=    | mot de passe base prod   |
| REF_DB_URL      | url base locale          |
| REF_DB_USER     | user base locale         |
| REF_DB_PASSWORD | mot de passe base locale |

### Lancer la migration
La migration de la base de données est faites automatiquement au lancement du backend.