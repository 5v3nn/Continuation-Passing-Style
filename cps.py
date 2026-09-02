import numpy as np

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
    print(f"{x}, ", end="")


def scan(xs: list[int]):
    # currying
    # closed over xs
    # is basically op(k) now
    def scn_inner(k):
        for x in xs:
            k(x)

    return scn_inner


if __name__ == "__main__":
    xs = [4, 4, 4, 4]
    # inc(scan(xs), prt)
    # dbl(inc(scan(xs)), prt)
    # scan(xs)(prt)
    inc(scan(xs))(prt)
    # dbl(inc(scan(xs)))(prt)
    print("")
