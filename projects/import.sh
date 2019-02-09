#!/bin/bash

rm db.sqlite3
./load-projects.sh
./load-requests.sh
./create-lookup-table.sh
