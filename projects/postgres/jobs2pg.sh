#!/bin/bash

BASEDIR=$(dirname $0)
$BASEDIR/../show-jobs-raw.sh | $BASEDIR/jobs2pg.py
