#!/usr/bin/env gnuplot
#
# Boxplot comparing naive vs cps runtimes from benchmark.csv
# Usage: gnuplot benchmark.gnuplot
# Produces: benchmark_boxplot.png

set datafile separator ","
set terminal pngcairo size 800,600 enhanced font "Helvetica,12"
set output "benchmark_boxplot.png"

set title "naive vs cps benchmark runtime"
set ylabel "time (s)"

set style data boxplot
set style boxplot outliers pointtype 7
set style fill solid 0.5 border -1
set boxwidth 0.5

set xrange [0.5:2.5]
set xtics ("naive" 1, "cps" 2)

plot \
    'benchmark.csv' using (strcol(1) eq "naive" ? 1 : 1/0):3 notitle lc rgb "#1f77b4", \
    ''               using (strcol(1) eq "cps"   ? 2 : 1/0):3 notitle lc rgb "#ff7f0e"
