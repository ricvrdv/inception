# User Documentation

This document explains how to use and manage the Inception infrastructure as an end user or administrator.

## What services are provided?

The infrastructure provides a fully functional WordPress website, accessible via HTTPS. It is composed of three services:

- **NGINX** — the web server and sole entry point, accessible on port 443 via HTTPS
- **WordPress** — the content management system where you can create and manage content
- **MariaDB** — the database that stores all WordPress data (runs in the background, not directly accessible)

## Starting and stopping the project

**Start the project:**
```bash
make
```

**Stop the project (keeps data):**
```bash
make down
```

**Full cleanup (removes all data):**
```bash
make clean
```

## Accessing the website

Once the project is running, open your browser and navigate to:

https://rjesus-d.42.fr

## Accessing the administration panel

The WordPress administration panel is available at:

https://rjesus-d.42.fr/wp-admin

Log in with the administrator credentials defined in your `secrets/wp_admin_password.txt` file. The administrator username is defined in `srcs/.env` as `WP_ADMIN`.

## Locating and managing credentials

| Credential | Location |
|---|---|
| Database password | `secrets/db_password.txt` |
| Database root password | `secrets/db_root_password.txt` |
| WordPress admin password | `secrets/wp_admin_password.txt` |
| WordPress user password | `secrets/wp_user_password.txt` |
| Usernames and non-sensitive config | `srcs/.env` |

## Checking that services are running correctly

**Check running containers:**
```bash
docker ps
```

All three containers (`mariadb`, `wordpress`, `nginx`) should show as `Up`.
