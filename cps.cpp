#include "args.h"

#include <iostream>
#include <functional>
#include <vector>

using namespace std;

#define N 100

template <class T>
auto inc(T op)
{
    return [op](auto k)
    { op([k](int x)
         { k(x + 1); }); };
}

template <class T>
auto dbl(T op)
{
    return [op](auto k)
    { op([k](int x)
         { k(x * 2); }); };
}

void prt(int x)
{
    // cout << x << ", ";
}

auto scan(const vector<int> &xs)
{
    return [xs](auto k)
    {
        for (int x : xs)
        {
            k(x);
        }
    };
}

int main(int argc, char const *argv[])
{
    /* argument parsing */
    long n = N;
    int default_value = 0;
    if (parse_args(argc, argv, &n, &default_value) != 0)
        return 1;

    cout << "n:" << n << endl;

    /* array xs */
    vector<int> xs(n, default_value);

    // scan(xs)(prt);
    // inc(scan(xs))(prt);
    dbl(inc(dbl(inc(scan(xs)))))(prt);
    cout << endl;

    return 0;
}
