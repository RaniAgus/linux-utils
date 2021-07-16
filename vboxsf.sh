#!/bin/bash

if [ "$EUID" -ne 0 ];then 
    echo "Please run as root:"
    echo -e "sudo ./vboxsf.sh [GUEST] [HOST]"
    exit 1
fi

if [ $# -lt 2 ]; then
    echo "Please enter guest and host folder:"
    echo -e "sudo ./vboxsf.sh [GUEST] [HOST]"
    exit 1
fi

GUEST=$1
HOST=$2

# Convert host to absolute path
case $HOST in
  /*) HOST="$HOST" ;;
  *) HOST="$PWD/$HOST" ;;
esac

# Mount folder
if mount -t vboxsf -o uid=1000,gid=1000 $GUEST $HOST; then
    echo "Mounted $GUEST on $HOST"
else
    exit $?
fi

# Make permanent
echo -e "\nDocs $HOST vboxsf defaults 0 0\n" >> /etc/fstab
echo "Edited: /etc/fstab"
cat /etc/fstab

echo -e "\nvboxsf\n" >> /etc/modules
echo "Edited: /etc/modules"
cat /etc/modules
