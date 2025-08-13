docker run -d --name c1 --mount type=bind,source=/home/rivoinfo/Documents/test,destination=/usr/share/nginx/html nginx:latest

docker run -d --name c1 -v /home/rivoinfo/Documents/test/:/data/ myimage:v1.0 spleed infinity

docker network create --type=driver,subnet=192.168.50.0/30 mynet


DOCKERFILE CONFIG

events {} → Nginx a besoin que ça soit là, même vide, pour démarrer.

http { ... } → Tout ce qui est dedans sert à gérer le protocole web (HTTP).

server { ... } → Les règles pour un serveur web (un site).

listen 80; → On ouvre la porte 80 (le port classique du web).

server_name _; → On accepte les requêtes venant de n’importe quel nom de domaine ou IP.

root /usr/share/nginx/html; → C’est là que Nginx va chercher les fichiers à envoyer aux visiteurs.

index index.html; → Si quelqu’un visite /, on lui envoie index.html.

location / { ... } → Les règles pour tout ce qui est demandé à /.

try_files $uri /index.html; → Si le fichier demandé n’existe pas, on envoie index.html (utile pour les applications React/Vue).