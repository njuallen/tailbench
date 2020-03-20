#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${DIR}/../configs.sh

# 必须要specify一下这个libxapian.so的位置，不然在启动程序时，它在通用的位置找不到它
export LD_LIBRARY_PATH=~/kernel_interference/tailbench/tailbench-v0.9/xapian/xapian-core-1.2.13/install/lib

NSERVERS=1
QPS=500
WARMUPREQS=1000
REQUESTS=5000

TBENCH_QPS=${QPS} TBENCH_MAXREQS=${REQUESTS} TBENCH_WARMUPREQS=${WARMUPREQS} \
       TBENCH_MINSLEEPNS=100000 TBENCH_TERMS_FILE=${DATA_ROOT}/xapian/terms.in \
       chrt -r 99 ./xapian_integrated -n ${NSERVERS} -d ${DATA_ROOT}/xapian/wiki -r 1000000000

