# lemp-stack-compose

LEMP Stack with Docker Compose

Nginx, PHP-FPM, MySQL and GUI.
LEMP stack to run a single or a few number of isolated web sites sharing a common MySQL database.
Build example.com in minutes.

* Custom Nginx and PHP-FPM images based on official images
* A Nginx reverse proxy is used on the top and web sites have their own PHP and upstream Nginx containers.
* Docker Compose files contain proxy and upstream configuration directives for example.com. 
* Nginx, PHP-FPM and rsyslog images will create well-commented configuration files on the first run
* All automatically created configurations are well-commented and ready to be edited at mount location configurations/
* Adminer (MySQL GUI) runs on 127.0.0.1:8080 with default root password "toor" which must be changed from docker-compose.yml
* Portainer (Docker GUI) runs on 127.0.0.1:9000 and will ask for a new password on first run
* MySQL configuration is statically included at location configurations/server-db/
* Adminer configuration is statically included at location configurations/server-adminer/
* Currently configured to use a rsyslog image and save text logs to location log/
* All images are Alpine based and lightweight
* Containers: Nginx proxy, Nginx upstream, PHP-FPM, MySQL, Rsyslog, Adminer/Phpmyadmin, Portainer

## Requirements

* [Docker](https://docs.docker.com/engine/installation/#server )
* [Docker Compose](https://docs.docker.com/compose/install/ )

## Usage

### Installation

To easily use and maintain, clone into /lemp folder if you have root permissions.
Configuration files, document root, logs and everything will be inside /lemp folder.

	$ sudo git clone https://github.com/vkucukcakar/lemp-stack-compose.git /lemp

### Initial startup
	$ docker-compose -f docker-compose.yml -f sites/example.com.yml up -d

### Starting the server
	$ docker-compose -f docker-compose.yml -f sites/example.com.yml start
	
### Upgrading images to new versions
	$ docker-compose -f docker-compose.yml -f sites/example.com.yml pull
	$ docker-compose -f docker-compose.yml -f sites/example.com.yml up -d
	
### Adding domain names
	$ ./add.sh
	$ docker-compose -f docker-compose.yml -f sites/example.com.yml -sites/new-domain-name.yml up -d

## Compatibility

In v2.0.0, Compose configuration file (yml) structure changed, example.com.yml separated from the main file.
Compose file version is also upgraded but sticked with 2.4 because of "extends" keyword and "service_healthy" condition in "depends_on".
Server directory structure is not changed and Compose configuration directives are nearly the same.
Previously created container configuration (nginx, php, etc.) files in /configurations are also compatible as they are related with images.

## Let's Encrypt Support

The Nginx image used in lemp-stack-compose will create self signed SSL certificates by default.
However if you want free and automatic updating SSL certificates, you can use Let's Encrypt for a real website. 
Let's Encrypt is a non-profit certificate authority. [Let's Encrypt](https://letsencrypt.org/ )
You can use Certbot to install and automatically update Let's Encrypt certificates.

* Install Certbot or a compatible ACME client. Installation is OS dependant. 
  [Certbot](https://certbot.eff.org/instructions ) 
  Only install Certbot, do not run any Certbot commands. Certbot will be used with webroot plugin, not nginx plugin.

* Uncomment the relevant directive to mount "/etc/letsencrypt/live" in "volumes" section of "server-proxy" in "docker-compose.yml"

* Use up parameter for the changes to take effect
	$ docker-compose -f docker-compose.yml -f sites/example.com.yml up -d

* Use certbot only with "certonly" (!) command and "webroot" plugin (!) for the initial setup. (Use your own webroot path and domain)
	$ certbot certonly --webroot -w /lemp/html/example.com -d www.example.com -d example.com

* Certificates will be created if everything was fine. Read the output and verify that files are created
	
* (Optional) Check if the certificates are accessible inside the "server-proxy" container
	$ docker exec -it server-proxy bash
	$ ls /etc/letsencrypt/live/example.com/fullchain.pem
	$ ls /etc/letsencrypt/live/example.com/privkey.pem
	$ exit

* Enable the new certificates by editing the mounted file "/lemp/configurations/server-proxy/nginx-example.com.conf"
  See the commented sections in the file.

* To test if everything is fine, manually reload Nginx server in "server-proxy" container with zero downtime by sending a HUP signal
	$ docker kill --signal=HUP server-proxy

* See the logs at "/lemp/log/server-common.log" to see if everything was fine

* Certbot will update the certificates automatically before the expire.
  A deploy hook script must be created, that will be executed by Certbot, to reload server on certificate updates.

```
    $ echo -e '#!/usr/bin/env bash\ndocker kill --signal=HUP server-proxy' > /etc/letsencrypt/renewal-hooks/deploy/reload-nginx.sh
    $ chmod +x /etc/letsencrypt/renewal-hooks/deploy/reload-nginx.sh
```

  Now, reload-nginx.sh will be executed by Certbot if certificates are updated. (Manually execute it to test once)
  This bash script will reload server (of course with zero downtime).
  

## Caveats

* You may encounter some problems with starting containers in correct order with "restart: always".
  That's why I have used "restart: on-failure" in the example.
  The start on reboot can be achieved with a cron job by using docker-compose alternatively:  
  @reboot root cd /lemp && docker-compose -f docker-compose.yml -f sites/example.com.yml start

* After first run, see the newly created well-commented Nginx configuration files for connection & request limits, DDOS protection, admin login protection, WAF and more.  

* Currently, no mail server is included in the configuration, please add your favorite one to the commented section in docker-compose.yml.

* WordPress users should use vkucukcakar/php-fpm:latest-extras image in common-services.yml as it contains recommended PHP extensions
  for performance. Also there are many commented options for WordPress in nginx configuration files which will be created in /configurations after first run.
