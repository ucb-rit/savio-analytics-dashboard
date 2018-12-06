#!/bin/bash
sinfo -o "%n,%T" | awk -F',' '{ if (substr($2,length($2),1) == "*") { RESPONDING=0; state=substr($2,0,length($2)-1) } else { RESPONDING=1;STATE=$2 } print "node_state,hostname=" $1 ",state=" STATE " responding=" RESPONDING }'
