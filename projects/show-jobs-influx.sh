#!/bin/bash

BASEDIR=$(dirname $0)

START_TIME=$1
END_TIME=$2

$BASEDIR/show-jobs-raw.sh "$START_TIME" "$END_TIME" | $BASEDIR/escape-strings.sh | $BASEDIR/influx-format.awk
