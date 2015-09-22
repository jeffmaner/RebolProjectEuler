Rebol [
    Title: "Prime Factors"
    Inspired-by: http://www.rebol.org/view-script.r?script=oneliner-prime-factors.r
]

prime-factors: func [
  { Returns a block of the prime factors of n.

    Limits: above 9'999'999'999'999'999, decimal rounding starts to make things a little arbitrary.
    Example: [Call: prime-factors 777'666'555'666'777
              Returns: [3 7 37 743 1347049607]]
    Bugs: prime-factors 0 and prime-factors 2 are "a bit dodgy".
  }

  n [integer! decimal!] "Natural number to factor."

  /local m s a
] [
  m: 2
  s: 1
  a: copy []

  until [
    either n // m = 0 [
      n: n / m
      append a m
    ] [
      m: m + s
      s: 2
    ]

    if 1. * m * m > n [
      append a n
      n: 1
    ]

    n = 1
  ]

  a
]
