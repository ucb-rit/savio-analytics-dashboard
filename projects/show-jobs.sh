#!/bin/bash

BASEDIR=$(dirname $0)

START_TIME=$1
END_TIME=$2

# Time calculations in awk pipe are based on check_usage.sh
sacct -PX -o JobID,Start,End,Elapsed,AllocCPUS,Partition,Account,State -S "$START_TIME" -E "$END_TIME" --state="BOOT_FAIL,CANCELLED,COMPLETED,DEADLINE,FAILED,NODE_FAIL,OUT_OF_MEMORY,PREEMPTED,REVOKED,TIMEOUT" -a | awk -F'|' '{ if ($4 ~ /-/) { split($4,t,/:|-/); CU=(t[1]*86400.+t[2]*3600.+t[3]*60.+t[4])/3600.; } else { split($4,t,/:/); CU=(t[1]*3600.+t[2]*60.+t[3])/3600.; } SU=CU*$5; print $0 "|" CU "|" SU }' |\
while IFS='|' read -a LINE; do
  ACCOUNT=${LINE[6]}
  if [[ "$ACCOUNT" == "cortex" ]]; then
    continue
  fi
  if [[ "${LINE[2]}" == "Unknown" ]]; then # Ignore if no end date
    continue
  fi
  if [[ "${LINE[2]}" == "End" ]]; then # Ignore first line
    continue
  fi
  END_TIMESTAMP="$(date "+%s" --date="${LINE[2]}")000000000"
  IFS='_' read -a TYPE <<< $ACCOUNT
  IFS='|' read -a DEPARTMENT <<< $(./$BASEDIR/lookup.sh "$ACCOUNT")
  IFS=' ' read -a STATE <<< "${LINE[7]}"
  echo "jobs,job_id=${LINE[0]},account=${ACCOUNT},type=${TYPE[0]},department=$(printf '%q' "${DEPARTMENT[2]}"),cpus=${LINE[4]},partition=${LINE[5]},state=${STATE[0]} raw_time=${LINE[8]},cpu_time=${LINE[9]} $END_TIMESTAMP"
done
