(deffacts init
  (map 5 5)
  (sokoban 2 0 none level 0 boxes b 1 0 deposits d 0 4 4)
  (obstacle 0 1)
  (max-depth 40)
)


;; Requirements:
;; Sokoban is not in the last colum
;; The S's right square isn't occupated(Obstacle, box or deposit)
;; We haven't finished the levels

(defrule right
  (sokoban ?sx ?sy ?last level ?level $?rest)
  (test (neq ?last left))
  (max-depth ?depth)
  (map ?width ?height)
  (test (< ?sx (- ?width 1)))
  (not (exists (obstacle =(+ ?sx 1) ?sy)))
  (not (exists (sokoban ? ? ? level ?level boxes $?rest1 b =(+ ?sx 1) ?sy $? deposits $?rest2)))
  (not (exists (sokoban ? ? ? level ?level boxes $? deposits $? d ? $?rest2 =(+ ?sx 1) ?sy $?)))
  (test (< ?level ?depth))
  =>
  (assert (sokoban (+ ?sx 1) ?sy right level (+ ?level 1) $?rest))
)


;; Requirements:
;; There is a box at the right of the Sokoban
;; The box is not in the last colum
;; The box's right square isn't occupated(Obstacle, box or deposit)
;; We haven't finished the levels

(defrule pushRight
  (sokoban ?sx ?sy ?last level ?level boxes $?rest1 b ?bx ?by $?rest2 deposits $?rest3)
  (test (eq ?bx (+ ?sx 1)))
  (test (eq ?by ?sy))
  (max-depth ?depth)
  (map ?width ?height)
  (test (< ?sx (- ?width 2)))
  (not (exists (obstacle =(+ ?bx 1) ?by)))
  (not (exists (sokoban ? ? ? level ?level boxes $?rest1 b =(+ ?bx 1) ?by $?rest2 deposits $?)))
  (not (exists (sokoban ? ? ? level ?level boxes $? deposits $? d ? $?rest3 =(+ ?bx 1) ?by $?)))
  (test (< ?level ?depth))
  =>
  (assert (sokoban (+ ?sx 1) ?sy pushRight level (+ ?level 1) boxes $?rest1 (+ ?bx 1) ?by deposits $?rest2))
)


;; Requirements:
;; Sokoban is not in the first colum
;; The S's left square isn't occupated(Obstacle, box or deposit)
;; We haven't finished the levels

(defrule left
  (sokoban ?sx ?sy ?last level ?level $?rest)
  (test (neq ?last right))
  (max-depth ?depth)
  (map ?width ?height)
  (test (> ?sx 0))
  (not (exists (obstacle =(- ?sx 1) ?sy)))
  (not (exists (sokoban ? ? ? level ?level boxes $?rest1 =(- ?sx 1) ?sy $? deposits $?rest2)))
  (not (exists (sokoban ? ? ? level ?level boxes $? deposits ? $?rest2 =(- ?sx 1) ?sy $?)))
  (test (< ?level ?depth))
  =>
  (assert (sokoban (- ?sx 1) ?sy left level (+ ?level 1) $?rest))
)


;; Requirements:
;; There is a box at the left of the Sokoban
;; The box is not in the first colum
;; The box's left square isn't occupated(Obstacle, box or deposit)
;; We haven't finished the levels

(defrule pushLeft
  (sokoban ?sx ?sy ?last level ?level boxes $?rest1 ?bx ?by deposits $?rest2)
  (test (eq ?bx (- ?sx 1)))
  (test (eq ?by ?sy))
  (max-depth ?depth)
  (map ?width ?height)
  (test (> ?sx 1))
  (not (exists (obstacle =(- ?bx 1) ?by)))
  (not (exists (sokoban ? ? ? level ?level boxes $?rest1 =(- ?bx 1) ?by $? deposits $?)))
  (not (exists (sokoban ? ? ? level ?level boxes $? deposits ? $?rest2 =(- ?bx 1) ?by $?)))
  (test (< ?level ?depth))
  =>
  (assert (sokoban (- ?sx 1) ?sy pushLeft level (+ ?level 1) boxes $?rest1 (- ?bx 1) ?by deposits $?rest2))
)


;; Requirements:
;; Sokoban is not in the first row
;; The S's top square isn't occupated(Obstacle, box or deposit)
;; We haven't finished the levels

(defrule top
  (sokoban ?sx ?sy ?last level ?level $?rest)
  (test (neq ?last bottom))
  (max-depth ?depth)
  (map ?width ?height)
  (test (> ?sy 0))
  (not (exists (obstacle ?sx =(- ?sy 1))))
  (not (exists (sokoban ? ? ? level ?level boxes $?rest1 ?sx =(- ?sy 1) $? deposits $?rest2)))
  (not (exists (sokoban ? ? ? level ?level boxes $? deposits ? $?rest2 ?sx =(- ?sy 1) $?)))
  (test (< ?level ?depth))
  =>
  (assert (sokoban ?sx (- ?sy 1) left level (+ ?level 1) $?rest))
)


;; Requirements:
;; There is a box above the Sokoban
;; The box is not in the first row
;; The box's left square isn't occupated(Obstacle, box or deposit)
;; We haven't finished the levels

(defrule pushTop
  (sokoban ?sx ?sy ?last level ?level boxes $?rest1 ?bx ?by deposits $?rest2)
  (test (eq ?bx ?sx))
  (test (eq ?by (- ?sy 1)))
  (max-depth ?depth)
  (map ?width ?height)
  (test (< ?sy 2))
  (not (exists (obstacle ?bx =(- ?by 1))))
  (not (exists (sokoban ? ? ? level ?level boxes $?rest1 ?bx =(- ?by 1) $? deposits $?)))
  (not (exists (sokoban ? ? ? level ?level boxes $? deposits ? $?rest2 ?bx =(- ?by 1) $?)))
  (test (< ?level ?depth))
  =>
  (assert (sokoban ?sx (- ?sy 1) pushBottom level (+ ?level 1) boxes $?rest1 ?bx (- ?by 1) deposits $?rest2))
)


;; Requirements:
;; Sokoban is not in the last row
;; The S's bottom square isn't occupated(Obstacle, box or deposit)
;; We haven't finished the levels

(defrule bottom
  (sokoban ?sx ?sy ?last level ?level $?rest)
  (test (neq ?last top))
  (max-depth ?depth)
  (map ?width ?height)
  (test (< ?sy (- ?height 1)))
  (not (exists (obstacle ?sx =(+ ?sy 1))))
  (not (exists (sokoban ? ? ? level ?level boxes $?rest1 ?sx =(+ ?sy 1) $? deposits $?rest2)))
  (not (exists (sokoban ? ? ? level ?level boxes $? deposits ? $?rest2 ?sx =(+ ?sy 1) $?)))
  (test (< ?level ?depth))
  =>
  (assert (sokoban ?sx (+ ?sy 1) bottom level (+ ?level 1) $?rest))
)


;; Requirements:
;; There is a box under the Sokoban
;; The box is not in the last row
;; The box's left square isn't occupated(Obstacle, box or deposit)
;; We haven't finished the levels

(defrule pushBottom
  (sokoban ?sx ?sy ?last level ?level boxes $?rest1 ?bx ?by deposits $?rest2)
  (test (eq ?bx ?sx))
  (test (eq ?by (+ ?sy 1)))
  (max-depth ?depth)
  (map ?width ?height)
  (test (< ?sy (- ?height 2)))
  (not (exists (obstacle ?bx =(+ ?by 1))))
  (not (exists (sokoban ? ? ? level ?level boxes $?rest1 ?bx =(+ ?by 1) $? deposits $?)))
  (not (exists (sokoban ? ? ? level ?level boxes $? deposits ? $?rest2 ?bx =(+ ?by 1) $?)))
  (test (< ?level ?depth))
  =>
  (assert (sokoban ?sx (+ ?sy 1) pushBottom level (+ ?level 1) boxes $?rest1 ?bx (+ ?by 1) deposits $?rest2))
)
