# Chiffrement et signature des fichiers imprimeur

## Concept

Un service en ligne chiffré, authentifié et tracé, fournit par le canton de Genève permet:
- au canton d'envoyer les fichiers d'impression des cartes de vote électronique à l'imprimeur;
- à l'imprimeur d'envoyer les bons à tirer au canton.

Etant donné la criticité de ces fichiers qui contiennent les codes d'initialisation, de vérification et de confirmation
pour le vote électronique, il est cependant nécessaire d'assurer à ces fichiers leur intégrité, leur authenticité et leur 
confidentialité indépendamment du canal de communication.

Pour cela, ils sont signés avec le certificat de l'émetteur et chiffrés en mode authentifié avec le certificat public du destinataire (principe sign-then-AEAD).

Au niveau de l'implémentation, nous utilisons OpenSSL avec le standard CMS (Cryptographic Message Syntax):

- Signature du message à l'aide de l'algorithme `RSA-PSS` avec une clé privée de 3072 bits et l'algorithme de hash `SHA256`.
- Chiffrement authentifié du message signé à l'aide de `AES-256-GCM`, la clé symétrique générée étant wrappée par la clé publique du destinataire en utilisant `AES-256-wrap`.

## Structure du repository

Le répertoire de base `chiffrement-signature` contient des scripts permettant l'exécution des différentes étapes de
préparation et de transmission avec des valeurs de paramètre pré-déterminés.

Le répertoire `bin` contient les scripts OpenSSL de base permettant d'exécuter les différentes actions à l'aide de
paramètres.

Le répertoire `certs` est destiné à contenir les certificats du canton et ceux de l'imprimeur.

Le répertoire `data` contient des fichiers de test.

## Prérequis

### OpenSSL

Le logiciel OpenSSL doit être installé et disponible dans le PATH. Il faut utiliser une version récente supportant `AES-256-GCM`. Pour vérifier, exécuter `openssl list -cipher-algorithms` et rechercher si `AES-256-GCM` apparaît dans les résultats.

### Certificat de signature du canton

Les fichiers suivants sont fournis au canton selon un processus de gré à gré par la Poste Suisse:

- Un keystore PKCS#12 qui va permettre la signature du fichier pour l'imprimeur
- Un fichier contenant le mot de passe de protection du keystore
- Un certificat public self-signed permettant de contrôler la signature à transmettre à l'imprimeur

Ces fichiers doivent être déposés dans le répertoire `certs`.

## Préparation des certificats de signature et de chiffrement

En plus du certificat de signature du canton, 3 autres certificats doivent être générés:

- Un certificat permettant à la Chancellerie de chiffrer les fichiers à destination de l'imprimeur.
- Un certificat permettant à l'imprimeur de signer les fichiers qu'il envoie à la Chancellerie.
- Un certificat permettant à l'imprimeur de chiffrer les fichiers à destination de la Chancellerie.

Ces certificats sont créés à l'aide des deux scripts:

- `01-generer-certificat-GE.ps1`
- `02-generer-certificats-Imprimeur.ps1`

Enfin, les empreintes des certificats sont obtenus à l'aide du script suivant:

- `03-lister-empreintes-certificats.ps1`

## Envoi d'un fichier à l'imprimeur

La commande suivante permet au canton de signer et chiffrer un fichier à envoyer à l'imprimeur:

`04-envoi-GE-Imprimeur.ps1 <chemin vers le fichier à envoyer>`

## Réception du fichier par l'imprimeur

La commande suivante permet à l'imprimeur de déchiffrer le fichier reçu et de vérifier sa signature:

`05-reception-Imprimeur.ps1 <chemin vers le fichier reçu>`

## Envoi d'un fichier au canton

La commande suivante permet à l'imprimeur de signer et chiffrer un fichier à envoyer au canton:

`06-envoi-Imprimeur-GE.ps1 <chemin vers le fichier à envoyer>`

## Réception du fichier par le canton

La commande suivante permet au canton de déchiffrer le fichier reçu et de vérifier sa signature:

`07-reception-GE.ps1 <chemin vers le fichier reçu>`