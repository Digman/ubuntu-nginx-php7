# ubuntu-nginx-php7
Docker: Ubuntu, Nginx and PHP 7, based on [phusion/baseimage-docker](https://github.com/phusion/baseimage-docker) base Ubuntu image.
### Build & Run
Assuming you have [Docker](https://www.docker.com/get-docker)，
You can build this yourself after cloning the project:
    
    $ git clone https://github.com/Digman/ubuntu-nginx-php7.git
    $ cd ubuntu-nginx-php7
    $ sh run.sh {local_www_root} {local_web_port}

Or get image from daocloud.io:
    
    $ docker pull daocloud.io/digman/ubuntu-nginx-php7:latest
    $ docker run -d -P -p 8080:80 --name php7 daocloud.io/digman/ubuntu-nginx-php7
