NAME = inception

COMPOSE = docker compose -f srcs/docker-compose.yml

all: dirs build up

dirs:
	mkdir -p /home/rjesus-d/data/mariadb
	mkdir -p /home/rjesus-d/data/wordpress

build:
	$(COMPOSE) build

up:
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

clean:
	$(COMPOSE) down -v --rmi all
	su -c "rm -rf /home/rjesus-d/data/mariadb /home/rjesus-d/data/wordpress"

re: clean all

.PHONY: all dirs build up down clean re
