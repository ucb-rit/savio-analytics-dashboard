#!/bin/bash

BASEDIR=$(dirname $0)
PROJECT=$1
SQL_STATEMENT="SELECT project, email, department FROM lookup WHERE project = \"$1\";"

RESULT=$(sqlite3 /global/home/groups/scs/telegraf/db.sqlite3 "$SQL_STATEMENT")
# RESULT=$(sqlite3 $BASEDIR/db.sqlite3 "$SQL_STATEMENT")

echo -n $RESULT
