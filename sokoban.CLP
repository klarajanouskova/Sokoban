(deffacts init
  (map 3 3)
  (sokoban 2 0 none level 0 boxes 1 0 deposits)
  (obstacle 0 1)
  (max-depth 25)
)


(defrule right
  (sokoban ?sx ?sy ?last level ?level $?rest)
  (test (neq ?last left))
  (max-depth ?depth)
  (map ?width ?height)
  (test (< ?sx (- ?width 1)))
  (not (exists (obstacle =(+ ?sx 1) ?sy)))
  (not (exists (sokoban ? ? ? level ?level boxes $?rest1 =(+ ?sx 1) ?sy $? deposits $?rest2)))
  (test (< ?level ?depth))
  =>
  (assert (sokoban (+ ?sx 1) ?sy right level (+ ?level 1) $?rest))
)

(defrule pushRight
  (sokoban ?sx ?sy ?last level ?level boxes $?rest1 ?bx ?by deposits $?rest2)
  (test (eq ?bx (+ ?sx 1)))
  (test (eq ?by ?sy))
  (max-depth ?depth)
  (map ?width ?height)
  (test (< ?sx (- ?width 2)))
  (not (exists (obstacle =(+ ?bx 1) ?by)))
  (test (< ?level ?depth))
  =>
  (assert (sokoban (+ ?sx 1) ?sy pushRight level (+ ?level 1) boxes $?rest1 (+ ?bx 1) ?by deposits $?rest2))
)

(defrule left
  (sokoban ?sx ?sy ?last level ?level $?rest)
  (test (neq ?last right))
  (max-depth ?depth)
  (map ?width ?height)
  (test (> ?sx 0))
  (not (exists (obstacle =(- ?sx 1) ?sy)))
  (not (exists (sokoban ? ? ? level ?level boxes $?rest1 =(- ?sx 1) ?sy $? deposits $?rest2)))
  (test (< ?level ?depth))
  =>
  (assert (sokoban (- ?sx 1) ?sy left level (+ ?level 1) $?rest))
)


(defrule pushLeft
  (sokoban ?sx ?sy ?last level ?level boxes $?rest1 ?bx ?by deposits $?rest2)
  (test (eq ?bx (- ?sx 1)))
  (test (eq ?by ?sy))
  (max-depth ?depth)
  (map ?width ?height)
  (test (> ?sx 1))
  (not (exists (obstacle =(- ?bx 1) ?by)))
  (test (< ?level ?depth))
  =>
  (assert (sokoban (- ?sx 1) ?sy pushLeft level (+ ?level 1) boxes $?rest1 (- ?bx 1) ?by deposits $?rest2))
)


(defrule top
  (sokoban ?sx ?sy ?last level ?level $?rest)
  (test (neq ?last bottom))
  (max-depth ?depth)
  (map ?width ?height)
  (test (> ?sy 0))
  (not (exists (obstacle ?sx =(- ?sy 1))))
  (not (exists (sokoban ? ? ? level ?level boxes $?rest1 ?sx =(- ?sy 1) $? deposits $?rest2)))
  (test (< ?level ?depth))
  =>
  (assert (sokoban ?sx (- ?sy 1) left level (+ ?level 1) $?rest))
)


(defrule pushTop
  (sokoban ?sx ?sy ?last level ?level boxes $?rest1 ?bx ?by deposits $?rest2)
  (test (eq ?bx ?sx))
  (test (eq ?by (- ?sy 1)))
  (max-depth ?depth)
  (map ?width ?height)
  (test (< ?sy 2))
  (not (exists (obstacle ?bx =(- ?by 1))))
  (test (< ?level ?depth))
  =>
  (assert (sokoban ?sx (- ?sy 1} pushBottom level (+ ?level 1) boxes $?rest1 ?bx (- ?by 1) deposits $?rest2))
)

(defrule bottom
  (sokoban ?sx ?sy ?last level ?level $?rest)
  (test (neq ?last top))
  (max-depth ?depth)
  (map ?width ?height)
  (test (< ?sy (- ?height 1)))
  (not (exists (obstacle ?sx =(+ ?sy 1))))
  (not (exists (sokoban ? ? ? level ?level boxes $?rest1 ?sx =(+ ?sy 1) $? deposits $?rest2)))
  (test (< ?level ?depth))
  =>
  (assert (sokoban ?sx (+ ?sy 1) bottom level (+ ?level 1) $?rest))
)

(defrule pushBottom
  (sokoban ?sx ?sy ?last level ?level boxes $?rest1 ?bx ?by deposits $?rest2)
  (test (eq ?bx ?sx))
  (test (eq ?by (+ ?sy 1)))
  (max-depth ?depth)
  (map ?width ?height)
  (test (< ?sy (- ?height 2)))
  (not (exists (obstacle ?bx =(+ ?by 1))))
  (test (< ?level ?depth))
  =>
  (assert (sokoban ?sx (+ ?sy 1} pushBottom level (+ ?level 1) boxes $?rest1 ?bx (+ ?by 1) deposits $?rest2))
)