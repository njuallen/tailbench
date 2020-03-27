#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${DIR}/../configs.sh

THREADS=1
AUDIO_SAMPLES='audio_samples'

LD_LIBRARY_PATH=./sphinx-install/lib:${LD_LIBRARY_PATH} \
    TBENCH_QPS=1 TBENCH_MAXREQS=25 TBENCH_WARMUPREQS=10 TBENCH_MINSLEEPNS=10000 \
    TBENCH_AN4_CORPUS=${DATA_ROOT}/sphinx TBENCH_AUDIO_SAMPLES=${AUDIO_SAMPLES} \
    ./decoder_integrated -t $THREADS &

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
