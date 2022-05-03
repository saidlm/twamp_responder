# TWAMP Responder
The aim of the project is to create docker based microservice chain providing twamp responder with some kind of security level. 
The whole solution is based on docker without necessity to have any firewall confiruration of host level.
The twamp responder itself is based on perfSONAR project. Additional security leves is done by using standard linux kernel firewall mannaged by iptables program.

## Prerequisits
Installation of Docker with docker compose plugin is necessary on host machine.

## Building
Almost everything is automated via docker compose. You have to download the project and run docker compose build.
```
git clone https://github.com/saidlm/twamp_responder
cd twamp_responder
docker compose build
```

## Configuration
* The fist step is to change volume location defined in docker-compose.yml
* Default configuration files will be automaticaly populated during the first run 
* Security can be defined by to files hosts.allow and hosts.deny. Only lines including IP (x.x.x.x) or subnet (x.x.x.x/y) are relevant for the configuration. Everything else in these files will be skipped. 

### Configuration files
All the configuration files are in one folder located on docker volume. The volume is shared by both containers. The both containers have read-only acces to the voleme.

| File Name | Description 
| :-- | :--
| **twamp-server.conf** | The main TWAMP deamon configuration
| **twamp-server.limits** | Policy definition for the twampd process
| **hosts.allow** | List of IP addresses od subnets which are allowed by firewall to use the responder
| **hosts.deny** | List of IP addresses od subnets which are block by firewall to access the responder

### Firewall configuration
The default firewall policy for TWAMP Responder is DENY. If no hosts.allow fie is define or contains no entry then the access to responder is completely block by firewall.

## Running
Creating new containers and start:
```
docker compose up -d
```
As soon as firewall container received TERM signal it automaticaly removes all related firewall rules. You can stop the service by
```
docker compose stop
```

### Network ports
The responder is by default configured to uses two type of network ports. It can be configured in twamp-server.conf. If the default configuration of twampd is changed it is neccessary to change also expose ports in Dockerfile.twamp and port forwarding configuration docker-compose.yml

The default configuration is:
| Port Number | Description
| :-- | :--
| tcp/882 | Control port
| udp/18770 | Test port
