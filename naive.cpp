#include "args.h"

#include <iostream>
#include <functional>
#include <vector>

using namespace std;

#define N 100

int inc(vector<int> &xs)
{
    for (int &x : xs)
    {
        x = x + 1;
    }
    return 0;
}

int dbl(vector<int> &xs)
{
    for (int &x : xs)
    {
        x = x * 2;
    }
    return 0;
}

int prt(const vector<int> &xs)
{
    // for (int x : xs)
    // {
    //     cout << x << ", ";
    // }
    // cout << endl;
    return 0;
}

int main(int argc, char const *argv[])
{
    /* argument parsing */
    long n = N;
    int default_value = 0;
    if (parse_args(argc, argv, &n, &default_value) != 0)
        return 1;

    /* array xs */
    vector<int> xs(n, default_value);

    /* sequential calling */
    inc(xs);
    dbl(xs);
    inc(xs);
    dbl(xs);
    prt(xs);

    return 0;
}
