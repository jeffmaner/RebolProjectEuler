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

problem17: func [
  "How many letters will be used to write the numbers from 1 to 1000 in words?"

  /local numbers letter-counts n tens tens-letter-counts s] [
  numbers: parse "one two three four five six seven eight nine ten eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen" " "
  letter-counts: copy []
  for n 1 19 1 [
    append letter-counts length? numbers/(n)
  ]

  ;; Including "ten" here simplifies access to tens-letter-counts.
  tens: parse "ten twenty thirty forty fifty sixty seventy eighty ninety" " "
  tens-letter-counts: copy []
  for n 10 90 10 [
    append tens-letter-counts length? tens/(n / 10)
  ]

  letter-count: func [n [integer!] /local hundred-letters and-letters h r t] [
    hundred-letters: length? "hundred"
    and-letters: length? "and"

    if n > 99 [
      h: to-integer n / 100
      r: n // 100
      return
        letter-counts/(h) + hundred-letters + either r > 0
          [ and-letters + letter-count r ]
          [ 0 ]
    ]

    if n > 19 [
      t: to-integer n / 10
      r: n // 10
      return
        either r > 0
          [ tens-letter-counts/(t) + letter-count r ]
          [ tens-letter-counts/(n / 10) ]
    ]

    letter-counts/(n)
  ]

  s: 0
  for n 1 999 1 [
    s: s + letter-count n
  ]

  s: s + letter-counts/1 + length? "thousand"

  s
]

problem18: func [
  { Description: "Find the maximum total from top to bottom of the triangle."
    Inspired-by: http://www.mathblog.dk/project-euler-18/ }

  /local triangle length rows numbers n digits r c] [
  ;; Padded data/problem18 with zeros as described at mathblog.
  triangle: trim data/problem18

  length: 15

  ;; Convert triangle to rows of integers.

  rows: copy []

  ;; TODO: refactor splitting into lines.

  while [find triangle newline] [
    numbers: copy []

    for n 1 length 1 [
      digits: copy/part triangle 2
      append numbers to-integer digits
      triangle: skip triangle 3
    ]

    append rows reduce [numbers]
  ]

  for r length - 1 1 -1 [
    for c 1 r 1 [
      rows/(r)/(c): rows/(r)/(c) + max rows/(r + 1)/(c) rows/(r + 1)/(c + 1)
    ]
  ]

  rows/1/1
]

problem19: func [
  "How many Sundays fell on the first of the month during the twentieth century (1901 Jan 1 to 2000 Dec 31)?"

  /local years-in-century months-in-year days-in-week days-of-week d sundays] [
  ;; This is just too cool not to include. :P
  to-integer 100 * 12 / 7

  ;; Elaborating a little.
  years-in-century: 100
  months-in-year: 12
  days-in-week: 7

  to-integer years-in-century * months-in-year / days-in-week
  ;; That only works because the distribution of weekdays is uniform for this
  ;; time period.

  ;; But Rebol has some really cool date functionality. Let's use that.
  days-of-week: ["Mon" "Tue" "Wed" "Thu" "Fri" "Sat" "Sun"]
  d: 1901/Jan/01
  sundays: 0

  ;; Tried a for loop, and it was just a tad bit slower than this while loop.
  while [d <= 2000/Dec/31] [
    if (d/day = 1) and ("Sun" = pick days-of-week d/weekday) [
      sundays: sundays + 1
    ]

    d: d + 1
  ]

  sundays
]

problem20: func [
  "Find the sum of the digits in the number 100!."

  /local r n ds d] [
  ;; Use bignumbers.r, since Rebol won't give me the number without scientific notation.
  r: {1}
  for n 100 1 -1 [
    reverse r
    r: reverse multiply r to-string n
  ]

  ds: copy []
  foreach d r [
    append ds to-integer to-string d
  ]

  to-integer sum ds
]

problem21: func [
  "Evaluate the sum of all the amicable numbers under 10'000."

  ;/local limit ds n amicable-numbers dn ddn
  ;/local limit ds n amicable-numbers dn ddn
  ;/local limit amicable-sum n dn ddn
  /local limit ps amicable-sum n dn
] [
  ;; Four iterations follow, from sloppy and brute force to optimized.

  ;d: func [n [integer!]] [to-integer sum proper-divisors n]
  ;amicable-pair?: func [n [integer!] dn [integer!] ddn [integer!]] [(not dn = n) and (ddn = n)]

  limit: 10'000

  ;; Somewhat sloppy brute force approach:
  ;; =====================================
  ;ds: copy []
  ;for n 1 limit 1 [ append ds d n ]

  ;amicable-numbers: copy []
  ;for n 1 limit 1 [
  ;  dn: ds/(n)
  ;  ddn: ds/(dn)

  ;  if (not dn = n) and (ddn = n) [
  ;    append amicable-numbers n
  ;  ]
  ;]

  ;to-integer sum amicable-numbers ;; 1.156 seconds.

  ;; Less sloppy, but still brute force approach:
  ;; ============================================
  ;ds: copy []
  ;for n 1 limit 1 [ append ds d n ]

  ;amicable-numbers: copy []
  ;for n 1 limit 1 [
  ;  dn: ds/(n)

  ;  if (1 < dn) and (dn <= limit) [
  ;    ddn: ds/(dn)

  ;    if amicable-pair? n dn ddn [
  ;      append amicable-numbers n
  ;    ]
  ;  ]
  ;]

  ;to-integer sum amicable-numbers ;; 1.172 seconds.

  ;; A bit of optimization:
  ;; ======================
  ;amicable-sum: 0
  ;for n 2 limit 1 [
  ;  dn: d n

  ;  if (n < dn) and (dn <= limit) [
  ;    ddn: d dn

  ;    if ddn = n [
  ;      amicable-sum: amicable-sum + n + dn
  ;    ]
  ;  ]
  ;]

  ;amicable-sum ;; 1.391 seconds.

  ;; Further optimization (based on analysis at http://www.mathblog.dk/project-euler-21-sum-of-amicable-pairs/):
  ;; ============================================
  ps: primes-under limit

  d: func [n] [sum-of-proper-divisors n ps]

  amicable-sum: 0
  for n 2 limit 1 [
    dn: d n

    if (n < dn) and (dn <= limit) [
      if n = d dn [
        amicable-sum: amicable-sum + n + dn
      ]
    ]
  ]

  amicable-sum ;; 0.313 seconds.
]

problem22: func [
  "What is the sum of the name scores in the file?"

  /local names r n] [
  name-score: func [s [string!] /local x] [
    letter-score: func [c [char!]] [(to-integer c) + 1 - to-integer #"A"]
    x: 0
    foreach c s [x: x + letter-score c]
  ]

  names: sort parse read %names.txt none

  r: 0
  for n 1 length? names 1 [
    r: r + (n * name-score names/(n))
  ]

  r
]

problem23: func [
  { Find the sum of all the positive integers which cannot be written as the sum
of two abundant numbers. }

  /local limit ps abundants n sums-of-two-abundants? m i s] [
  ;; Inspired-by http://www.mathblog.dk/project-euler-23-find-positive-integers-not-sum-of-abundant-numbers/

  limit: 28'123

  ps: primes-under limit

  d: func [n] [sum-of-proper-divisors n ps]

  abundants: copy []
  for n 2 limit 1 [
    if n < d n [ append abundants n ]
  ]

  abundant-count: length? abundants

  sums-of-two-abundants?: copy array/initial limit false
  for m 1 abundant-count 1 [
    for n m abundant-count 1 [
      i: abundants/(m) + abundants/(n)

      if i > limit [
        break
      ]

      sums-of-two-abundants?/(i): true
    ]
  ]

  s: 0
  for n 1 limit 1 [
    if not sums-of-two-abundants?/(n) [
      s: s + n
    ]
  ]

  s ;; Yikes! 15.672 seconds.
]

problem24: func [
  { Description: "What is the millionth lexicographic permutation of the digits 0 through 9?"
    Inspired-by: http://www.mathblog.dk/project-euler-24-millionth-lexicographic-permutation/ }

  /local digits N r rem i fac-n j k] [
  ;; This is based on Kristian Edlund's combinatorial analysis of the problem.

  factorial: func [n [integer!]] [
    product naturals/to n
  ]

  remove-at: func [b [block!] n [integer!]] [
    b: head b

    for m 1 n 1 [
      b: next b
    ]

    remove b

    b: head b

    b
  ]

  digits: [ 0 1 2 3 4 5 6 7 8 9 ]
  N: length? digits
  r: copy ""
  rem: 1'000'000 - 1

  for i 1 N 1 [
    fac-n: factorial (N - i)
    j: to-integer rem / fac-n
    rem: remainder rem fac-n
    r: join r digits/(j + 1)
    digits: remove-at digits j

    if rem = 0 [ break ]
  ]

  for i 1 length? digits 1 [
    r: join r digits/(i)
  ]

  r
]
