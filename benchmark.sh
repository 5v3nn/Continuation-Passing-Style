#!/usr/bin/env bash
set -euo pipefail

make clean
make all

REP=10
WARMUP=1
N=(1000 10000 100000 1000000 10000000 100000000 1000000000 10000000000 100000000000)
DEFAULT_VALUE=4
STEP=2

OUT="benchmark.csv"
echo "type,n,t" > "$OUT"

run_and_time() {
    local prog=$1
    local n=$2
    local start end
    start=$(date +%s.%N)
    "$prog" "$n" "$DEFAULT_VALUE" "$STEP" >/dev/null
    end=$(date +%s.%N)
    awk "BEGIN { printf \"%.4f\", $end - $start }"
}

for i in $(seq "$WARMUP"); do
    run_and_time ./naive "${N[0]}" >/dev/null
    run_and_time ./cps "${N[0]}" >/dev/null
done

for n in ${N[@]}; do
    for i in $(seq "$REP"); do
        echo "run: n=$n, rep=$i"
        t=$(run_and_time ./naive $n)
        echo "naive,${n},${t}" >> "$OUT"
        #echo "naive,${n},${t}"

        t=$(run_and_time ./cps $n)
        echo "cps,${n},${t}" >> "$OUT"
        #echo "cps,${n},${t}"
    done
done

column -s, -t "$OUT"

gnuplot benchmark_line.gnuplot