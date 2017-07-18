# Docker-based Netbeans
* Eclipse Scala IDE in a Docker container

## Requirements
* Docker 1.13.1+ 
* An X11 socket

## Build
```
./build.sh
```

## Run
```
./run.sh
```

## Making plugins persist between sessions

Scala plugins are kept on `$HOME/.scala-ide-docker` inside the container, so if you
want to keep them around after you close it, you'll need to share it with your
host.

For example:

```sh
docker run -ti --rm \
           -e DISPLAY=$DISPLAY \
           -v /tmp/.X11-unix:/tmp/.X11-unix \
           -v `pwd`/.scala-ide-docker:/home/developer/.scala-ide-docker \
           -v `pwd`:/home/developer/workspace \
           openkbs/scala-ide-docker
```

## Help! I started the container but I don't see the Eclispe screen

You might have an issue with the X11 socket permissions since the default user
used by the base image has an user and group ids set to `1000`, two options:
* Create your own base image with the appropriate ids or 
* Or, at the host, run
```
`xhost +` 
```
try again.

## Reference
* http://scala-ide.org/download/sdk.html
