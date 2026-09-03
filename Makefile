# compiler
CXX = c++

# compiler flags
# Note: changing compiler flag, requries changes in benchmark.sh and benchmark_line.gnuplot
CPPFLAGS = -Wall -O3
LDFLAGS =

all: naive cps

naive: naive.o args.o
	$(CXX) -o $@ $^ $(LDFLAGS)
# 	$(CXX) -o naive naive.o args.o $(LDFLAGS)

args.o: args.cpp
	$(CXX) $(CPPFLAGS) -c -o $@ $^
# 	$(CXX) $(CPPFLAGS) -c -o args.o args.cpp

naive.o: naive.cpp
	$(CXX) $(CPPFLAGS) -c -o $@ $^
# 	$(CXX) $(CPPFLAGS) -c -o naive.o naive.cpp

cps: cps.o args.o
	$(CXX) -o $@ $^ $(LDFLAGS)
# 	$(CXX) -o cps cps.o args.o $(LDFLAGS)

cps.o: cps.cpp args.h
	$(CXX) $(CPPFLAGS) -c -o $@ $<
# 	$(CXX) $(CPPFLAGS) -c -o cps.o cps.cpp




clean:
	rm -f naive naive.o cps cps.o args.o