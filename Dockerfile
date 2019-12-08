FROM ubuntu:bionic

WORKDIR /opt/Ookla

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y wget && \
    apt-get install -y unzip

RUN apt-get install -yq --no-install-recommends \
    apt-utils \
    libapache2-mod-php7.2 \
    php7.2-cli \
    php7.2-json \
    php7.2-curl \
    php7.2-fpm \
    php7.2-gd \
    php7.2-ldap \
    php7.2-mbstring \
    php7.2-soap \
    php7.2-xml \
    php7.2-zip \
    php7.2-intl 

RUN wget http://install.speedtest.net/ooklaserver/ooklaserver.sh && \
    chmod a+x ooklaserver.sh && \
    ./ooklaserver.sh install -f

RUN apt-get install -y apache2

RUN wget https://install.speedtest.net/httplegacy/http_legacy_fallback.zip && \
    unzip http_legacy_fallback.zip -d /var/www/html \
    && rm http_legacy_fallback.zip

RUN locale-gen en_US.UTF-8 en_GB.UTF-8 de_DE.UTF-8 es_ES.UTF-8 fr_FR.UTF-8 it_IT.UTF-8 km_KH sv_SE.UTF-8 fi_FI.UTF-8
RUN a2enmod rewrite expires
RUN echo "ServerName localhost" | tee /etc/apache2/conf-available/servername.conf
RUN a2enconf servername

COPY startscript.sh startscript.sh

#ENTRYPOINT ["/usr/sbin/apache2", "-k", "start"]


ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2



# Expose the default port
EXPOSE 8080 5060 80

HEALTHCHECK --interval=5s --timeout=3s --retries=3 CMD curl -f http://localhost || exit 1

CMD ./startscript.sh
