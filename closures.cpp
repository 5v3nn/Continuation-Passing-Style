#include <iostream>
#include <stdlib.h>
#include <functional>

using namespace std;

function<void(int)> add(int x)
{
    return [x](int y)
    {
        cout << "x+y = " << x + y << endl;
    };
}

function<void(function<int(void)>)> add_func(int x)
{
    return [x](function<int(void)> y)
    {
        cout << "x+y() = " << x + y() << endl;
    };
}

/* return inc_inner a function that returns nothing, takes a function k of type K*/
function<void(K)> inc(OP op)
{
    return [&](K k)
    {
        op([&](int x)
           { k(x + 1); });
    };
}

function<void(function<void(int)>)> inc(function<void(function<void(int)>)> op) {}

int main(int argc, char const *argv[])
{
    auto curry_add = add(1);
    curry_add(3);

    auto y = []()
    { return 3; };
    auto curry_add_func = add_func(1);
    curry_add_func(y);

    return 0;
}
