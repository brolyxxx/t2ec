#!/bin/bash

# This script displays an appropriate brightness icon according to the brightness level by `light` command

# Author: Piotr Miller
# e-mail: nwg.piotr@gmail.com
# Website: http://nwg.pl
# Project: https://github.com/nwg-piotr/t2ec
# License: GPL3

# Dependencies: `light-git`
# arguments: [up] | [down] | [<level>] | [-N]

if [[ $1 == up ]]; then
    light -A 5
elif [[ $1 == down ]]; then
    light -U 5
else
    if [[ $(($1)) == $1 ]] && [[ "$1" -ge 0 ]] && [[ "$1" -le 100 ]]; then
        light -S $1
    fi
fi

b=$(light -G)

bri=$(echo $b | awk '{ printf"%0.0f\n", $1 }')

if [[ $1 == -N* ]]; then
        echo "Bri: ${bri}%"
else
    if [[ "$bri" -gt "90" ]]; then
        echo /usr/share/t2ec/bri-full.svg
    elif [[ "$bri" -gt "50" ]]; then
        echo /usr/share/t2ec/bri-high.svg
    elif [[ "$bri" -gt "30" ]]; then
        echo /usr/share/t2ec/bri-medium.svg
    else
        echo /usr/share/t2ec/bri-low.svg
    fi
    echo ${bri}%
fi
