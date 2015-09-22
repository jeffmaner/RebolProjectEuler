REBOL [
  Title: "Project Euler Problem Exploration"
]

do load %data.r
do load %ancillary.r

problem1: func [
  "Add all the Natural numbers below 1000 that are multiples of 3 or 5."
] [
  sum remove-each n naturals/to 999 [not ((n // 3) = 0) or ((n // 5) = 0)] ;; 233168.
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

  sum fs ;; 4613732.
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

  r: to-string maximum ps

  copy/part r find r "." ]
