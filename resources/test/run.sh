#!/usr/bin/env bash

XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
touch $XAUTH
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -


docker run -it \
  --rm \
  --volume=$XSOCK:$XSOCK:rw \
  --volume=$XAUTH:$XAUTH:rw \
  --env="XAUTHORITY=${XAUTH}" \
  --env="DISPLAY" \
  --user="marcel" \
  --volume=$1:/home/marcel/.urxvt/cdmn:ro \
  --volume=$2:/home/marcel/.Xresources:ro \
  rxvt
xrdb -load ~/.Xresources
