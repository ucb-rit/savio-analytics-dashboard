#!/bin/bash
SCRIPTS=$(dirname $0)
$SCRIPTS/projects/influx/show-jobs-influx-today.sh
$SCRIPTS/slurm/partition-usage-all.sh
