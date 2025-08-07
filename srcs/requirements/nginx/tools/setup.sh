#!/bin/bash

LINE="127.0.0.1 rhanitra.42.fr"

if ! grep -q "$LINE" /etc/hosts; then
    echo "$LINE" | sudo tee -a /etc/hosts > /dev/null
    echo "Ajout de $LINE dans /etc/hosts"
else
    echo "$LINE déjà présent dans /etc/hosts"
fi
