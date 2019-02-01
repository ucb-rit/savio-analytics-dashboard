#!/bin/awk -f
BEGIN {
  FS="|";
}

{
  print "jobs,job_id=" $1 ",account=" $2 ",type=" $3 ",department=" $4 ",cpus=" $5 ",partition=" $6 ",state=" $7 " req_nodes=" $8 ",alloc_nodes=" $9 ",raw_time=" $10 ",cpu_time=" $11 " " $12 "000000000";
}
