# reactive-drop-docker
Reactive Drop server in a docker container

# last build status
[![CircleCI](https://circleci.com/gh/mithrand0/reactive-drop-docker.svg?style=svg)](https://circleci.com/gh/mithrand0/reactive-drop-docker)

# what does it run on
This container does not require a Windows installation to run. It runs on windows, linux, macosx, even without gui.

# what is included
- reactive drop installation, finetuned for performance
- workshop support
- automatic updates, for both game as workshop
- remote management over http/vnc
- bundled sourcemod installation
- easy sourcemod admin configuration
- chat auto translator (requires api key)
- anti cheat!

# how to run
You need Docker

About Docker:
- https://www.docker.com/resources/what-container
- https://www.docker.com/products/docker-enterprise

Get Docker:
- https://www.docker.com/get-started
- https://docs.docker.com/compose/

Install Docker and Docker-Compose.

Run: `docker-compose up`

# how to add custom configs

Copy docker-compose.yml to docker-compose.override.yml and make your changes. 

Restart the container after that.

# how to customize
The game is installed in /root/reactivedrop/. You can overwrite any file 
by putting them in the /reactivedrop/ folder to overwrite any game content.  

