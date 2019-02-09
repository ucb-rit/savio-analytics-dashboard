#!/bin/bash

# The raw sheet downloads are missing proper column names

TSV_FILE=$1
COLUMNS=$(head -n1 "$TSV_FILE" | awk -F"\t" 'BEGIN { INDEX=0; OUTPUT=""; } { for (i = 1; i < NF; i++) { if (length($i) == 0) { INDEX = INDEX + 1; OUTPUT = OUTPUT INDEX "\t"; } else { OUTPUT = OUTPUT $i "\t"; } } print OUTPUT }')

echo "$COLUMNS"
tail -n +2 "$TSV_FILE"
