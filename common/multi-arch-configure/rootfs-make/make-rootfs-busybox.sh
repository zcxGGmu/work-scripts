#!/bin/bash

cd $BUSYBOX/_install; find ./ | cpio -o -H newc > ../../rootfs.img; cd -
