#!/bin/bash

BASEDIR=$(dirname $0)

# Activate virtualenv
source /home/nicolaschan/venv/bin/activate

# Collect job data
$BASEDIR/load-jobs-today-rest.sh

# Collect CPU data
$BASEDIR/cpu2rest.py
