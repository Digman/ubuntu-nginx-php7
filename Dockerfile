FROM phusion/baseimage:latest
MAINTAINER Digman <long2513@gmail.com>

CMD ["/sbin/my_init"]

#ENVs
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV WORK_DIR /var/www
ENV TIME_ZONE Asia/Shanghai

#languages
RUN locale-gen en_US.UTF-8
RUN locale-gen zh_CN.UTF-8

#timezone
RUN cp /usr/share/zoneinfo/$TIME_ZONE /etc/localtime && echo $TIME_ZONE > /etc/timezone

#update and add new sources
RUN mv /etc/apt/sources.list /etc/apt/sources.list.backup
ADD build/sources.list /etc/apt/sources.list
RUN add-apt-repository -y ppa:ondrej/php
RUN add-apt-repository -y ppa:nginx/stable
RUN add-apt-repository -y ppa:git-core/ppa
RUN apt-get update
RUN apt-get install -y software-properties-common
RUN apt-get install -y vim curl wget zip git sudo

#install php7
RUN apt-get install -y -f php7.1-cli php7.1-fpm php7.1-mysql php7.1-curl php7.1-mbstring php7.1-xml
RUN apt-get install -y -f php7.1-redis php7.1-memcached php7.1-gd php7.1-mcrypt php7.1-dev

RUN sed -i "s/;date.timezone =.*/date.timezone = PRC/" /etc/php/7.1/fpm/php.ini
RUN sed -i "s/;date.timezone =.*/date.timezone = PRC/" /etc/php/7.1/cli/php.ini
RUN sed -i 's/upload_max_filesize\ =\ 2M/upload_max_filesize\ =\ 20M/g' /etc/php/7.1/fpm/php.ini
RUN sed -i 's/post_max_size\ =\ 8M/post_max_size\ =\ 20M/g' /etc/php/7.1/fpm/php.ini
RUN sed -i 's/max_execution_time\ =\ 30/max_execution_time\ =\ 3600/g' /etc/php/7.1/fpm/php.ini
RUN sed -i 's/\;error_log\ =\ syslog/error_log\ =\ syslog/g' /etc/php/7.1/fpm/php.ini
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/7.1/fpm/php-fpm.conf
RUN sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.1/fpm/php.ini
RUN sed -i "s/listen\ =\ \/run\/php\/php7.1-fpm.sock/;listen\ =\ \/run\/php\/php7.1-fpm.sock\nlisten\ =\ 9000/" \
/etc/php/7.1/fpm/pool.d/www.conf

#install composer
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer
RUN composer config -g repo.packagist composer https://packagist.phpcomposer.com

#install nginx
RUN apt-get install -y --allow-unauthenticated nginx
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

ADD build/default   /etc/nginx/sites-enabled/default
RUN mkdir           /etc/service/nginx
ADD build/nginx.sh  /etc/service/nginx/run
RUN chmod +x        /etc/service/nginx/run
RUN mkdir           /etc/service/phpfpm
ADD build/phpfpm.sh /etc/service/phpfpm/run
RUN chmod +x        /etc/service/phpfpm/run
RUN rm -rf          $WORK_DIR/html

RUN mkdir -p $WORK_DIR
ADD build/index.php $WORK_DIR
WORKDIR $WORK_DIR

EXPOSE 80 9000
VOLUME ["$WORK_DIR","/etc/nginx"]

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
