REBOL [
  Title: "Project Euler Problem Exploration"
]

do load %ancillary.r
do load %bignumbers.r
do load %data.r

problem1: func [
  "Add all the Natural numbers below 1000 that are multiples of 3 or 5."
] [
  to-integer sum remove-each n naturals/to 999 [not ((n // 3) = 0) or ((n // 5) = 0)] ;; 233168.
]

problem2: func [
  "Find the sum of all the even-valued terms in the Fibonacci sequence under 4 million."

  /local fs m] [
  fs: copy [1 2]
  m: 4'000'000

  ;; Generate the rest of the required Fibonacci sequence.
  while [fs/(length? fs) < m] [
    append fs fs/((length? fs) - 1) + fs/(length? fs)
  ]

  remove-each f fs [odd? f]

  to-integer sum fs ;; 4613732.
]

problem3: func [
  "Find the largest prime factor of the composite number 600,851,475,143."
] [
  to-integer maximum prime-factors 600'851'475'143
]

problem4: func [
  "Find the largest palindrome made from the product of two 3-digit numbers."

  /local ps ns m n p] [
  ps: copy []
  ns: copy naturals/from/to 100 999

  foreach m ns [foreach n ns [append ps m * n]]

  remove-each p ps [not is-palindrome p]

  maximum ps ;; TODO: Takes one second.
]

problem5: func [
  { What is the smallest positive number that is evenly divisible by all of the
numbers from 1 to 20? }

  /local x ns] [
  x: 1. ;; Use decimal! to avoid integer! overflow.
  ns: naturals/to 20

  forall ns [x: lcm x ns/1]

  to-integer x
]

problem6: func [
  { Find the difference between the sum of the squares of the first one hundred
Natural numbers and the square of the sum. }

  /local ns squares] [
  square: func [n] [n ** 2]

  ns: copy naturals/to 100
  squares: copy []

  foreach n ns [append squares square n]

  to-integer abs (sum squares) - square sum ns
]

problem7: func [
  "What is the 10,001st prime number?"

  /local ps n] [
  ;; Using is-prime?/strong to test for primality of n takes 20 seconds to find solution.
  ;; Using prime-factors? to test for primality of n takes under four seconds to find solution.

  ps: copy []
  n: 0

  while [10'001 > length? ps] [
    n: n + 1

    if 1 = length? prime-factors n [
      append ps n ] ]

  last ps ]

problem8: func [
  { Find the thirteen adjacent digits in the 1000-digit number that have the
greatest product. What is the value of that product? }

  /local thousand-digit-number window ss dls ps] [
  to-list: func [s] [
    ns: copy []
    foreach c s [append ns to-decimal form c]

    ns ]

  thousand-digit-number: trim/all data/problem8
  window: 13

  ss: copy []
  while [window <= length? thousand-digit-number] [
    append ss copy/part thousand-digit-number window
    thousand-digit-number: next thousand-digit-number ]

  dls: copy []
  foreach s ss [
    append dls reduce [to-list s] ]

  ps: copy []
  foreach dl dls [
    append ps product dl ]

  decimal-to-big-natural maximum ps
]

problem9: func [
  { There exists exactly one Pythagorean triplet for which a + b + c = 1000.
Find the product abc. }

  /local m n r] [
  ;; https://en.wikipedia.org/wiki/Tree_of_primitive_Pythagorean_triples
  ;; https://en.wikipedia.org/wiki/Pythagorean_triple

  ;; coprime?: func [m n] [1 = gcd m n]
  ;; opposite-parity?: func [m n] [(odd? m and even? n) or (even? m and odd? m)]

  pythagorean-triple: func [m n] [
    a: to-integer (m ** 2) - (n ** 2)
    b: to-integer 2 * m * n
    c: to-integer (m ** 2) + (n ** 2)

    reduce [a b c]
  ]

  make-mns: func [m n /local v] [
    v: reduce [m n]

    reduce [
      v*m v [[2 -1]
             [1  0]]
      v*m v [[2 1]
             [1 0]]
      v*m v [[1 2]
             [0 1]]
    ]
  ]

  f: func [m n /local mns pts a b c i m' n' k] [
    mns: copy []
    mns: make-mns m n

    pts: copy []
    pts: reduce [pythagorean-triple mns/1/1 mns/1/2 pythagorean-triple mns/2/1 mns/2/2 pythagorean-triple mns/3/1 mns/3/2]

    a: b: c: 0
    s: 0

    for i 1 3 1 [
      m': mns/(i)/1
      n': mns/(i)/2

      for k 2 100 1 [
        a: k * pts/(i)/1
        b: k * pts/(i)/2
        c: k * pts/(i)/3

        if (a > 1000) or (b > 1000) or (c > 1000) [break]

        s: a + b + c

        if s = 1000 [break]
      ]

      if s = 1000 [break]
    ]

    reduce [a b c]
  ]

  m: 2
  n: 1

  r: f m n

  r/1 * r/2 * r/3
]

problem10: func [
  { Description: "Find the sum of all the primes below two million."
    Remarks: { Two million is too large for Rebol, apparently, so I've used a
segmented version of the sieve. } }

  /local ps lo delta hi] [

  ps: copy []

  lo: 1'000'000
  delta: 1'000'000 ;; Must divide hi - lo.
  hi: lo + delta

  ps: primes-under lo

  while [2'000'000'000 > hi] [
    ps: join ps primes-range lo hi delta

    lo: lo + delta
    hi: lo + delta
  ]

  decimal-to-big-natural sum ps
]

problem11: func [
  { What is the greatest product of four adjacent numbers in the same direction
(up, down, left, right, or diagonally) in the 20×20 grid? }

  /local grid rows numbers n digits products window-product r c d o ] [

  grid: trim data/problem11

  length: 20
  window:  4

  ;; Convert grid to rows of integers.

  rows: copy []

  while [find grid newline] [
    numbers: copy []

    for n 1 length 1 [
      digits: copy/part grid 2
      append numbers to-integer digits
      grid: skip grid 3
    ]

    append rows reduce [numbers]
  ]

  products: copy []

  window-product: 1

  ;; Take the windowed products along the rows.
  for r 1 length 1 [
    for c 1 length - window + 1 1 [
      for o 0 window - 1 1 [
        window-product: window-product * rows/(r)/(c + o)
      ]
      append products window-product
      window-product: 1
    ]
  ]

  ;; Take the windowed products along the columns.
  for c 1 length 1 [
    for r 1 length - window + 1 1 [
      for o 0 window - 1 1 [
        window-product: window-product * rows/(r + o)/(c)
      ]
      append products window-product
      window-product: 1
    ]
  ]

  ;; Take the windowed products along the diagonals from right-top to left-bottom starting at the left and moving to the right.
  for d window length 1 [
    for r 1 d - window + 1 1 [
      for c d window -1 [
        for o 0 window - 1 1 [
          window-product: window-product * rows/(r + o)/(c - o)
        ]
        append products window-product
        window-product: 1
      ]
    ]
  ]

  ;; Take the windowed products along the diagonals from left-top to right-bottom starting at the right and moving to the left.
  for d length - window + 1 1 -1 [
    for r 1 length - window + 1 - d + 1 1 [
      for c d length - window + 1 1 [
        for o 0 window - 1 1 [
          window-product: window-product * rows/(r + o)/(c + o)
        ]
        append products window-product
        window-product: 1
      ]
    ]
  ]

  maximum products
]

problem12: func [
  "What is the value of the first triangle number to have over five hundred divisors?"
  /local t n] [
  t: n: 1

  while [500 > length? divisors t] [
    n: n + 1
    t: t + n
  ]

  t ;; Runs in over a minute.
]

problem13: func [
  "Work out the first ten digits of the sum of the following one-hundred 50-digit numbers."

  /local text strings s numbers] [
  text: trim data/problem13
  strings: copy []
  numbers: copy []

  while [find text newline] [
    append strings reduce [copy/part text 50]
    text: skip text 50 + 1
  ]

  foreach s strings [
    append numbers to-decimal s
  ]

  copy/part replace to-string sum numbers "." "" 10
]

problem14: func [
  "Which starting number, under one million, produces the longest Collatz sequence?"

  /local n max-length starting-number m] [
  next-collatz-term: func [n [integer! decimal!]] [
    either even? n [
      n / 2
    ] [
      3 * n + 1
    ]
  ]

  collatz-sequence: func [n [integer! decimal!] /local ns m] [
    ns: reduce [n]
    m: n

    until [
      m: next-collatz-term m
      append ns m
      m = 1
    ]

    ns
  ]

  max-length: starting-number: 1

  for n 13. 999'999. 1. [
    m: length? collatz-sequence n
    if m > max-length [
      max-length: m
      starting-number: n
    ]
  ]

  to-integer starting-number ;; Runs in over two minutes.
]

problem15: func [
  "How many routes are there through a 20x20 grid from the top left corner to the bottom right corner?"
] [
  ;; http://theburningmonk.com/2010/09/project-euler-problem-15-solution/

  factorial: func [n [integer!]] [
    product naturals/to n
  ]

  combo: func [n [integer!] k [integer!]] [
    (factorial n) / ((factorial k) * factorial (n - k))
  ]

  decimal-to-big-natural combo 40 20
]

problem16: func [
  "What is the sum of the digits of the number 2 ^ 1000?"

  /local r i ds d] [
  ;; Use bignumbers.r, since Rebol won't give me the number without scientific notation.
  r: {1}
  for i 1 1000 1 [
    reverse r
    r: reverse multiply r {2}
  ]

  ds: copy []
  foreach d r [
    append ds to-integer to-string d
  ]

  to-integer sum ds
]
