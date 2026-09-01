# Continuation Passing Style

A while ago I found the following blog post [https://remy.wang/blog/cps.html](https://remy.wang/blog/cps.html). In order to understand this in more detail I wanted to implement the continuation-passing style (CPS) here in C++.

## Motivation

In a database, or a general data pipeline for that matter, we might want to chain operations on the data. Instead of doing one operation at a time on the whole array of data, we want to try do combine the operations, such that only one pass through the array is neccesary.

### Naive Way

The naive way would be to do one operation on the whole array, save the intermediate results, and then continue with the next operation. Consider the following example from the blogpost.

```julia
inc(xs) = [x + 1 for x in xs]

dbl(xs) = [2 * x for x in xs]
```

A full Python example can be found in [./python/naive.py](./python/naive.py):

```python
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
```

We can observe that there are basically 3 loops through the array `xs`. One for `inc`, one for `dbl`, and one for `prt`. Would it not be nice to write

```julia
inc_n_dbl(xs) = [2 * (x + 1) for x in xs]
```

instead?

But this is not feasible to write every possible combination. Therefore, something else is needed.

## Background

This section describes the mathematical background needed.

### Closures

TODO

### Currying

The following is a function that takes two arguments (*a,b*) and returns a value *c*:

$$ f(a,b) = a+b. $$

The function can be defined as:

$$ f: (A \times B) \rightarrow C. $$

The Python equivalent is

```python
# normal function
def f(a, b):
    return a+b

f(1, 3)  # = 1+3 = 4
```

Currying describes the mathematical concept of a function that has one argument, but still expects another argument in order to return. Instead of expecting two arguments, only one is expected. And instead of returning a value, a function is returned, that takes one argument (*b* in this case) and returns *c*.

$$ f(a)=\lambda b.(a+b) \equiv f: A \rightarrow (B\rightarrow C) $$

This reads as "*f* of *a* is the function that takes *b* and returns *a+b*".

The above can be written as the following as well:

$$ \begin{align*} g(b) &= a+b \\ f(a) &= g \end{align*}$$

Thus:

$$ f(a)(b) = g(b) =  a+b$$

Python (or Julia) does not natively support currying. We have to use closures for this.

```python
def f(a):
    def g(b):
        return a + b
    return g

f(1)(3)  # = g(3) = 1+3 = 4

# we can also write more explicitly:
g = f(1)
g(3)  # = 1+3 = 4
```

Note how this Python example illustrates nicely how `g` is closed over `a`. `g` remembers the parameter `a`.

We could also write this Python example with lambda functions:

```python
def f(a):
    return lambda b: a + b

f(1)(3)
```
