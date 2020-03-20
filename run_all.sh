#!/bin/bash

run=$1
run_dir="output/$run"
mkdir -p $run_dir

run_benchmark () {
    benchmark=$1
    script=$2
    cd $benchmark
    sudo bash ./$script
    cp lats.bin $run_dir/$benchmark.lats.bin
    printf "$benchmark: "
    ../utilities/parselats.py $run_dir/$benchmark.lats.bin
    cd ..
}

integrated="run.sh"
networked="run_networked.sh"

run_benchmark masstree $integrated
# run_benchmark shore $networked
run_benchmark img-dnn $networked
run_benchmark moses $networked
run_benchmark silo $networked
run_benchmark sphinx $networked
run_benchmark xapian $networked
