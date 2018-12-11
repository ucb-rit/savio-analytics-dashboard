#!/bin/bash
$1 | awk "{ print \$0 \" $(date +%s000000000)\"; }"
