user  nginx;
worker_processes  auto;

# Logs et PID
error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;

events {
    worker_connections  1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    # Logs
    access_log  /var/log/nginx/access.log;

    # Compression Gzip
    gzip on;
    gzip_types text/plain text/css application/json application/javascript application/xml+rss application/atom+xml image/svg+xml;
    gzip_min_length 256;

    # Keepalive
    keepalive_timeout 65;

    server {
        listen 80;
        server_name _;

        root /usr/share/nginx/html;
        index index.html;

        # Sécurité de base
        add_header X-Content-Type-Options nosniff;
        add_header X-Frame-Options SAMEORIGIN;
        add_header X-XSS-Protection "1; mode=block";

        # Cache statique
        location ~* \.(?:ico|css|js|gif|jpe?g|png|woff2?|ttf|svg|eot)$ {
            expires 6M;
            access_log off;
            add_header Cache-Control "public";
        }

        # Page d’erreur personnalisée
        error_page 404 /index.html;
        location = /index.html {
            internal;
        }
    }
}


1️⃣ Configuration globale
nginx

user  nginx;
worker_processes  auto;
user nginx; → Nginx s’exécute avec l’utilisateur nginx (sécurité, pas root).

worker_processes auto; → Nginx va créer autant de “workers” qu’il y a de CPU, pour gérer plus de visiteurs.

2️⃣ Logs et PID
nginx

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;
error_log → fichier où Nginx écrit les erreurs.

pid → fichier qui garde l’identifiant du processus principal de Nginx (utile pour le contrôler, redémarrer, arrêter).

3️⃣ Events
nginx

events {
    worker_connections  1024;
}
Définit combien de visiteurs chaque worker peut gérer en même temps (ici 1024).

4️⃣ HTTP
nginx

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;
include /etc/nginx/mime.types; → Nginx sait quel type de fichier sert (HTML, CSS, JS, images…).

default_type application/octet-stream; → si type inconnu, il traite le fichier comme un “fichier brut”.

5️⃣ Logs HTTP
nginx

access_log  /var/log/nginx/access.log;
Enregistre toutes les visites du site pour analyse ou debugging.

6️⃣ Compression Gzip
nginx

gzip on;
gzip_types text/plain text/css application/json application/javascript application/xml+rss application/atom+xml image/svg+xml;
gzip_min_length 256;
Active la compression des fichiers envoyés → site plus rapide.

Seules certaines extensions sont compressées.

Les fichiers trop petits (<256 bytes) ne sont pas compressés pour éviter le surcoût.

7️⃣ Keepalive
nginx

keepalive_timeout 65;
Garde les connexions ouvertes 65 secondes pour que le navigateur puisse demander plusieurs fichiers sans rouvrir la connexion à chaque fois.

8️⃣ Server block
nginx

server {
    listen 80;
    server_name _;
listen 80; → Nginx écoute sur le port HTTP.

server_name _; → accepte toutes les adresses ou domaines.

9️⃣ Racine et index
nginx

root /usr/share/nginx/html;
index index.html;
root → dossier où sont stockés les fichiers du site.

index → fichier par défaut si quelqu’un visite /.

🔟 Sécurité de base
nginx

add_header X-Content-Type-Options nosniff;
add_header X-Frame-Options SAMEORIGIN;
add_header X-XSS-Protection "1; mode=block";
Protège contre certaines attaques :

nosniff → empêche le navigateur de deviner le type des fichiers.

SAMEORIGIN → interdit d’inclure ton site dans un iframe sur un autre domaine.

XSS-Protection → active la protection contre le cross-site scripting.

1️⃣1️⃣ Cache pour fichiers statiques
nginx

location ~* \.(?:ico|css|js|gif|jpe?g|png|woff2?|ttf|svg|eot)$ {
    expires 6M;
    access_log off;
    add_header Cache-Control "public";
}
Tous les fichiers statiques (CSS, images, JS…) :

mis en cache 6 mois (expires 6M)

pas de log pour chaque accès (access_log off)

navigateur peut les mettre en cache (Cache-Control: public)

1️⃣2️⃣ Page 404 personnalisée
nginx

error_page 404 /index.html;
location = /index.html {
    internal;
}
Si quelqu’un demande un fichier qui n’existe pas, renvoie index.html (utile pour les SPA type React/Vue).

internal → cette règle ne peut pas être appelée directement depuis le navigateur.

✅ En résumé :

Ce fichier dit à Nginx où sont les fichiers, comment les servir, comment gérer les visiteurs, et comment sécuriser le site.

Il inclut aussi compression, cache, logs, sécurité, et gestion des pages d’erreur.

Si tu veux, je peux te faire une version ultra-simplifiée pour débutant qui sert juste ton site statique et ignore tous les paramètres avancés, pour que tu voies juste l’essentiel.
Veux‑tu que je fasse ça ?