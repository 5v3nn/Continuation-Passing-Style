#include "args.h"

#include <iostream>
#include <functional>
#include <vector>

using namespace std;

#define N 100

/* The problem:
 * std::function is a type-erased wrapper — it hides the concrete lambda type
 * behind a common interface (conceptually a vtable + a heap-allocated
 * closure). That's the whole point of std::function: any callable with the
 * right signature fits. But the price is that the compiler, at the call site
 * k(x), only knows "call something through this interface" — not which lambda.
 * It cannot see through the wrapper to inline the body. inline on inc/dbl
 * (line 17) is a lie the compiler is allowed to ignore for exactly this
 * reason — inlining requires knowing the callee's body at the call site, and
 * function<void(int)>::operator() dispatches through a function pointer
 * resolved at runtime. */

/* continuation function K of type function <that returns nothing (takes an integer)> */
using K = function<void(int)>;
/* operation OP is a function <that returns nothing (takes a continuation function K)> */
using OP = function<void(K)>;

/* return inc_inner a function that returns nothing, takes a function k of type K*/
function<void(K)> inc(OP op)
{
    return [op](K k)
    {
        op([k](int x)
           { k(x + 1); });
    };
}

function<void(K)> dbl(OP op)
{
    return [op](K k)
    {
        op([k](int x)
           { k(x * 2); });
    };
}

void prt(int x)
{
    // cout << x << ", ";
}

function<void(K)> scan(const vector<int> &xs)
{
    /* xs can be const, because values never modified (modifications never
     * written back to xs, only printed) */
    /* cannot capture by reference (`[&]`), because scan's stack is destroyed
     * and then `xs` reference is meaningless. */
    return [xs](K k)
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

    /* array xs */
    vector<int> xs(n, default_value);

    // scan(xs)(prt);
    // inc(scan(xs))(prt);
    dbl(inc(scan(xs)))(prt);
    cout << endl;

    return 0;
}
