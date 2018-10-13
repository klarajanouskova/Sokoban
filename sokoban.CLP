

  ; ----- INIT MAP -----
(deffunction init_map ()
  (assert(map 5 5))
  (assert(sokoban 2 0 none level 0 boxes b 1 0 deposits d 4 4 0))
  (assert(obstacle 0 1))
 ) 

; ----- INIT -----
;; get the search strategy from the user
  (defrule init 
 (initial-fact)
	=>
 (printout t "Maximum depth: " )
 (bind ?prof (read))
 (printout t "Search strategy: " crlf "    1.- Breadth" crlf "    2.- Depth" crlf )
 (bind ?a (read))
 (if (= ?a 1)
    then    (set-strategy breadth)
	else   (set-strategy depth))
  (printout t " Exexute run to start the program. " crlf)  
  (assert (max-depth ?prof))
  (init_map)
 )

 ; ----- RIGHT-----
;; Requirements:
;; Sokoban is not in the last colum
;; The S's right square isn't occupated(Obstacle, box or deposit)
;; We haven't finished the levels

(defrule right
  (sokoban ?sx ?sy ?last level ?level boxes $?boxes deposits $?deposits)
  (test (neq ?last left))

  (max-depth ?depth)
  (map ?width ?height)
  (test (< ?sx (- ?width 1)))

  (not (obstacle =(+ ?sx 1) ?sy))
  (not (member$ (create$ b (+ ?sx 1) ?sy) $?boxes))
  (not (member$ (create$ d (+ ?sx 1) ?sy) $?deposits))
  
  (test (< ?level ?depth))
  
  =>
  (assert (sokoban (+ ?sx 1) ?sy right level (+ ?level 1) $?))
)


; ----- PUSH RIGHT -----
;; Requirements:
;; There is a box at the right of the Sokoban
;; The box is not in the last colum
;; The box's right square isn't occupated(Obstacle, box or deposit)
;; We haven't finished the levels

(defrule pushRight
  (sokoban ?sx ?sy ?last level ?level boxes $?boxes1 b ?bx ?by $?boxes2 deposits $?deposits)
  (test (eq ?bx (+ ?sx 1)))
  (test (eq ?by ?sy))
  
  (max-depth ?depth)
  (map ?width ?height)
  (test (< ?sx (- ?width 2)))
  
  (not (obstacle =(+ ?sx 2) ?sy))
  (not (sokoban ? ? ? level ?level boxes $?boxes1 b =(+ ?sx 2) ?sy $?boxes2 deposits $?))
  (not (member$ (create$ d =(+ ?sx 2) ?sy) $deposits))
  
  (test (< ?level ?depth))
  
  =>
  
  (assert (sokoban (+ ?sx 1) ?sy pushRight level (+ ?level 1) boxes $?boxes1 (+ ?bx 1) ?by $?boxes2 deposits $?deposits))

)


; ----- LEFT -----
;; Requirements:
;; Sokoban is not in the first colum
;; The S's left square isn't occupated(Obstacle, box or deposit)
;; We haven't finished the levels

(defrule left
  (sokoban ?sx ?sy ?last level ?level boxes $?boxes deposits $?deposits)
  (test (neq ?last right))
  
  (max-depth ?depth)
  (test (> ?sx 0))
  
  (not (obstacle =(- ?sx 1) ?sy))
  (not (member$ (create$ b =(- ?sx 1) ?by) $boxes))
  (not (member$ (create$ d =(- ?sx 1) ?sy) $deposits))
  
  (test (< ?level ?depth))
  
  =>
  
  (assert (sokoban (- ?sx 1) ?sy left level (+ ?level 1) $?))

)



; ----- PUSH LEFT -----
;; Requirements:
;; There is a box at the left of the Sokoban
;; The box is not in the first colum
;; The box's left square isn't occupated(Obstacle, box or deposit)
;; We haven't finished the levels

(defrule pushLeft
  (sokoban ?sx ?sy ?last level ?level boxes $?boxes1 b ?bx ?by $?boxes2 deposits $?deposits)
  (test (eq ?bx (- ?sx 1)))
  (test (eq ?by ?sy))
  
  (max-depth ?depth)
  (test (> ?sx 1))

  (not (obstacle =(- ?sx 2) ?sy))
  (not (sokoban ? ? ? level ?level boxes $?boxes1 b =(- ?sx 2) ?sy $?boxes2 deposits $?))
  (not (member$ (create$ d =(- ?sx 2) ?sy) $deposits))
  
  (test (< ?level ?depth))
  
  =>
  
  (assert (sokoban (- ?sx 1) ?sy pushLeft level (+ ?level 1) boxes $?boxes1 b (- ?bx 1) ?by $?boxes2 deposits $?deposits))

)



; ----- TOP -----
;; Requirements:
;; Sokoban is not in the first row
;; The S's top square isn't occupated(Obstacle, box or deposit)
;; We haven't finished the levels

(defrule top
  (sokoban ?sx ?sy ?last level ?level boxes $?boxes deposits $?deposits)
  (test (neq ?last bottom))
  
  (max-depth ?depth)
  (test (> ?sy 0))
  
  (not (obstacle ?sx =(- ?sy 1)))
  (not (member$ (create$ b ?sx =(- ?sy 1)) $boxes))
  (not (member$ (create$ d ?sx =(- ?sy 1)) $deposits))
  
  (test (< ?level ?depth))
  
  =>
  
  (assert (sokoban ?sx (- ?sy 1) left level (+ ?level 1) $?))

)



; -----PUSH TOP -----
;; Requirements:
;; There is a box above the Sokoban
;; The box is not in the first row
;; The box's left square isn't occupated(Obstacle, box or deposit)
;; We haven't finished the levels

(defrule pushTop
  (sokoban ?sx ?sy ?last level ?level boxes $?boxes1 b ?bx ?by $?boxes2 deposits $?deposits)
  (test (eq ?bx ?sx))
  (test (eq ?by (- ?sy 1)))
  
  (max-depth ?depth)
  (map ?width ?height)
  (test (< ?sy 2))
  
  (not (obstacle ?sx =(- ?sy 2)))
  (not (sokoban ? ? ? level ?level boxes $?boxes1 b ?sx =(- ?sy 2) $?boxes2 deposits $?))
  (not (member$ (create$ d ?sx =(- ?sy 2)) $deposits))
  
  (test (< ?level ?depth))
  
  =>
  
  (assert (sokoban ?sx (- ?sy 1) pushBottom level (+ ?level 1) boxes $?boxes1 b ?bx (- ?by 1) $?boxes2 deposits $?deposits))

)


; ----- BOTTOM -----
;; Requirements:
;; Sokoban is not in the last row
;; The S's bottom square isn't occupated(Obstacle, box or deposit)
;; We haven't finished the levels

(defrule bottom
  (sokoban ?sx ?sy ?last level ?level boxes $?boxes deposits $?deposits)
  (test (neq ?last top))
  
  (max-depth ?depth)
  (map ?width ?height)
  (test (< ?sy (- ?height 1)))
  
  (not (obstacle ?sx =(+ ?sy 1)))
  (not (member$ (create$ c ?sx =(+ ?sy 1)) $boxes))
  (not (member$ (create$ d ?sx =(+ ?sy 1)) $deposits))
  
  (test (< ?level ?depth))
  
  =>
  
  (assert (sokoban ?sx (+ ?sy 1) bottom level (+ ?level 1) $?))

)



; ----- PUSHBOTTOM -----
;; Requirements:
;; There is a box under the Sokoban
;; The box is not in the last row
;; The box's left square isn't occupated(Obstacle, box or deposit)
;; We haven't finished the levels

(defrule pushBottom
  (sokoban ?sx ?sy ?last level ?level boxes $?boxes1 b ?bx ?by $?boxes2 deposits $?deposits)
  (test (eq ?bx ?sx))
  (test (eq ?by (+ ?sy 1)))
  
  (max-depth ?depth)
  (map ?width ?height)
  (test (< ?sy (- ?height 2)))
  
  (not (obstacle ?sx =(+ ?sy 2)))
  (not (sokoban ? ? ? level ?level boxes $?boxes1 b ?sx =(+ ?sy 2) $?boxes2 deposits $?))
  (not (member$ (create$ d ?sx =(+ ?sy 2)) $deposits)))
  
  (test (< ?level ?depth))
  
  =>
  
  (assert (sokoban ?sx (+ ?sy 1) pushBottom level (+ ?level 1) boxes $?boxes1 b ?bx (+ ?by 1) $?boxes2 deposits $?deposits))

)


; ----- SOLUTION -----
;; Requirements:
;; All deposits are full

(defrule Solution
  (declare (salience 100))
  (sokoban ? ? ? level ?level boxes $? deposits $?deposits1 d ?dx ?dy ?dc $?deposits2)
  (not (sokoban ? ? ? level ?level boxes $?  deposits $?deposits1 d ?dx ?dy 0 $?deposits2))
  
  =>

  (printout t "Solution found at level " ?level crlf)
  (halt)
  
)
