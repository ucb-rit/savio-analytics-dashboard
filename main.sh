#!/bin/bash
SCRIPTS=$(dirname $0)
$SCRIPTS/slurm/allocation.sh
$SCRIPTS/slurm/queue.sh
$SCRIPTS/slurm/node-state.sh
