# lemp-stack-compose

LEMP Stack with Docker Compose

Nginx, PHP-FPM, MySQL and more...
These Docker Compose files contain a proxy and an upstream configuration directives for example.com. 
Images automatically create well-commented configuration files to be edited by mounting directories.
These compose files are not just a ready-to-use example of LEMP stack with Docker, but also example of usage of my images. 

* Custom Nginx and PHP-FPM images based on official images
* Nginx, PHP-FPM and rsyslog images will create well-commented configuration files on the first run
* All automatically created configurations are well-commented and ready to be edited at mount location configurations/
* MySQL configuration is statically included at location configurations/server-db/mysql.cnf
* Containers: Nginx proxy, Nginx upstream, PHP-FPM, MySQL, Rsyslog, Postfix, Phpmyadmin, Cron, Portainer
* Develeopment and production usage examples

## Requirements

* [Docker](https://docs.docker.com/engine/installation/#server )
* [Docker Compose](https://docs.docker.com/compose/install/ )

## Usage

### Simple usage example
	$ docker-compose pull
	$ docker-compose up -d

### Production example
	$ docker-compose pull
	$ docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d

## Caveats

* You may encounter some problems with starting containers in correct order with "restart: always".
  That's why I have used "restart: on-failure" in the example.
  The initial start on reboot can be achieved with a cron job by using docker-compose alternatively:  
  @reboot root cd /path/to/lemp-stack-compose && docker-compose -f docker-compose.yml -f docker-compose.prod.yml start
  
* Currently, no mail server is included in the configuration as vkucukcakar/postfix is under development.
