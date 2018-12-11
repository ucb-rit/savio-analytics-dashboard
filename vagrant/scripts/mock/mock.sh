#!/bin/bash
flock -w 3 "$(dirname $0)/collected.lock" -c "$(dirname $0)/collected.sh" 
