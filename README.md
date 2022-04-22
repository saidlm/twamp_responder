# TWAMP Responder
The aim of the project is to create docker based microservice chain providing twamp responder with some kind of security level. 
The whole solution is based on docker without necessity to any firewall confiruration of host level.
The twamp responder itself is based on perfSONAR project. Additional security leves is done by using standard linux kernel firewall mannaged by iptables program.

## Prerequisits
Installation of Docker with compose plugin is necessary on host machine.

## Building
Almost everything is automated via docker compose. You have to download the project and run docker compose build.
```
git clone https://github.com/saidlm/twamp_responder
cd twamp_responder
docker compose build
```

## Configuration
* The fist step is to change volume location defined in docker-compose.yml
* Default configuration files will be automaticaly populated during first run 
* Security can be defined by to files hosts.allow and hosts.deny. Only lines including IP (x.x.x.x) or subnett (x.x.x.x/y) are relevant for configuration. Everything else will be skipped.

## Running
Creating new containers and start:
```
docker compose up -d
```
As soon as firewall container received TERM signal it automaticaly removes all related firewall rules. You can stop the service by
```
docker compose stop
```
