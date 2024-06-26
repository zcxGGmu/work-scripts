#!/bin/bash

insmod ./kvm.ko
./lkvm-static run -m 128 -c2 --console serial -p "console=ttyS0" -k ./Image --debug
