REBOL [
  Title: "Project Euler Problem Runner"
  Usage: "do/args %run.r problems: [<series>]"
]

solutions: read/lines %Solutions.txt

do load %problems.r

foreach p problems [
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
