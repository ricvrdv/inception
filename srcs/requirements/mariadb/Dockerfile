FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    mariadb-server \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/mysqld && chown mysql:mysql /run/mysqld

COPY conf/ /etc/mysql/mariadb.conf.d/
WORKDIR /usr/local/bin
COPY tools/ .
RUN chmod +x init_db.sh

EXPOSE 3306

ENTRYPOINT ["init_db.sh"]
