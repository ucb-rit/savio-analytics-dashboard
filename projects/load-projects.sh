#!/bin/bash

module load sqlite/3.25.2

FILE="BRC-Projects - All-Projects.tsv"
./prepare.sh "$FILE" > projects-cleaned.tsv
sqlite3 db.sqlite3 < import-projects.sql
