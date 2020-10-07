# Changelog

## v2.1.1

- Added server-mta (commented) to the networks section of site template

## v2.1.0

- Some tags changed in common-services.yml

## v2.0.1

- Fixed add.sh
- Removed some directory and files left from previous releases

## v2.0.0

- Changed Compose configuration file (yml) structure
- Separated upstream yml files from main configuration file
- Upgraded Compose file version. Sticked with 2.4 because of "extends" keyword and "service_healthy" condition in "depends_on"

## v1.4.0

- Removed cron which is not essential and should be in the host
- Upgraded versions of some images

## v1.3.0

- Switched from phpMyAdmin to Adminer
- Commented out phpMyAdmin sections
- Upgraded versions of some images in production yml file

## v1.0.2

- Fixed directory structure!
- Fixed port mapping in development and production compose files
- Fixed production server example

## v1.0.1

- Upgraded versions of some images in production yml file

## v1.0.0

- Initial release
