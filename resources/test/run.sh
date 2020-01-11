#!/usr/bin/env bash

XSOCK=/tmp/.X11-unix

while getopts :e:x: option
do
 case "${option}"
 in
 e) EXTENSION=${OPTARG};;
 x) XRESOURCES=${OPTARG};;
 *) echo $option;;
 esac
done

if [ $OPTIND -eq 1 ]; then echo "No options were passed"; exit 1; fi

xhost +local:;

docker pull jeansen/cdmn_docker 2>/dev/null

[[ $(uname -s) != Linux ]] && display=host.docker.internal:0

docker run \
  -e DISPLAY=${display:-$DISPLAY} \
  --rm \
  --volume=$XSOCK:$XSOCK:rw \
  --volume=$EXTENSION:/urxvt/cdmn:ro \
  --volume=$XRESOURCES:/Xresources:ro \
  jeansen/cdmn_docker

xrdb -load ~/.Xresources

#Change after the following issue is resolved to always use the internal name
#https://github.com/docker/for-linux/issues/264
