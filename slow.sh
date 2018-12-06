#!/bin/bash
SCRIPTS=$(dirname $0)
$SCRIPTS/projects/show-jobs-today.sh
$SCRIPTS/slurm/partition-usage-all.sh
