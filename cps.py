import numpy as np

N = 100


def inc(op):
    def inner(k):
        # op(lambda x: k(x + 1))
        def f(x):
            return k(x + 1)

        op(f)

    return inner


def dbl(op):
    def inner(k):
        op(lambda x: k(x * 2))

    return inner


def prt(x):
    print(f"{x}, ", end="")


def scan(xs: list[int]):
    # currying
    # closed over xs
    # is basically op(k) now
    def inner(k):
        for x in xs:
            k(x)

    return inner


if __name__ == "__main__":
    xs = [4, 4, 4, 4]
    # inc(scan(xs), prt)
    # dbl(inc(scan(xs)), prt)
    # scan(xs)(prt)
    inc(scan(xs))(prt)
    # dbl(inc(scan(xs)))(prt)
    print("")
