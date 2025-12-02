NAME = inception

COMPOSE = docker compose -f srcs/docker-compose.yml

all: build up

build:
	$(COMPOSE) build

up:
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

clean:
	$(COMPOSE) down -v --rmi all

re: clean all

.PHONY: all build up down clean re
