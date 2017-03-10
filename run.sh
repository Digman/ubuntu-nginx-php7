#!/usr/bin/env bash

docker build -t digman/ubuntu-nginx-php7 .
docker run -d -v $1:/var/www -P -p $2:80 --name php7 digman/ubuntu-nginx-php7
docker exec -it php7 bash