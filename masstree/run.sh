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
../utilities/pidstat.sh $(cat integrated.pid) &
echo $! > pidstat.pid
../utilities/ps.sh $(cat integrated.pid) &
echo $! > ps.pid
../utilities/vmstat.sh &
echo $! > vmstat.pid

wait $(cat integrated.pid)
rm integrated.pid pidstat.pid ps.pid vmstat.pid
kill $(jobs -p)
# vmstat会spawn一个子进程，但是不知道为什么，它不会会被上面的kill杀掉
# 所以 我们干脆手动来把它给杀了
pkill -9 -x vmstat
