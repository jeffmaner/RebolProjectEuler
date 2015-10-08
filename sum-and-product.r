REBOL [
  Title: "Sum and Product"
  Inspired-by: https://github.com/acmeism/RosettaCodeData/blob/master/Task/Sum-and-product-of-an-array/REBOL/sum-and-product-of-an-array.rebol
]

sum: func [a [block!] /local x] [x: to-decimal 0  forall a [x: x + a/1]  x]
product: func [a [block!] /local x] [x: to-decimal 1  forall a [x: x * a/1]  x]

redux: func [
	"Applies an operation across an array to produce a reduced value."

	a [block!] "Array to operate on."
	op [word!] "Operation to perform."

	/init x    "Initial value (default 0)."
] [if not init [x: 0]  forall a [x: do compose [x (op) (a/1)]]  x]

rsum: func [a [block!]][redux a '+]

rproduct: func [a [block!]][redux/init a '* 1]

; Tests:

;assert: func [code][print [either do code ["  ok"]["FAIL"]  mold code]]

;print "Simple dedicated functions:"
;assert [55      = sum [1 2 3 4 5 6 7 8 9 10]]
;assert [3628800 = product [1 2 3 4 5 6 7 8 9 10]]

;print [crlf "Fancy reducing function:"]
;assert [55      = rsum [1 2 3 4 5 6 7 8 9 10]]
;assert [3628800 = rproduct [1 2 3 4 5 6 7 8 9 10]]
