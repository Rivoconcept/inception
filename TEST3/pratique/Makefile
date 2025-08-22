# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: rivoinfo <rivoinfo@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/08/07 18:21:32 by rhanitra          #+#    #+#              #
#    Updated: 2025/08/21 15:41:44 by rivoinfo         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #


NAME = inception

MYSQL_UID := 1001
WP_UID := 1002

COMPOSE = docker compose
COMPOSE_FILE = -f ./srcs/docker-compose.yml
ENV_FILE = --env-file srcs/.env

DOMAIN=rhanitra.42.fr


all: addHost setupUsers up  

up:
	$(COMPOSE) $(ENV_FILE) $(COMPOSE_FILE) up --build -d

build:
	$(COMPOSE) $(ENV_FILE) $(COMPOSE_FILE) build

down:
	$(COMPOSE) $(COMPOSE_FILE) down

logs:
	$(COMPOSE) $(COMPOSE_FILE) logs -f

start:
	$(COMPOSE) $(COMPOSE_FILE) start

stop:
	$(COMPOSE) $(COMPOSE_FILE) stop

ps:
	$(COMPOSE) $(COMPOSE_FILE) ps

exec:
	$(COMPOSE) $(COMPOSE_FILE) exec

setupUsers: setupMariaUser setupWPUser


setupMariaUser:
	@echo "Setup MariaDB user on host"
	@if id -u mysql >/dev/null 2>&1; then \
		echo "User mysql already exists, skipping creation"; \
	else \
		echo "Creating mysql user with UID $(MYSQL_UID)"; \
		sudo useradd -u $(MYSQL_UID) mysql; \
	fi
	@sudo mkdir -p /home/rhanitra/data/mysql
	@echo "Fixing permissions on /home/rhanitra/data/mysql"
	@sudo chown -R $(MYSQL_UID):$(MYSQL_UID) /home/rhanitra/data/mysql
	@sudo chmod -R 755 /home/rhanitra/data/mysql

setupWPUser:
	@echo "Setup WordPress user on host"
	@if id -u www-data >/dev/null 2>&1; then \
		echo "User www-data already exists, skipping creation"; \
	else \
		echo "Creating www-data user with UID $(WP_UID)"; \
		sudo useradd -u $(WP_UID) www-data; \
	fi
	@sudo mkdir -p /home/rhanitra/data/html
	@echo "Fixing permissions on /home/rhanitra/data/html"
	@sudo chown -R $(WP_UID):$(WP_UID) /home/rhanitra/data/html
	@sudo chmod -R 755 /home/rhanitra/data/html

addHost:
	@echo "Add host $(DOMAIN)"
	@grep -qxF "127.0.0.1 $(DOMAIN)" /etc/hosts || \
		echo "127.0.0.1 $(DOMAIN)" | sudo tee -a /etc/hosts

rmHost:
	@echo "Remove host $(DOMAIN)"
	@sudo sed -i '\|127.0.0.1[[:space:]]\+$(DOMAIN)|d' /etc/hosts

fclean: down
	docker system prune -af
	sudo rm -rf /home/rhanitra/data/*
# 	docker volume rm -f srcs_db_data srcs_wp_data

re: fclean all

.PHONY: all up build down logs start stop ps exec fclean re
