# Developer Documentation

This document describes how to set up, build, and manage the Inception infrastructure from a developer's perspective.

## Prerequisites

- A Virtual Machine running Linux (Debian or Ubuntu recommended)
- Docker Engine installed
- Docker Compose installed
- `make` installed
- `openssl` installed (for certificate generation)

## Setting up the environment

**1. Clone the repository**
```bash
git clone https://github.com/rjesus-d/inception.git
cd inception
```

**2. Create secret files**
```bash
echo "yourdbpassword" > secrets/db_password.txt
echo "yourrootpassword" > secrets/db_root_password.txt
echo "youradminpassword" > secrets/wp_admin_password.txt
echo "youruserpassword" > secrets/wp_user_password.txt
```

**3. Configure environment variables**

Review and update `srcs/.env`:
```env
DB_NAME=wordpress
DB_USER=wpuser
DB_HOST=mariadb
DOMAIN_NAME=rjesus-d.42.fr
WP_TITLE=Inception
WP_ADMIN=ricardo
WP_ADMIN_EMAIL=ricardo@example.com
WP_USER=editor
WP_USER_EMAIL=editor@example.com
LOGIN=rjesus-d
```

**4. Configure the domain name**

Add the following to `/etc/hosts` on your virtual machine:
```text
127.0.0.1 rjesus-d.42.fr
```

## Building and launching the project

**Build and start everything:**
```bash
make
```

This will:
1. Create data directories at `/home/rjesus-d/data/`
2. Build all three Docker images from their Dockerfiles
3. Start all containers in detached mode

**Build images only:**
```bash
make build
```

**Start containers only:**
```bash
make up
```

## Managing containers and volumes

| Command | Description |
|---|---|
| `make up` | Start all containers |
| `make down` | Stop containers, keep data and images |
| `make clean` | Stop containers, remove images and data |
| `make re` | Full rebuild from scratch |
| `docker ps` | List running containers |
| `docker logs <container>` | View logs for a container |
| `docker exec -it <container> bash` | Open a shell inside a container |
| `docker volume ls` | List Docker volumes |
| `docker network ls` | List Docker networks |

## Data persistence

All persistent data is stored on the host machine at:

| Data | Host path | Container path |
|---|---|---|
| MariaDB database | `/home/rjesus-d/data/mariadb` | `/var/lib/mysql` |
| WordPress files | `/home/rjesus-d/data/wordpress` | `/var/www/html` |

**`make down`** stops containers but preserves all data. Restarting with `make up` resumes from the same state.

**`make clean`** removes all containers, images, and data directories. The next `make` starts completely fresh.

