#!/usr/bin/env bash

for i in 1024 512 256 128 64; do \
    convert -gravity center -background none \
            \( Basic\ Compass.svg -resize ${i}x${i} \) \
            \( \
                \( Basic\ Bee.svg -extent 150%x150% -flop \
                    \( +clone -channel A -blur 64x64 -level 5%,50% +channel +level-colors azure \) \
                +swap \
                    \( +clone -channel A -blur 1x1 -level 0,50% +channel +level-colors black \) \
                +swap -flatten \) \
                -geometry $((${i}*2/3))x$((${i}*2/3))+$((${i}/20))-$((${i}/20)) \) \
            -composite \
            icon-${i}.png
done

for i in 32 16; do \
    convert -gravity center -background none \
    Basic\ Compass.svg -resize ${i}x${i} \
    icon-${i}.png
done
