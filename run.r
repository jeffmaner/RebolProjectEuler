REBOL [
  Title: "Project Euler Problem Runner"
  Usage: { "do/args %run.r problems: 3"
           "do/args %run.r problems: [1 2 3 4]"
           "do/args %run.r problems: naturals/to 5"
           "do/args %run.r problems: naturals/from/to 3 9" }
]

solutions: read/lines %Solutions.txt

do load %problems.r

ps: copy []
ps: either series? problems [ problems ] [ append ps problems ]

foreach p ps [
  s: now/time/precise
  problem: do join "problem" to-string p
  e: now/time/precise
  elapsed: e - s

  solution: solutions/(p)

  status: either solution = to-string problem [
    "ok"
  ] [
    reduce ["FAIL: expected solution is" solution]
  ]

  print reduce [p problem rejoin ["(" status ")"] "in" elapsed "seconds."]
]
