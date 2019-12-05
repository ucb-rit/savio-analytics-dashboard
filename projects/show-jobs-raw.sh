#!/bin/bash

BASEDIR=$(dirname $0)

START_TIME=$1
END_TIME=$2

# sacct -S "2019-09-26" -E "2019-09-27" -a -PX -o JobID,Start,End,Elapsed,AllocCPUS,Partition,Account,State,ReqNodes,AllocNodes,NodeList --state="BOOT_FAIL,CANCELLED,COMPLETED,DEADLINE,FAILED,NODE_FAIL,OUT_OF_MEMORY,PREEMPTED,REVOKED,TIMEOUT"

# Time calculations in awk pipe are based on check_usage.sh
sacct -a -S "$START_TIME" -E "$END_TIME" -PX -o JobID,Start,End,Elapsed,AllocCPUS,Partition,Account,State,ReqNodes,AllocNodes,NodeList,User | awk -F'|' '{ if ($4 ~ /-/) { split($4,t,/:|-/); CU=(t[1]*86400.+t[2]*3600.+t[3]*60.+t[4])/3600.; } else { split($4,t,/:/); CU=(t[1]*3600.+t[2]*60.+t[3])/3600.; } SU=CU*$5; print $0 "|" CU "|" SU }' |\

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
  END_TIMESTAMP="$(date "+%s" --date="${LINE[2]}")"
  START_TIMESTAMP="$(date "+%s" --date="${LINE[1]}")"
  IFS='_' read -a TYPE <<< $ACCOUNT
  DEPARTMENT=$($BASEDIR/lookup.sh "$ACCOUNT" | sed 's/|//g') # Remove pipe (if there is one) so it doesn't interfere with output
  IFS=' ' read -a STATE <<< "${LINE[7]}"
  
  if [[ "${LINE[10]}" == "None assigned" ]]; then
    LINE[10]=""
  fi

  # job_id|account|type|department|cpus|partition|state|req_nodes|alloc_nodes|raw_time|cpu_time|end_time|start_time|node_list
  echo "${LINE[0]}|${ACCOUNT}|${TYPE[0]}|$DEPARTMENT|${LINE[4]}|${LINE[5]}|${STATE[0]}|${LINE[8]}|${LINE[9]}|${LINE[12]}|${LINE[13]}|$END_TIMESTAMP|$START_TIMESTAMP|${LINE[10]}|${LINE[11]}|"
done
