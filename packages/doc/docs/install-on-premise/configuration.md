---
sidebar_position: 3
---

# Configuration

HollyBike supporte 2 mode de configuration: 
- Via variable d'environnement
- Via fichier de configuration


## Environnement

En fonction de votre système, vous pouvez configurer de différentes manières vos variables d'environnements HollyBike.  
[Windows](https://learn.microsoft.com/fr-fr/sql/integration-services/lesson-1-1-creating-working-folders-and-environment-variables?view=sql-server-ver16)

Certaines variables sont obligatoires afin de pouvoir lancer HollyBike sans erreur.  
En cas de problème de la part du serveur, des messages d'erreur vous décriront l'erreur. Si votre problème persiste n'hésitez pas à nous contacter.  

## Fichier de configuration

Le fichier de configuration est au format JSON, ceci permet de concentrer les variables de configuration dans un seul fichier de manière structuré.  
Ce fichier de configuration peut être mis en place à la main, ou automatiquement si aucune variable d'environnement n'est fourni à l'application au démarrage.  
Une fois lancé, vous pourrez accéder au site web de gestion de HollyBike et en cas de problème de configuration, il vous sera présenté un écran de configuration permettant de faciliter l'utilisation de ce fichier de configuration.  
Une fois le serveur démarré, vous pouvez toujours accéder à la configuration via le site web de gestion de HollyBike.  

:::note

Le fichier de configuration s'appelle `app.json` et doit être dans le même dossier que le serveur HollyBike

:::

:::info

Le site web de gestion de HollyBike est disponible par défaut à l'adresse [localhost:8080](http://localhost:8080) sur la machine sur laquelle se trouve le serveur

:::

## Variable de configuration

| Nom en mode fichier            | Nom en mode environnement         | Description                                     | Obligatoire | Information supplémentaire                                                      |
|--------------------------------|-----------------------------------|-------------------------------------------------|-------------|---------------------------------------------------------------------------------|
| db.url                         | DB_URL                            | URL de la base de données                       | Oui         |                                                                                 |
| db.username                    | DB_USERNAME                       | Nom d'utilisateur de la base de données         | Oui         |                                                                                 |
| db.password                    | DB_PASSWORD                       | Mot de passe de la base de données              | Oui         |                                                                                 |
| security.audience              | SECURITY_AUDIENCE                 | Audience de l'application                       | Oui         | Valeur recommandé : "hollybike.fr"                                              |
| security.domain                | SECURITY_DOMAIN                   | Nom de domaine publique de l'application        | Oui         | Valeur utilisé pour les appel externe                                           |
| security.realm                 | SECURITY_REALM                    | Domaine d'utilisation de l'application          | Oui         | Valeur recommandé : "realm"                                                     |
| security.secret                | SECURITY_SECRET                   | Secret de l'application                         | Oui         | Utilisé pour toute la sécurité. De préférence une suite de caractères aléatoire |
| security.cfPrivateKeySecret    | SECURITY_CF_PRIVATE_KEY_SECRET    | Clé de signature des fichier de l'application   | Non         |                                                                                 |
| security.cfKeyPairId           | SECURITY_CF_KEY_PAIR_ID           | ID de la pair de clé de  l'application          | Non         |                                                                                 |
| mapBox.publicAccessTokenSecret | MAPBOX_PUBLIC_ACCESS_TOKEN_SECRET | Clé publique map box                            | Oui         | Affichage des cartes dans l'application                                         |
| storage.s3Url                  | STORAGE_S3_URL                    | URL du S3 (ou compatible) de stockage           | Oui         | S3: Un et seulement un mode de stockage est nécessaire                          |
| storage.s3BucketName           | STORAGE_S3_BUCKET_NAME            | Nom du bucket du S3 (ou compatible) de stockage | Oui         | S3: Un et seulement un mode de stockage est nécessaire                          |
| storage.s3Region               | STORAGE_S3_REGION                 | Region du S3 (ou compatible) de stockage        | Oui         | S3: Un et seulement un mode de stockage est nécessaire                          |
| storage.s3Username             | STORAGE_S3_USERNAME               | Identifiant du S3 (ou compatible) de stockage   | Oui         | S3: Un et seulement un mode de stockage est nécessaire                          |
| storage.s3password             | STORAGE_S3_PASSWORD               | Mot de passe du S3 (ou compatible) de stockage  | Oui         | S3: Un et seulement un mode de stockage est nécessaire                          |
| storage.localPath              | STORAGE_LOCAL_PATH                | Chemin de stockage local                        | Oui         | LOCAL: Un et seulement un mode de stockage est nécessaire                       |
| storage.ftpServer              | STORAGE_FTP_SERVER                | URL du FTP de stockage                          | Oui         | FTP: Un et seulement un mode de stockage est nécessaire                         |
| storage.ftpServer              | STORAGE_FTP_USERNAME              | Nom d'utilisateur du FTP de stockage            | Oui         | FTP: Un et seulement un mode de stockage est nécessaire                         |
| storage.ftpServer              | STORAGE_FTP_PASSWORD              | Mot de passe du FTP de stockage                 | Oui         | FTP: Un et seulement un mode de stockage est nécessaire                         |
| storage.ftpServer              | STORAGE_FTP_DIRECTORY             | Dossier distant du FTP de stockage              | Oui         | FTP: Un et seulement un mode de stockage est nécessaire                         |
| smtp.url                       | SMTP_URL                          | URL du serveur SMTP                             | Non         |                                                                                 |
| smtp.port                      | SMTP_PORT                         | PORT du serveur SMTP                            | Non         |                                                                                 |
| smtp.sender                    | SMTP_SENDER                       | Mail d'envoie du serveur SMTP                   | Non         |                                                                                 |
| smtp.username                  | SMTP_USERNAME                     | Nom d'utilisateur du serveur SMTP               | Non         |                                                                                 |
| smtp.password                  | SMTP_PASSWORD                     | Mot de passe du serveur SMTP                    | Non         |                                                                                 |