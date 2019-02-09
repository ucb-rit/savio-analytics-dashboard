#!/bin/bash

module load sqlite/3.25.2
sqlite3 db.sqlite3 < create-lookup-table.sql
