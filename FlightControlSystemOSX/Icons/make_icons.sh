#!/usr/bin/env bash


# App icons
for i in 1024 512 256 128 64; do \
    convert -gravity center -background none \
            \( 'Basic Compass.svg' -resize ${i}x${i} \) \
            \( \
                \( 'Basic Bee.svg' -extent 150%x150% -flop \
                    \( +clone -channel A -blur 64x64 -level 5%,50% +channel +level-colors azure \) \
                +swap \
                    \( +clone -channel A -blur 1x1 -level 0,50% +channel +level-colors black \) \
                +swap -flatten \) \
                -geometry $((${i}*2/3))x$((${i}*2/3))+$((${i}/20))-$((${i}/20)) \) \
            -composite \
            -strip \
            icon-${i}.png
done
for i in 32 16; do \
    convert -gravity center -background none \
    Basic\ Compass.svg -resize ${i}x${i} \
    -strip \
    icon-${i}.png
done

# Takeoff/Landing
vector_head="path 'M 0,0  l -30,-10  +10,+10  -10,+10  +30,-10 z'"

convert -antialias -background none \( 'Basic Bee.svg' -flop -resize 64x64 -gravity NorthWest -extent 120x140-24-32 -rotate -20 \
                     \( +clone -channel A -blur 1x1 -level 0,50% +channel +level-colors black \) \
                 +swap -flatten \
                     \( +clone -channel A -blur 16x16 -level 5%,50% +channel +level-colors azure \) \
                 +swap \) \
   \( -draw "stroke black fill none circle 25,135 21,135 line 23,135 27,135 line 25,133 25,137
             push graphic-context
               stroke blue fill skyblue
               translate 28,133 rotate -35
               stroke-width 3
               line 0,0  100,0
               translate 105,0
               stroke-width 2
               $vector_head
             pop graphic-context
            " \) \
    -flatten \
    -strip \
    Takeoff.png

convert -antialias -background none \( 'Basic Bee.svg' -flop -resize 64x64 -gravity NorthWest -extent 120x140-32-32 -rotate 40 \
                     \( +clone -channel A -blur 1x1 -level 0,50% +channel +level-colors black \) \
                 +swap -flatten \
                     \( +clone -channel A -blur 16x16 -level 5%,50% +channel +level-colors azure \) \
                 +swap \) \
   \( -draw "stroke black fill none circle 95,135 99,135 line 93,135 97,135 line 95,133 95,137
             push graphic-context
               stroke firebrick3 fill LightCoral
               translate 5,72 rotate 35
               stroke-width 3
               line 0,0  100,0
               translate 105,0
               stroke-width 2
               $vector_head
             pop graphic-context
            " \) \
    -flatten \
    -strip \
    Land.png
