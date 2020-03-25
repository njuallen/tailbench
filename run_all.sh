#!/bin/bash

run=$1
run_dir="$PWD/output/$run"
latency_output="$PWD/output/$run.out"
mkdir -p $run_dir

run_benchmark () {
    benchmark=$1
    script=$2
    lats_file=$3
    cd $benchmark
    # tailbench benchmarks can only use core 0 and 1
    taskset -c 0,1 bash ./$script
    cp $lats_file $run_dir/$benchmark.lats.bin
    printf "$benchmark: " >> $latency_output
    ../utilities/parselats.py $run_dir/$benchmark.lats.bin >> $latency_output
    cd ..
}

integrated="run.sh"
networked="run_networked.sh"
common_lats_file="lats.bin"

rm $latency_output
run_benchmark masstree $integrated $common_lats_file
run_benchmark moses $integrated $common_lats_file
run_benchmark shore $integrated "lats.int.bin"
run_benchmark img-dnn $integrated $common_lats_file
run_benchmark silo $integrated $common_lats_file
run_benchmark sphinx $integrated $common_lats_file
run_benchmark xapian $integrated $common_lats_file
