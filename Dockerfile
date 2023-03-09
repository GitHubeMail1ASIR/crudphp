FROM php:7.4-apache-bullseye
LABEL githubemail1asir "githubemail1asir@gmail.com"
RUN apt update && apt upgrade -y && docker-php-ext-install mysqli pdo pdo_mysql && apt install mariadb-client -y && apt clean && rm -rf /var/lib/apt/lists/*
ADD src /var/www/html/
ADD script.sh /opt/
RUN chmod +x /opt/script.sh
ENTRYPOINT ["/opt/script.sh"]
