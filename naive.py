import numpy as np

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
        print(f"{x}, ", end="")
    print("")


if __name__ == "__main__":
    xs = np.zeros(N, dtype=int)
    xs = inc(xs)
    xs = dbl(xs)
    prt(xs)
