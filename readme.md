Project Euler via Rebol
=======================

Synopsis
--------

My exploration of the [Project Euler][1] problem space via [Rebol][2].

I've mimicked the project structure I found [here][3].

Running the Problems
--------------------

From the Rebol/View Console:

```
    >> do/args %run.r problems: 3
```

runs problem 3.

```
    >> do/args %run.r problems: [1 2 3 4]
```

runs problems 1, 2, 3, and 4.

```
    >> do/args %run.r problems: naturals/to 5
```

runs problems 1, 2, 3, 4, and 5.

```
    >> do/args %run.r problems: naturals/from/to 3 9
```

runs problems 3, 4, 5, 6, 7, 8, and 9.

[1]: https://projecteuler.net/
[2]: https://en.wikipedia.org/wiki/Rebol
[3]: https://github.com/tokland/pyeuler
