# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: rhanitra <rhanitra@student.42antananari    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/08/07 18:21:32 by rhanitra          #+#    #+#              #
#    Updated: 2025/08/07 18:21:47 by rhanitra         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #


NAME = inception

COMPOSE = docker compose
COMPOSE_FILE = -f docker-compose.yml
ENV_FILE = --env-file srcs/.env

all: up

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

fclean: down
	docker system prune -af
	sudo rm -rf /home/rhanitra/data/*

re: fclean all

.PHONY: all up build down logs start stop ps exec fclean re
