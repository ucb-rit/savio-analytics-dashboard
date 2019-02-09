#!/bin/bash

module load sqlite/3.25.2

for FILE in *Requests*.tsv; do
  ./prepare.sh "$FILE" > requests-cleaned.tsv
  sqlite3 db.sqlite3 < import-requests.sql
done
