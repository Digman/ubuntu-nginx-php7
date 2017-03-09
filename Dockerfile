FROM phusion/baseimage:latest
MAINTAINER Digman <long2513@gmail.com>

CMD ["/sbin/my_init"]

#languages
RUN locale-gen en_US.UTF-8
RUN locale-gen zh_CN.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

#china timezone
RUN echo "Asia/Shanghai" > /etc/timezone;

ENV WORK_DIR /var/www
RUN mkdir -p $WORK_DIR

#update and add new sources
ADD sources.list /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get update --fix-missing
RUN apt-get install -y software-properties-common
RUN apt-get install -y vim 
RUN apt-get install -y curl
RUN apt-get install -y wget
RUN add-apt-repository -y ppa:ondrej/php
RUN add-apt-repository -y ppa:nginx/stable
RUN apt-get update

#install php7
RUN apt-get install -y -f php7.1-cli php7.1-fpm php7.1-dev php7.1-mysql php7.1-curl
RUN apt-get install -y -f php7.1-redis php7.1-memcached php7.1-gd php7.1-mcrypt

#install nginx
RUN apt-get install -y --allow-unauthenticated nginx

WORKDIR $WORK_DIR

EXPOSE 80 9000 22

ADD info.php /var/www

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
