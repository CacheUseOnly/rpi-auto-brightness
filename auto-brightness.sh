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

while :
do

CURRHOUR=`date +"%H"`
CURRMIN=`date +"%M"

if [[ 10#$CURRHOUR -ge $STARTHOUR || 10#$CURRHOUR -lt $ENDHOUR ]]; then
    if [ $V -eq 1 ]; then
        echo "Night time, setting brightness to $DIM."
    fi
    echo $DIM > $DIR

    if [ $((10#$CURRHOUR)) -gt $STARTHOUR ]; then
        SLEEPTIME=$(( (60*(24-$CURRHOUR+$ENDHOUR-1) )+ (60-10#$CURRMIN) ))
    else
        SLEEPTIME=$(( (60*($ENDHOUR-$CURRHOUR-1) ) + (60-10#$CURRMIN) ))
    fi

    if [ $V -eq 1 ]; then
        echo "Sleep $SLEEPTIME minutes"
        echo
    fi
    sleep $SLEEPTIME'm'
else
    if [ $V -eq 1 ]; then
        echo "Day time, set brightness to $BRIGHT"
    fi
    echo $BRIGHT > $DIR
    SLEEPTIME=$(( (60*($STARTHOUR - 10#$CURRHOUR - 1) ) + (60-10#$CURRMIN) ))
    if [ $V -eq 1 ]; then
        echo "Sleep $SLEEPTIME minutes"
        echo
    fi

    sleep $SLEEPTIME'm' 
fi
done