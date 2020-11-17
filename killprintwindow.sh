#!/bin/bash
wmctrl -l | grep Print | awk '{print $1}' | xargs -r -n1 wmctrl -ic
