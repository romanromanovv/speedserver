FROM ubuntu:bionic

WORKDIR /opt/Ookla

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y wget && \
    apt-get install -y unzip git && \ 
    apt-get install -yq --no-install-recommends \
    apt-utils \
    apache2 \
    libapache2-mod-php7.2 \
    php7.2 \
    php7.2-fpm \
    curl \
    openssl \
    nano \
    iputils-ping \
    locales \ 
    && apt-get clean && rm -rf /var/lib/apt/lists/* && \
    wget http://install.speedtest.net/ooklaserver/ooklaserver.sh && \
    chmod a+x ooklaserver.sh && \
    ./ooklaserver.sh install -f && \
    wget https://install.speedtest.net/httplegacy/http_legacy_fallback.zip && \
    unzip http_legacy_fallback.zip -d /var/www/html \
    && rm http_legacy_fallback.zip && \
    locale-gen en_US.UTF-8 en_GB.UTF-8 de_DE.UTF-8 es_ES.UTF-8 fr_FR.UTF-8 it_IT.UTF-8 km_KH sv_SE.UTF-8 fi_FI.UTF-8 && \
    a2enmod rewrite expires && \
    echo "ServerName localhost" | tee /etc/apache2/conf-available/servername.conf && \
    a2enconf servername

RUN    git clone https://github.com/romanromanovv/speedserver
RUN cp ./speedserver/startscript.sh /opt/Ookla/startscript.sh && \
    chmod +x /opt/Ookla/startscript.sh




ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2



# Expose the default port
EXPOSE 8080 5060 80

HEALTHCHECK --interval=5s --timeout=3s --retries=3 CMD curl -f http://localhost || exit 1

CMD ./startscript.sh
