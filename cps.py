import numpy as np
import argparse

N = 100


def inc(op):
    def inc_inner(k):
        op(lambda x: k(x + 1))

    return inc_inner


def dbl(op):
    def dbl_inner(k):
        op(lambda x: k(x * 2))

    return dbl_inner


def prt(x):
    ##print(f"{x}, ", end="")
    pass


def scan(xs: list[int]):
    # currying
    # closed over xs
    # is basically op(k) now
    def scn_inner(k):
        for x in xs:
            k(x)

    return scn_inner


def _parse_args():
    parser = argparse.ArgumentParser(prog="cps.py", description="CPS implementation")

    parser.add_argument("-n", default=N, type=int, help="array size")
    parser.add_argument("-d", default=0, type=int, help="default value for the array")

    args = parser.parse_args()
    return args


if __name__ == "__main__":
    args = _parse_args()
    xs = [int(args.d)] * args.n

    dbl(inc(dbl(inc(scan(xs)))))(prt)
    print("")
