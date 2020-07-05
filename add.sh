#!/bin/bash

###
# lemp-stack-compose
# LEMP Stack with Docker Compose
# Copyright (c) 2017 Volkan Kucukcakar
#
# This file is part of lemp-stack-compose.
#
# lemp-stack-compose is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# lemp-stack-compose is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# This copyright notice and license must be retained in all files and derivative works.
###

###
# File Name        : add.sh
# File Description : Bash script to create Docker Compose configuration files for the given domain names
###


# Limit environment variables to substitute
SHELL_FORMAT='$DOMAIN_NAME,$CONTAINER_NAME'
envsubst -V >/dev/null 2>&1 || { echo "Error: envsubst is not available."; exit 1; }
dirname --version >/dev/null 2>&1 || { echo "Error: dirname is not available."; exit 1; }
tr --version >/dev/null 2>&1 || { echo "Error: tr is not available."; exit 1; }
echo -e "Domain name to create Docker Compose configuration file: \n(example.com)"
read DOMAIN_NAME
if [ "$DOMAIN_NAME" ]; then
	if [[ $DOMAIN_NAME =~ ^[[:alnum:]\._-]+$ ]]; then
		DIR=$(dirname $0)
		[ -f "$DIR/sites/$DOMAIN_NAME.yml" ] && { echo "Error: $DIR/sites/$DOMAIN_NAME.yml already exists."; exit 1; }
		export DOMAIN_NAME
		export CONTAINER_NAME="$(tr . - <<<$DOMAIN_NAME)"
		envsubst "$SHELL_FORMAT" < "$DIR/templates/nginx-php.yml" > "$DIR/sites/$DOMAIN_NAME.yml"
		if [ $? -eq 0 ]; then
			echo -e "\nSuccessfully created sites/$DOMAIN_NAME.yml"
			echo "You can include the configuration file as follows:"
			echo "i.e.: docker-compose -f docker-compose.yml -f sites/$DOMAIN_NAME.yml up -d"
		fi
		mkdir "$DIR/html/$DOMAIN_NAME"
		mkdir "$DIR/configurations/$CONTAINER_NAME"
	else
		echo "Error: $DOMAIN_NAME is not a valid domain name."
		exit 1
	fi
fi
