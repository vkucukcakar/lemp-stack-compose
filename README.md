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
* Containers: Nginx proxy, Nginx upstream, PHP-FPM, MySQL, Rsyslog, Postfix, Adminer/Phpmyadmin, Portainer

## Requirements

* [Docker](https://docs.docker.com/engine/installation/#server )
* [Docker Compose](https://docs.docker.com/compose/install/ )

## Usage

### Initial startup
	$ docker-compose -f docker-compose.yml -f sites/example.com.yml up -d

### Starting the server
	$ docker-compose -f docker-compose.yml -f sites/example.com.yml start
	
### Adding domain names
	$ ./add.sh

## Compatibility

In v2.0.0, Compose configuration file (yml) structure changed, example.com.yml separated from the main file.
Compose file version is also upgraded but sticked with 2.4 because of "extends" keyword and "service_healthy" condition in "depends_on".
Server directory structure is not changed and Compose configuration directives are nearly the same.
Previously created container configuration (nginx, php, etc.) files in /configurations are also compatible as they are related with images.

## Caveats

* You may encounter some problems with starting containers in correct order with "restart: always".
  That's why I have used "restart: on-failure" in the example.
  The start on reboot can be achieved with a cron job by using docker-compose alternatively:  
  @reboot root cd /lemp && docker-compose -f docker-compose.yml -f sites/example.com.yml start
  
* Currently, no mail server is included in the configuration, please add your favorite one to the commented section in docker-compose.yml.
