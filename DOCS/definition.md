1. Installation de Docker
Définition : Docker est une plateforme permettant de conteneuriser des applications, c'est-à-dire de les exécuter dans des environnements isolés appelés conteneurs. L'installation configure Docker sur votre système pour créer, gérer et exécuter ces conteneurs.
Commandes d'installation (sur Ubuntu/Debian) :
# Mettre à jour les paquets
sudo apt-get update

# Installer les dépendances nécessaires
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Ajouter la clé GPG officielle de Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Ajouter le dépôt Docker
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Mettre à jour les paquets et installer Docker
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Vérifier que Docker est installé et fonctionne

sudo systemctl start docker
sudo systemctl enable docker
docker --version

Explication : Ces commandes téléchargent et installent Docker Community Edition (CE), activent le service Docker au démarrage, et vérifient la version installée.
Pour ajouter l'utilisateur courant au groupe Docker (éviter d'utiliser sudo pour chaque commande) :

sudo usermod -aG docker $USER

Déconnectez-vous et reconnectez-vous pour appliquer les changements.

2. Commandes de base pour gérer Docker
Voici les commandes essentielles pour travailler avec Docker, regroupées par catégorie avec leur définition et usage.

a) Gestion des images
Définition : Une image Docker est un modèle en lecture seule utilisé pour créer des conteneurs. Elle contient l'application, ses dépendances et les instructions pour l'exécuter.

Télécharger une image depuis Docker Hub :

docker pull <image>:<tag>

Exemple : docker pull nginx:latest (télécharge l'image Nginx, dernière version).
Lister les images disponibles localement :

docker images

Affiche les images téléchargées avec leur nom, tag, ID et taille.
Supprimer une image :

docker rmi <image_id>

Exemple : docker rmi nginx (supprime l'image Nginx).
Construire une image à partir d’un Dockerfile :

docker build -t <nom_image>:<tag> .

Exemple : docker build -t mon_app:1.0 . (construit une image à partir du Dockerfile dans le répertoire courant).

b) Gestion des conteneurs
Définition : Un conteneur est une instance exécutable d’une image, isolée du système hôte.


Lancer un conteneur :

docker run [options] <image>:<tag>

Exemple : docker run -d -p 8080:80 nginx (lance un conteneur Nginx en arrière-plan, mappe le port 8080 de l’hôte au port 80 du conteneur).
Options courantes :

-d : Exécute en mode détaché (arrière-plan).
-p <hôte>:<conteneur> : Mappe un port de l’hôte à un port du conteneur.
--name <nom> : Nomme le conteneur.
-v <hôte>:<conteneur> : Monte un volume pour partager des données.



Lister les conteneurs :

docker ps

Affiche les conteneurs en cours d’exécution. Ajoutez -a pour voir tous les conteneurs, y compris ceux arrêtés : docker ps -a.


Arrêter un conteneur :

docker stop <conteneur_id>

Exemple : docker stop 1a2b3c (arrête le conteneur avec l’ID 1a2b3c).


Redémarrer un conteneur :

docker start <conteneur_id>


Supprimer un conteneur :

docker rm <conteneur_id>

Remarque : Le conteneur doit être arrêté avant suppression.


Exécuter une commande dans un conteneur en cours :

docker exec -it <conteneur_id> <commande>

Exemple : docker exec -it 1a2b3c  (ouvre un terminal interactif dans le conteneur).


c) Gestion des volumes
Définition : Les volumes permettent de persister les données générées par un conteneur, même après sa suppression.

Créer un volume :

docker volume create <nom_volume>

Lister les volumes :

docker volume ls

Supprimer un volume :

docker volume rm <nom_volume>

Monter un volume dans un conteneur :

docker run -v <nom_volume>:<chemin_conteneur> <image>

Exemple : docker run -v mon_volume:/data mysql (monte le volume mon_volume dans /data du conteneur).

d) Gestion des réseaux
Définition : Les réseaux Docker permettent aux conteneurs de communiquer entre eux ou avec l’hôte.

Lister les réseaux :

docker network ls

Créer un réseau :

docker network create <nom_reseau>

Connecter un conteneur à un réseau :

docker network connect <nom_reseau> <conteneur_id>

Lancer un conteneur sur un réseau spécifique :

docker run --network <nom_reseau> <image>


e) Commandes utilitaires

Vérifier les informations système de Docker :
docker info
Affiche des détails sur l’installation Docker (nombre de conteneurs, images, etc.).
Nettoyer les ressources inutilisées :
docker system prune
Supprime les conteneurs arrêtés, les réseaux inutilisés et les images non utilisées.
Afficher les logs d’un conteneur :
docker logs <conteneur_id>

Inspecter un conteneur ou une image :
docker inspect <conteneur_id | image_id>
Fournit des détails techniques (configuration, réseau, etc.).


3. Exemple pratique
Pour illustrer, voici comment lancer un conteneur Nginx avec un volume et un port mappé :
# Télécharger l’image Nginx
docker pull nginx:latest

# Créer un volume

docker volume create mon_volume

# Lancer le conteneur

docker run -d --name mon_nginx -p 8080:80 -v mon_volume:/usr/share/nginx/html nginx
Résultat : Un serveur Nginx tourne sur http://localhost:8080, avec un volume persistant pour les fichiers HTML.

4. Commandes avancées (optionnel)

Gérer plusieurs conteneurs avec Docker Compose :

docker-compose up -d

Lance tous les services définis dans un fichier docker-compose.yml.
Tagger une image :

docker tag <image_source>:<tag> <image_cible>:<tag>

Exemple : docker tag mon_app:1.0 mon_app:latest.
Pousser une image vers Docker Hub :

docker push <nom_utilisateur>/<image>:<tag>