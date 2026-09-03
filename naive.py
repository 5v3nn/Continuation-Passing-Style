import numpy as np
import argparse

N = 100


def inc(xs: list[int]):
    xs2 = []
    for x in xs:
        xs2.append(x + 1)
    return xs2


def dbl(xs: list[int]):
    xs2 = []
    for x in xs:
        xs2.append(x * 2)
    return xs2


def prt(xs: list[int]):
    for x in xs:
        continue
        # print(f"{x}, ", end="")
    print("")


def _parse_args():
    parser = argparse.ArgumentParser(
        prog="naive.py", description="Naive implementation"
    )

    parser.add_argument("-n", default=N, type=int, help="array size")
    parser.add_argument("-d", default=0, type=int, help="default value for the array")

    args = parser.parse_args()
    return args


if __name__ == "__main__":
    args = _parse_args()
    xs = [int(args.d)] * args.n

    xs = np.zeros(N, dtype=int)
    xs = inc(xs)
    xs = dbl(xs)
    prt(xs)
