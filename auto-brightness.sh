#!/bin/bash

STARTHOUR=23
ENDHOUR=8
DIM=32
BRIGHT=255
V=0

CURRHOUR=`date +"%H"`
CURRMIN=`date +"%M"`
DIR=/sys/class/backlight/rpi_backlight/brightness
SLEEPTIME=0

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -s|--starthour)
    echo "Set start hour to $2"
    STARTHOUR="$2"
    shift # past argument
    shift # past value
    ;;
    -e|--endhour)
    echo "Set end hour to $2"
    ENDHOUR="$2"
    shift # past argument
    shift # past value
    ;;
    -d|--dim)
    echo "Set dim to $2"
    DIM="$2"
    shift # past argument
    shift # past value
    ;;
    -b|--bright)
    echo "Set bright to $2"
    BRIGHT="$2"
    shift
    shift
    ;;
    -v|--verbose)
    V=1
    shift
    shift
    ;;
    -h|--help)
    echo "Usage: ./auto-brightness.sh [-v verbose output] [-s starthour] [-e endhout] "
    echo "       [-d|--dim brightness in night time] [-b|--bright birghtness in day time]"
    echo 
    echo "Dim the backlight in night time, reset in day time. Recommend running in background(&)."
    exit
esac
done

if [ $EUID -ne 0 ]
then
    echo "Please run as root."
    exit
fi

if [[ $CURRHOUR -ge $STARTHOUR || $CURRHOUR -le $ENDHOUR-1 ]]; then
    if [ $V -eq 1 ]; then
        echo "Night time, setting brightness to $DIM."
    fi
    echo $DIM > $DIR
    SLEEPTIME=$(( (60*($ENDHOUR- $CURRHOUR - 1) ) + (60-$CURRMIN) ))
    if [ $V -eq 1 ]; then
        echo "Sleep $SLEEPTIME minutes"
    fi
    sleep $SLEEPTIME'm'
else
    if [ $V -eq 1 ]; then
        echo "Day time, set brightness to $BRIGHT"
    fi
    echo $BRIGHT > $DIR
    SLEEPTIME=$(( (60*($STARTHOUR - $CURRHOUR - 1) ) + (60-$CURRMIN) ))
    if [ $V -eq 1 ]; then
        echo "Sleep $SLEEPTIME minutes"
    fi

    sleep $SLEEPTIME'm' 
fi