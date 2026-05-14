*This project has been created as part of the 42 curriculum by tlorette.*

# Inception

## Description
Inception is a 42 system administration project. The goal is to deploy a small production-like web stack with Docker Compose: NGINX (TLS), WordPress (PHP-FPM), and MariaDB.

Docker is used to isolate services, keep the setup reproducible, and orchestrate startup dependencies.

Project sources:
- srcs/docker-compose.yml
- srcs/requirements/nginx/
- srcs/requirements/wordpress/
- srcs/requirements/mariadb/
- Makefile
- secrets/

Main design choices:
- One custom image per service.
- Init scripts are idempotent.
- Private bridge network for inter-service traffic.
- Persistent data stored via local volumes bound to host paths.

Required comparisons:
- Virtual Machines vs Docker: VMs virtualize full OSs and are heavier; Docker is lighter and faster for this multi-service setup.
- Secrets vs Environment Variables: env vars are easy for non-sensitive config; secrets are better for passwords and restricted access.
- Docker Network vs Host Network: bridge network isolates containers and limits exposure; host network removes that isolation.
- Docker Volumes vs Bind Mounts: volumes are Docker-managed; bind mounts map exact host paths. This project uses local volumes mapped to host directories.

## Instructions
Prerequisites: Docker, Docker Compose, Make.

From the repository root:

make up

Useful commands:
- make status
- make logs
- make stop / make start
- make down
- make clean / make fclean
- make re

## Resources
References:
- peer learning
- https://www.youtube.com/watch?v=DQdB7wFEygo

AI usage:
- Used to translate, shorten, and structure this README.
- Used to reformulate the mandatory technical comparisons.
