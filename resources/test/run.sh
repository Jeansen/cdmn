#!/usr/bin/env bash

XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
#touch $XAUTH
#xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

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

docker run \
  --rm \
  --volume=$XSOCK:$XSOCK:rw \
  --volume=$XAUTH:$XAUTH:rw \
  --env="XAUTHORITY=${XAUTH}" \
  --env="DISPLAY" \
  --volume=$EXTENSION:/urxvt/cdmn:ro \
  --volume=$XRESOURCES:/Xresources:ro \
  jeansen/cdmn_docker

xrdb -load ~/.Xresources
