#!/usr/bin/env gnuplot
#
# Line plot of naive vs cps runtime across n, showing median with
# 25%/75% quartile brackets (the same stats a boxplot would show).
# Usage: gnuplot data/benchmark_line.gnuplot
# Produces: data/benchmark_line.png (via a data/benchmark_summary.csv intermediate)

set datafile separator ","

infile = "data/benchmark_o3.csv"
set output "data/benchmark_line_o3.png"
summary_file = "data/benchmark_summary.csv"
speedup_file = "data/benchmark_speedup.csv"

# unique, sorted n values present in the data
n_list = system(sprintf("awk -F, 'NR>1{print $2}' %s | sort -n -u | tr '\\n' ' '", infile))
n_count = words(n_list)
types = "naive cps"

set print summary_file
print "type,n,median,q25,q75"
array medians[2*n_count]
do for [ti=1:words(types)] {
    ty = word(types, ti)
    do for [i=1:n_count] {
        nv = word(n_list, i)
        stats infile using (strcol(1) eq ty && $2 == nv+0 ? $3 : 1/0) nooutput
        print sprintf("%s,%s,%.6f,%.6f,%.6f", ty, nv, STATS_median, STATS_lo_quartile, STATS_up_quartile)
        medians[(ti-1)*n_count+i] = STATS_median
    }
}
set print

# speedup = naive median / cps median, per n
set print speedup_file
print "n,speedup"
do for [i=1:n_count] {
    nv = word(n_list, i)
    naive_med = medians[i]
    cps_med   = medians[n_count+i]
    print sprintf("%s,%.6f", nv, naive_med/cps_med)
}
set print

set terminal pngcairo size 1400,600 enhanced font "Helvetica,12"

set multiplot layout 1,2

set title "Naive vs CPS benchmark runtime (-O3)"
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

set title "CPS speedup over naive (-O3)"
set xlabel "n"
set ylabel "speedup (naive / CPS)"
set logscale x
unset logscale y
set key top left
set grid

plot \
    speedup_file using 1:2 with linespoints lc rgb "#2ca02c" pt 7 title "speedup", \
    1 with lines lc rgb "#888888" dt 2 notitle

unset multiplot
