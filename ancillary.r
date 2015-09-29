REBOL [
  Title: "Ancillary Functions to Support Solutions"
  Author: "Jeff Maner"
]

;; Load ancillary functions provided by others.
do load %prime-factors.r
do load %sum-and-product.r

;; Define my own ancillary functions.

naturals: func [
  "Generate a sequence of Natural numbers."

  /from base  "Start enumeration of Naturals from base or one."
  /to   limit "Enumerate Naturals up to limit or 2 ** 32 - 1."

  /local result n
] [
  b: either base  [base]  [1]
  m: either limit [limit] [2 ** 32 - 1]

  result: copy []

  repeat n (m - b + 1) [append result n + b - 1]

  result
]

maximum: func [
  "Behaves the way maximum-of should behave."

  series "The series over which to take the maximum."
] [
  first maximum-of series
]

is-palindrome: func [
  "Determine whether Natural n is palindromic."

  n [integer!] "Natural to test."

  /local s] [
  ;; This seems to be faster than the next.
  s: form n
  s = reverse copy s

  ;; This seems to be slower than the previous.
  ;; (form n) = (reverse form n)
]

gcd: func [
  { Returns the greatest common divisor of m and n.
Inspired-by: http://rosettacode.org/wiki/Greatest_common_divisor#REBOL }

  m [integer! decimal!]
  n [integer! decimal!]

  /local k
] [
  ; Euclid's algorithm
  while [n > 0] [
    k: m
    m: n
    n: k // m
  ]

  m
]

lcm: func [
  "Returns the least common multiple of m and n."

  m [integer! decimal!]
  n [integer! decimal!]
] [
  m * n / gcd m n
]

v*m: func [
  "Multiply vector v by matrix m."

  v "Vector"
  m "Matrix"

  /local sums row-sum] [
  sums: copy []

  foreach r m [
    row-sum: 0
    for c 1 length? r 1 [
      row-sum: row-sum + (r/(c) * v/(c))
    ]

    append sums row-sum
  ]

  sums
]

primes-under: func [
  { Description: "Returns the primes under limit."
    Technique: "Sieve of Eratosthenes"
    Inspired-by: http://www.scriptol.com/programming/sieve.php#rebol }

  limit [integer! decimal!] "Return all primes under this limit."

  /local flags f k ps] [

  flags: copy array/initial limit 1

  for i 2 to-integer square-root limit 1 [
    f: pick flags 1
    if f = 1 [
      k: i + i
      while [k <= limit] [
        change at flags k 0
        k: k + i
      ]
    ]
  ]

  ps: copy []
  for i 2 (length? flags) - 1 1 [
    if 1 = flags/(i) [
      append ps i
    ]
  ]

  ps
]

primes-under': func [
  { Description: "Returns the primes under limit."
    Technique: "Segmented Sieve of Eratosthenes"
    Inspired-by: [
      http://www.scriptol.com/programming/sieve.php#rebol
      https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes#Segmented_sieve ] }

  limit [integer! decimal!] "Return all primes under this limit."

  /local delta flags f k ps] [

  delta: to-integer square-root limit

  flags: copy array/initial delta 1

  for i 2 delta 1 [
    f: pick flags 1
    if f = 1 [
      k: i + i
      while [k <= delta] [
        change at flags k 0
        k: k + i
      ]
    ]
  ]

  ps: copy []
  for i 2 (length? flags) - 1 1 [
    if 1 = flags/(i) [
      append ps i
    ]
  ]

  for delta-block 2 limit / delta 1 [
    flags: copy array/initial delta 1

    d: delta * (delta-block - 1)
    foreach p ps [
      for i (d + 1) (d + delta) 1 [
        f: pick flags 1
        if f = 1 [
          k: i + i
          while [k <= delta] [
            change at flags k 0
            k: k + i
          ]
        ]
      ]
    ]
  ]

  ps
]

