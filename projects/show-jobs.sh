#!/bin/bash

START_TIME=$1
END_TIME=$2

JOBS=$(sacct -PX -o JobID,Start,End,Elapsed,AllocCPUS,Partition,Account,State  -S "$START_TIME" -E "$END_TIME" --state="BOOT_FAIL,CANCELLED,COMPLETED,DEADLINE,FAILED,NODE_FAIL,OUT_OF_MEMORY,PREEMPTED,REVOKED,TIMEOUT" -a | awk '{ gsub("\\|", ",", $0); print $0 }')

parse-time () {
  TIME=$1
  # Code here based on check-usage.sh
  echo $(awk '{
if ($0 ~ /-/) { 
            split($0, t, /:|-/);
            CU=(t[1]*86400.+t[2]*3600.+t[3]*60.+t[4])/3600.;
        }
        else {
            split($0, t, /:/);
            CU=(t[1]*3600.+t[2]*60.+t[3])/3600.;
        }
    print CU
  }' <<< $TIME)
}

while read -r LINE; do
  ACCOUNT=$(echo "$LINE" | awk -F',' '{ print $7 }')
  TYPE=$(echo "$ACCOUNT" | awk -F'_' '{ print $1 }')
  DEPARTMENT=$(./lookup.sh $ACCOUNT | awk -F'|' '{ print $3 }')
  TIME=$(echo "$LINE" | awk -F',' '{ print $4 }')
  echo "${LINE},${TYPE},${DEPARTMENT},${TIME},$(parse-time $TIME)"
done <<< "$JOBS"
