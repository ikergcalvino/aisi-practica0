#!/bin/bash

if [ $# -ne 1 ]; then
       echo "Syntax error: $0 MOUNT_POINT (e.g. /mnt/rre-aisi2223)"
       exit -1
fi

MOUNT_POINT=$1

if ! grep -qs "$MOUNT_POINT" /proc/mounts; then
	mount /dev/sda $MOUNT_POINT
fi

hostname > $MOUNT_POINT/info
id >> $MOUNT_POINT/info
date >> $MOUNT_POINT/info
grep "$MOUNT_POINT" /proc/mounts >> $MOUNT_POINT/info
cat /etc/lsb-release >> $MOUNT_POINT/info
cat /var/www/html/index.html >> $MOUNT_POINT/info

chown -R vagrant:vagrant $MOUNT_POINT
