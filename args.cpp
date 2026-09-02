#include "args.h"

#include <iostream>
#include <stdlib.h>

int parse_args(int argc, char const *argv[], long *n, int *default_value)
{
    if (argc <= 0)
    {
        std::cerr << "Usage: " << argv[0] << "[array-size] [default-value]" << std::endl;
        return 1;
    }

    if (argc > 1)
        *n = atol(argv[1]);
    if (argc > 2)
        *default_value = atoi(argv[2]);
    return 0;
}
