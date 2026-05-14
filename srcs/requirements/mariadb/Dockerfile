FROM debian:bookworm

RUN apt-get update && apt-get install -y mariadb-server

WORKDIR /usr/local/bin
COPY tools/ .
RUN chmod +x init_db.sh

EXPOSE 3306

ENTRYPOINT ["init_db.sh"]