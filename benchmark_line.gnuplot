#!/usr/bin/env gnuplot
#
# Line plot of naive vs cps runtime across n, showing median with
# 25%/75% quartile brackets (the same stats a boxplot would show).
# Usage: gnuplot benchmark_line.gnuplot
# Produces: benchmark_line.png (via a benchmark_summary.csv intermediate)

set datafile separator ","

infile = "benchmark.csv"
summary_file = "benchmark_summary.csv"

# unique, sorted n values present in the data
n_list = system(sprintf("awk -F, 'NR>1{print $2}' %s | sort -n -u | tr '\\n' ' '", infile))
n_count = words(n_list)
types = "naive cps"

set print summary_file
print "type,n,median,q25,q75"
do for [ti=1:words(types)] {
    ty = word(types, ti)
    do for [i=1:n_count] {
        nv = word(n_list, i)
        stats infile using (strcol(1) eq ty && $2 == nv+0 ? $3 : 1/0) nooutput
        print sprintf("%s,%s,%.6f,%.6f,%.6f", ty, nv, STATS_median, STATS_lo_quartile, STATS_up_quartile)
    }
}
set print

set terminal pngcairo size 800,600 enhanced font "Helvetica,12"
set output "benchmark_line.png"

set title "naive vs cps benchmark runtime (median, IQR)"
set xlabel "n"
set ylabel "time (s)"
set logscale x
set logscale y
set key top left
set grid

plot \
    summary_file using (strcol(1) eq "naive" ? $2 : 1/0):3:4:5 with yerrorbars lc rgb "#1f77b4" pt 7 title "naive (median, IQR)", \
    ''            using (strcol(1) eq "naive" ? $2 : 1/0):3     with lines     lc rgb "#1f77b4" notitle, \
    summary_file using (strcol(1) eq "cps"   ? $2 : 1/0):3:4:5 with yerrorbars lc rgb "#ff7f0e" pt 7 title "cps (median, IQR)", \
    ''            using (strcol(1) eq "cps"   ? $2 : 1/0):3     with lines     lc rgb "#ff7f0e" notitle
