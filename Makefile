NAME            = inception
DOCKER_COMPOSE  = docker compose -f ./srcs/docker-compose.yml
DATA_PATH       = /home/$(USER)/data

all: up

setup:
	@mkdir -p $(DATA_PATH)/mariadb
	@mkdir -p $(DATA_PATH)/wordpress

up: 	setup
	@$(DOCKER_COMPOSE) up -d --build

down:
	@$(DOCKER_COMPOSE) down

stop:
	@$(DOCKER_COMPOSE) stop

start:
	@$(DOCKER_COMPOSE) start

clean:
	@$(DOCKER_COMPOSE) down -v --rmi all --remove-orphans

fclean:	clean
	@docker builder prune -af
	@sudo rm -rf $(DATA_PATH)	
	
re: 	fclean all

status:
	@$(DOCKER_COMPOSE) ps

logs:
	@$(DOCKER_COMPOSE) logs -f

.PHONY: all build up down clean fclean re status logs setup stop start
