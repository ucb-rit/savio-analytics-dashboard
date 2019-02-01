#!/bin/bash

while IFS='|' read -a LINE; do
  for PART in "${LINE[@]}"; do
    printf '%q' "${PART}"
    printf '|'
  done
  echo
done
