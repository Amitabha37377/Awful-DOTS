#!/bin/sh

BLANK='#00000000'
CLEAR='#ffffff'
DEFAULT='#1a1b26'
TEXT='#1a1b26'
WRONG='#880000'
VERIFYING='#1a1b26'

i3lock \
--insidever-color=$CLEAR     \
--ringver-color=$VERIFYING   \
\
--insidewrong-color=$CLEAR   \
--ringwrong-color=$WRONG     \
\
--inside-color=$BLANK        \
--ring-color=$DEFAULT        \
--line-color=$BLANK          \
--separator-color=$DEFAULT   \
\
--verif-color=$TEXT          \
--wrong-color=$TEXT          \
--time-color=$TEXT           \
--date-color=$TEXT           \
--layout-color=$TEXT         \
--keyhl-color=$WRONG         \
--bshl-color=$WRONG          \
\
--screen 1                   \
--clock                      \
--indicator                  \
--time-str="%H:%M"        \
--date-str="%A, %Y-%m-%d"       \
--image ~/Downloads/Wallpapers/lock.jpeg\
