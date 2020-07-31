#!/bin/bash

if [[ -z "${NTHREADS}" ]]; then NTHREADS=1; fi

QPS=2000
MAXREQS=50000
WARMUPREQS=14000

TBENCH_QPS=${QPS} TBENCH_MAXREQS=${MAXREQS} TBENCH_WARMUPREQS=${WARMUPREQS} \
    TBENCH_MINSLEEPNS=10000 ./mttest_integrated -j${NTHREADS} \
    mycsba masstree &

echo $! > integrated.pid

# performance monitoring
../utilities/performance_monitor.sh $(cat integrated.pid)
rm integrated.pid
