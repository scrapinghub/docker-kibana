FROM ubuntu:utopic
MAINTAINER Luis Arias <luis@balsamiq.com>

RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install wget nginx-full apache2-utils

WORKDIR /opt
RUN wget --no-check-certificate -O- https://download.elasticsearch.org/kibana/kibana/kibana-3.1.2.tar.gz | tar xvfz -
ADD config/config.js /opt/kibana-3.1.2/config.js
RUN mkdir /etc/kibana # This is where the htpasswd file is placed by the run script

ADD init /app/init

ADD config/etc /etc
RUN rm /etc/nginx/sites-enabled/*
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

ENV KIBANA_SECURE true
ENV KIBANA_USER kibana
ENV KIBANA_PASSWORD kibana

EXPOSE 80

ENTRYPOINT ["/app/init"]
CMD ["kibana_start"]
