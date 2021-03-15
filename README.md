# vellum-docker

Running clark86's [Vellum](https://github.com/clarkx86/vellum) in a Docker container

## Setup

docker-compose.yaml defines where the worlds, config and backup files are located as well as the port number for the server - you will need to change these settings for your own needs.

In the folder defined above, you need create the following new folders:
* backup
* config
* worlds

In the config folder, you need to copy in your Vellum configuration.json file - [a sample](configuration.json) has been included for you in this repository.
Make sure that you have  the following config:
* `"BdsBinPath": "./bedrock_server",`
* `"ArchivePath": "/bedrock-server/backup/",`

## How to run using the docker-compose file
1. Down the files in this repository
2. Set the correct parameters for your environment
2. Open a shell to the folder
3. Run `docker-compose -f ./docker-compose.yaml up`

## Docker image
[https://hub.docker.com/r/lastsandwich/minecraft-vellum-linux](https://hub.docker.com/r/lastsandwich/minecraft-vellum-linux)

## Known issues

* I have not been able to get Papyrus working in a Docker container.
* Getting `bedrock_server` and `bedrock-server` mixed up is really easy
