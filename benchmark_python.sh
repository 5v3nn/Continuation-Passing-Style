#!/usr/bin/env bash
set -euo pipefail

make clean
make all

REP=10
#  10e3  10e4   10e5    10e6     10e7      10e8       10e9
N=(1000 10000 100000 1000000 10000000 100000000 1000000000)
DEFAULT_VALUE=4

# note: changes here in compiler optimization flag require changes in benchmark_line.gnuplot as well
OUT="data/benchmark_py.csv"
echo "type,n,t" > "$OUT"

run_and_time() {
    local n=$1
    shift
    local start end
    start=$(date +%s.%N)
    "$@" "-n" "$n" "-d" "$DEFAULT_VALUE" >/dev/null
    end=$(date +%s.%N)
    awk "BEGIN { printf \"%.4f\", $end - $start }"
}

for n in ${N[@]}; do
    for i in $(seq "$REP"); do
        echo "run: n=$n, rep=$i"
        t=$(run_and_time "$n" python3 ./naive.py)
        echo "naive,${n},${t}" >> "$OUT"
        #echo "naive,${n},${t}"

        t=$(run_and_time "$n" python3 ./cps.py)
        echo "cps,${n},${t}" >> "$OUT"
        #echo "cps,${n},${t}"
    done
done

column -s, -t "$OUT"

gnuplot benchmark_line.gnuplot