FROM ubuntu:bionic

WORKDIR /opt/Ookla

RUN apt-get update && \
    apt-get install -y wget && \
    apt-get install -y unzip

RUN wget http://install.speedtest.net/ooklaserver/ooklaserver.sh && \
    chmod a+x ooklaserver.sh && \
    ./ooklaserver.sh install -f

RUN apt-get install -y apache2

RUN wget https://install.speedtest.net/httplegacy/http_legacy_fallback.zip && \
    unzip http_legacy_fallback.zip -d /var/www/html \
    && rm http_legacy_fallback.zip

COPY startscript.sh startscript.sh

#ENTRYPOINT ["/usr/sbin/apache2", "-k", "start"]


ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2



# Expose the default port
EXPOSE 8080 5060 80

CMD ./startscript.sh
