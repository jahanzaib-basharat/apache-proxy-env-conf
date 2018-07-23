FROM debian:wheezy
LABEL maintainer "Jahanzaib<jahanzaib87@gmail.com>"

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install \
        curl \
        apache2 && \
    	rm -rf /var/lib/apt/lists/*

RUN a2enmod proxy_http proxy_ajp proxy_balancer rewrite headers

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
ADD assets/vhost-default.conf /etc/apache2/sites-available/default

RUN mkdir /app /conf
RUN echo "<h1>It Works!</h1>" >> /app/index.html
ADD assets/run.sh /run.sh
ADD assets/proxy.conf /conf/
RUN chmod 755 /*.sh

EXPOSE 80
WORKDIR /app
ENTRYPOINT ["/bin/sh", "-c", "/run.sh"]