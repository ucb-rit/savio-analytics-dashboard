#!/bin/bash

BASEDIR=$(dirname $0)

# SQL Injection shouldn't be a problem because account names, 
# which are set by admin, are inserted here
# Just to be safe, filter for only alphanumeric + underscore
# DB_PATH="/global/home/groups/scs/telegraf/db.sqlite3"
DB_PATH="/global/home/users/nicolaschan/savio-analytics-dashboard/projects/db.sqlite3"
PROJECT=$(sed 's/[^a-zA-Z0-9_]//g' <<< "$1")
SQL_STATEMENT="SELECT department FROM lookup WHERE project = \"$1\" LIMIT 1;"
RESULT=$(sqlite3 "$DB_PATH" "$SQL_STATEMENT")

echo $RESULT
