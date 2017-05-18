#!/bin/bash -e

CONTAINER_NAME="$1"

while [ -z "$CONTAINER_NAME" ]
do
  read -p "Donnez le nom du nouveau conteneur: " CONTAINER_NAME
done

if [ $(lxc list -c n | grep -c "| *$CONTAINER_NAME *|") == 1 ]
then
  echo "Un conteneur porte déja ce nom..."
else
  lxc launch images:ubuntu/yakkety/amd64 "$CONTAINER_NAME"
  sleep 30
fi

lxc exec "$CONTAINER_NAME" -- apt update
sleep 30
lxc exec "$CONTAINER_NAME" -- apt -y upgrade
lxc exec "$CONTAINER_NAME" -- apt -y install openssh-server python sudo
lxc exec "$CONTAINER_NAME" -- adduser gregoire
lxc exec "$CONTAINER_NAME" -- usermod -a -G sudo gregoire
lxc restart "$CONTAINER_NAME"
