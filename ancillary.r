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

  /local flags f k ps i] [

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

primes-range: func [
  { Description: "Returns the primes within the range using segments of size delta."
    Technique: "Segmented Sieve of Eratosthenes"
    Inspired-by: [ http://programmingpraxis.com/2010/02/05/segmented-sieve-of-eratosthenes/
                   http://stackoverflow.com/questions/10249378/segmented-sieve-of-eratosthenes ]
    Remarks: { My Rebol/View is complaining about Rebol 3 bitset! features.
               So, for now, I'll just use an array of booleans. } }

  lo    [integer! decimal!] "Low limit of range."
  hi    [integer! decimal!] "High limit of range."
  delta [integer! decimal!] "Size of segments."

  /local r ps qs qs' sieve i j t
] [
  q-init: func [p] [
    mod to-integer ((-1 / 2) * (lo + p + 1)) p
  ]
  q-reset: func [p q] [
    mod to-integer (q - delta) p
  ]

  r: copy []

  ps: primes-under to-integer square-root hi
  remove ps ;; Remove 2.

  qs: copy []
  foreach p ps [append qs q-init p]

  while [lo < hi] [
    sieve: copy array/initial delta true

    for i 1 length? ps 1 [
      for j (qs/(i) + 1) delta ps/(i) [
        change at sieve j false
      ]
    ]

    qs': copy []
    for i 1 length? ps 1 [
      append qs' q-reset ps/(i) qs/(i)
    ]

    qs: qs'

    i: 1
    t: lo + 1
    while [(i < delta) and (t < hi)] [
      if sieve/(i) [
        append r t
      ]

      i: i + 1
      t: t + 2
    ]

    lo: lo + (2 * delta)
  ]

  r
]
