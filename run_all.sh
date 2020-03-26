#!/bin/bash

run=$1
run_dir="$PWD/output/$run"
latency_output="$PWD/output/$run.out"
mkdir -p $run_dir

run_benchmark () {
    benchmark=$1
    script=$2
    cd $benchmark
    # tailbench benchmarks can only use core 0 and 1
    taskset -c 0,1 bash ./$script

    echo "------------------------------------" >> $latency_output
    echo "$benchmark:" >> $latency_output
    ../utilities/parselats.py lats.bin >> $latency_output

    cp lats.bin $run_dir/$benchmark.lats.bin
    cp lats.txt $run_dir/$benchmark.lats.txt
    cd ..
}

integrated="run.sh"
networked="run_networked.sh"

rm $latency_output
run_benchmark masstree $integrated
run_benchmark moses $integrated
run_benchmark shore $integrated
run_benchmark img-dnn $integrated
run_benchmark silo $integrated
run_benchmark sphinx $integrated
run_benchmark xapian $integrated
