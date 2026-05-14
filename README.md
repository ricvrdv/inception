*This project has been created as part of the 42 curriculum by rjesus-d.*

## Description

Inception is a system administration project focused on building a small but complete web infrastructure using Docker and Docker Compose, running inside a virtual machine.

The stack is composed of three services, each running in its own dedicated container: **NGINX** as the sole entry point (via TLS on port 443), **WordPress** with php-fpm for the web application, and **MariaDB** as the database backend. The containers communicate through a custom Docker network, and data is persisted through two named Docker volumes - one for the WordPress database, one for the website files.

A key constraint of the project is that all Docker images are built from scratch using custom Dockerfiles (based on Debian), with no pre-built images pulled from DockerHub. Configuration is managed through environment variables and a `.env` file, keeping credentials out of the codebase.

## Instructions

## Resources

