#!/bin/bash
sreport job sizesbyaccount partitions=$1 -P --noheader | awk -F"|" "{ print \"cluster=\" \$1 \",partition=$1,account=\" \$2 \" percentage=\" substr(\$8,0,length(\$8)-1) }"
