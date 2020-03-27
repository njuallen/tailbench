#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${DIR}/../configs.sh

THREADS=1
QPS=100
WARMUPREQS=5000
MAXREQS=5000

BIN=./bin/moses_integrated

cp moses.ini.template moses.ini
sed -i -e "s#@DATA_ROOT#$DATA_ROOT#g" moses.ini

TBENCH_QPS=${QPS} TBENCH_MAXREQS=${MAXREQS} TBENCH_WARMUPREQS=${WARMUPREQS} \
    TBENCH_MINSLEEPNS=10000 ${BIN} -config ./moses.ini \
    -input-file ${DATA_ROOT}/moses/testTerms \
    -threads ${THREADS} -num-tasks 100000 -verbose 0 &

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
