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
