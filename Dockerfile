FROM mysql:latest

ENV MYSQL_ROOT_PASSWORD=rootpassword
ENV MYSQL_DATABASE=project_database

COPY database.sql /docker-entrypoint-initdb.d/

EXPOSE 3306
