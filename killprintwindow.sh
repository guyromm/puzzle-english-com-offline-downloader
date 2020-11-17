#!/bin/bash
while (true) ; do wmctrl -l | grep Print | awk '{print $1}' | xargs -r -n1 wmctrl -ic ; date ; sleep 1 ; done
