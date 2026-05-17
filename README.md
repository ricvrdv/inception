*This project has been created as part of the 42 curriculum by rjesus-d.*

## Description

Inception is a system administration project focused on building a small but complete web infrastructure using Docker and Docker Compose, running inside a virtual machine.

The stack is composed of three services, each running in its own dedicated container: **NGINX** as the sole entry point (via TLS on port 443), **WordPress** with php-fpm for the web application, and **MariaDB** as the database backend. The containers communicate through a custom Docker network, and data is persisted through two named Docker volumes - one for the WordPress database, one for the website files.

A key constraint of the project is that all Docker images are built from scratch using custom Dockerfiles (based on Debian), with no pre-built images pulled from DockerHub. Configuration is managed through environment variables and a `.env` file, keeping credentials out of the codebase.

### Virtual Machines vs Docker

A Virtual Machine (VM) emulates an entire operating system (OS), including its own kernel, on top of a hypervisor. This means each VM requires significant resources — CPU, RAM, and disk — just to run the OS itself. Docker containers, by contrast, share the host machine's kernel and isolate only the application and its dependencies. This makes containers much lighter, faster to start, and more efficient with resources. In this project, Docker runs inside a VM to satisfy the subject's isolation requirements.

### Secrets vs Environment Variables

Environment variables are a convenient way to pass configuration to containers, but they are visible in plain text to anyone with access to the `.env` file or the container's environment. Docker secrets, on the other hand, are mounted as files inside the container at `/run/secrets/` and are never exposed as environment variables. In this project, sensitive values like database passwords and WordPress credentials are stored as Docker secrets, while non-sensitive configuration like database names and domain names are passed as environment variables.

### Docker Network vs Host Network

With `network: host`, a container shares the host machine's network stack directly — it can reach any port on the host and is reachable from outside without any port mapping. This is convenient but eliminates network isolation entirely. A custom Docker bridge network, as used in this project, creates an isolated network where containers can communicate with each other by container name, but are invisible to the outside world. Only NGINX is exposed to the host via port 443, making it the sole entry point into the infrastructure.

### Docker Volumes vs Bind Mounts

A bind mount directly maps a path on the host machine to a path inside the container. This gives full control over where data is stored but ties the container to the host's filesystem structure. A named Docker volume is managed by Docker itself — it abstracts the storage location and provides better portability. In this project, named volumes are used as required by the subject, configured to physically store data at `/home/rjesus-d/data/` on the host machine while remaining managed by Docker.

## Instructions

### Prerequisites

- A Virtual Machine running Linux (Debian or Ubuntu recommended)
- Docker and Docker Compose installed
- `make` installed

### Setup

**1. Clone the repository**

```bash
git clone https://github.com/rjesus-d/inception.git
cd inception
```

**2. Configure the domain name**

Add the following line to `/etc/hosts` on your virtual machine:

```text
127.0.0.1 rjesus-d.42.fr
```

**3. Create the secret files**

Create the following files in the `secrets/` folder with your chosen passwords:

```bash
echo "yourdbpassword" > secrets/db_password.txt
echo "yourrootpassword" > secrets/db_root_password.txt
echo "youradminpassword" > secrets/wp_admin_password.txt
echo "youruserpassword" > secrets/wp_user_password.txt
```

**4. Configure the environment**

Review `srcs/.env` and update any values to match your setup.

**5. Build and start the infrastructure**

```bash
make
```

### Stopping the project

```bash
make down
```

### Full cleanup

```bash
make clean
```

## Resources

### Docker

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Dockerfile Best Practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Docker Secrets](https://docs.docker.com/engine/swarm/secrets/)
- [Docker Volumes](https://docs.docker.com/storage/volumes/)
- [Docker Networks](https://docs.docker.com/network/)

### MariaDB
- [MariaDB Documentation](https://mariadb.com/kb/en/documentation/)
- [mysql_install_db](https://mariadb.com/kb/en/mysql_install_db/)

### WordPress
- [WordPress Documentation](https://wordpress.org/documentation/)
- [WP-CLI Documentation](https://wp-cli.org/)

### NGINX
- [NGINX Documentation](https://nginx.org/en/docs/)
- [NGINX FastCGI](https://www.nginx.com/resources/wiki/start/topics/examples/phpfcgi/)

### TLS/SSL
- [OpenSSL Documentation](https://www.openssl.org/docs/)
- [TLS Protocol](https://developer.mozilla.org/en-US/docs/Web/Security/Transport_Layer_Security)

### AI Usage

AI was used throughout this project primarily as a learning and review tool. For concepts that were new or unclear — such as PID 1, TLS/SSL, php-fpm, Docker secrets, and the differences between virtual machines and containers — AI was used to get explanations and concrete examples that helped build understanding before writing any code.

AI was also used to review and debug configuration files and scripts, helping identify issues such as incorrect file paths, missing flags, and syntax errors. Finally, AI assisted in writing and structuring the documentation files, including this README, `USER_DOC.md`, and `DEV_DOC.md`.

In all cases, the goal was to understand the generated content before using it, in line with the AI usage guidelines outlined in the subject.