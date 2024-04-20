# HollyBike

## Frontend

Frontend de l'application HollyBike. Développé avec Preact. <br>

Le frontend utilise `Bun` et `Vite` pour le développement.

### Installation des dépendances

```shell
bun i
```

### Lancer le frontend pour le développement

Pour lancer le frontend en mode développement (avec vite).

```shell
bun run dev
```

## Backend

Backend de l'application HollyBike. Développé en kotlin avec le framework Ktor. <br>

Le backend est compilé avec GraalVM pour être exécuté en tant que binaire natif.

### Lancer le backend

Pour lancer le backend, vous pouvez utiliser le script Gradle `run`.
Pour changes les variables d'environnements, vous pouvez mettre à jour le fichier `app.json` à la racine du projet.

```shell
./gradlew run
```

### Compiler le backend

#### Prérequis

Pour compiler le backend en tant que binaire natif, vous devez avoir GraalVM installé sur votre machine. <br>

Vous devez également avoir un JDK 21 installé sur votre machine.

#### Compilation

Pour compiler le backend, vous pouvez utiliser le script Gradle `nativeCompile`.

```shell
./gradlew nativeCompile
```

#### Lancer le binaire natif

Pour lancer le binaire natif, vous pouvez utiliser le binaire généré dans le dossier `build/native/nativeCompile`.

```shell
./build/native/nativeCompile/hollybike_server
```

### Lancement de l'agent GraalVM

Pour lancer l'agent GraalVM, vous pouvez utiliser l'option -Pagent sur les tests par exemple.

```shell
./gradlew -Pagent test
```

Pour copier les métadatas générées par l'agent, vous pouvez utiliser la tâche `metadataCopy`.

```shell
./gradlew metadataCopy
```

## Base de donnée

Base de donnée utilisée : PostgreSQL

### Docker

Pour lancer une base de donnée PostgreSQL en local, vous pouvez utiliser le docker-compose fourni.

```shell
docker-compose up -d
```

### Changelog

Pour générer le changelog liquibase entre la base de production et votre base locale, vous devez lancer le script
Gradle `diffChangelog`.

Pour le lancer, le script nécessite des paramètres passés par variables d'environnements.

| Nom             | Valeur                   |
|-----------------|--------------------------|
| DB_URL          | url base de prod         |
| DB_USER         | user base de prod        |
| DB_PASSWORD     | mot de passe base prod   |
| REF_DB_URL      | url base locale          |
| REF_DB_USER     | user base locale         |
| REF_DB_PASSWORD | mot de passe base locale |

### Lancer la migration

La migration de la base de données est faites automatiquement au lancement du backend.

## Infrastructure

L'infrastructure est gérée avec Terraform.

Pour définir les variables Terraform, créer un fichier `terraform.tfvars` à la racine du
dossier `packages/infrastructure/project`.

Le projet nécessite les credentials configurés AWS pour fonctionner.

### Schéma

![image](images/terraform.png)

### Appliquer les changements

Pour appliquer les changements Terraform, il est recommandé de laisser la CI/CI s'en charger.

## Application Flutter

L'application mobile est développée en Flutter.

### Installation des dépendances

```shell
flutter pub get
```

### Lancer l'application

Utiliser les outils fournis par Android Studio.

## CI/CD

### Pull Request

À la création d'une PR, un pipeline est déclenché pour vérifier la qualité du code.

Un filtre est appliquer pour ne lancer la pipeline que sur les packages concernés par les changements.

### Merge

À la fusion d'une PR, un pipeline est déclenché pour déployer l'infrastructure avec Terraform.

### Release

Pour créer une release et déployer le projet, il suffit de lancer le workflow Manuel `Release & Deploy` et de mettre en
paramètre le numéro de version de la release.

# Contributors

<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/MacaronFR"><img src="https://avatars.githubusercontent.com/u/60406911?v=4?s=100" width="100px;" alt="MacaronFR"/><br /><sub><b>MacaronFR</b></sub></a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/enzoSoa"><img src="https://avatars.githubusercontent.com/u/40230973?v=4?s=100" width="100px;" alt="Enzo Ayrton Soares
"/><br /><sub><b>Enzo Ayrton Soares
</b></sub></a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/Loic-Vanden-Bossche"><img src="https://avatars.githubusercontent.com/u/40357859?v=4?s=100" width="100px;" alt="Loïc Vanden Bossche
"/><br /><sub><b>Loïc Vanden Bossche
</b></sub></a></td>
    </tr>
  </tbody>
</table>