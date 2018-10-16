

(defglobal ?*nod-gen* = 0)

  ; ----- INIT MAP -----
(deffacts init_map 
 (initial-fact)
  (map 8 5)
  (sokoban 0 3 none level 0 boxes b 1 1 b 2 3 b 5 1 deposits d 0 6 0 d 0 4 3 d 0 4 4 ))
  (obstacle 0 2)
  (obstacle 3 0)
  (obstacle 3 2)
  (obstacle 3 3)
  (obstacle 3 4)
  (obstacle 4 2)
  (obstacle 7 2)

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
  (printout t " Execute run to start the program. " crlf)  
  (assert (max-depth ?prof))

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
  (test (not (member$ (create$ c (+ ?sx 1) ?sy) $?boxes)))
  (test (not (member$ (create$ d 0 (+ ?sx 1) ?sy) $?deposits)))
  (test (not (member$ (create$ d 1 (+ ?sx 1) ?sy) $?deposits)))
  (test (< ?level ?depth))
  
  =>
  (assert (sokoban (+ ?sx 1) ?sy right level (+ ?level 1) boxes $?boxes deposits $?deposits))
  (bind ?*nod-gen* (+ ?*nod-gen* 1))
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
  (test (not (member$ (create$ c (- ?sx 1) ?sy) $?boxes)))
  (test (not (member$ (create$ d 0 (- ?sx 1) ?sy) $?deposits)))
  (test (not (member$ (create$ d 1 (- ?sx 1) ?sy) $?deposits)))
  
  (test (< ?level ?depth))
  
  =>
  
  (assert (sokoban (- ?sx 1) ?sy left level (+ ?level 1) boxes $?boxes deposits $?deposits))
  (bind ?*nod-gen* (+ ?*nod-gen* 1))
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
   (test (not (member$ (create$ c ?sx (- ?sy 1)) $?boxes)))
  (test (not (member$ (create$ d 0 ?sx (- ?sy 1)) $?deposits)))
  (test (not (member$ (create$ d 1 ?sx (- ?sy 1)) $?deposits)))
  
  (test (< ?level ?depth))
  
  =>
  
  (assert (sokoban ?sx (- ?sy 1) top level (+ ?level 1) boxes $?boxes deposits $?deposits))
  (bind ?*nod-gen* (+ ?*nod-gen* 1))
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
  (test (not (member$ (create$ c ?sx (+ ?sy 1)) $?boxes)))
  (test (not (member$ (create$ d 0 ?sx (+ ?sy 1)) $?deposits)))
  (test (not (member$ (create$ d 1 ?sx (+ ?sy 1)) $?deposits)))
  
  (test (< ?level ?depth))
  
  =>
  
  (assert (sokoban ?sx (+ ?sy 1) bottom level (+ ?level 1) boxes $?boxes deposits $?deposits))
  (bind ?*nod-gen* (+ ?*nod-gen* 1))
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
  (not (sokoban $? d ?bx ?by $?))
  
  (max-depth ?depth)
  (map ?width ?height)
  (test (< ?sx (- ?width 2)))
  
  (not (obstacle =(+ ?sx 2) ?sy))
  (test (not (member$ (create$ b (+ ?sx 2) ?sy) $?boxes1)))
  (test (not (member$ (create$ b (+ ?sx 2) ?sy) $?boxes2)))
  (test (not (member$ (create$ d 0 (+ ?sx 2) ?sy) $?deposits)))
  (test (not (member$ (create$ d 1 (+ ?sx 2) ?sy) $?deposits)))
  
  (test (< ?level ?depth))
  
  =>
  
  (assert (sokoban (+ ?sx 1) ?sy pushRight level (+ ?level 1) boxes $?boxes1 b (+ ?bx 1) ?by $?boxes2 deposits $?deposits))
  (bind ?*nod-gen* (+ ?*nod-gen* 1))
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
  (not (sokoban $? d ?bx ?by $?))
  
  (max-depth ?depth)
  (test (> ?sx 1))

  (not (obstacle =(- ?sx 2) ?sy))
  (test (not (member$ (create$ b (- ?sx 2) ?sy) $?boxes1)))
  (test (not (member$ (create$ b (- ?sx 2) ?sy) $?boxes2)))
  (test (not (member$ (create$ d 0 (- ?sx 2) ?sy) $?deposits)))
  (test (not (member$ (create$ d 1 (- ?sx 2) ?sy) $?deposits)))
  
  (test (< ?level ?depth))
  
  =>
  
  (assert (sokoban (- ?sx 1) ?sy pushLeft level (+ ?level 1) boxes $?boxes1 b (- ?bx 1) ?by $?boxes2 deposits $?deposits))
  (bind ?*nod-gen* (+ ?*nod-gen* 1))
)



; -----PUSH TOP -----
;; Requirements:
;; There is a box above the Sokoban
;; The box is not in the first row
;; The box's up square isn't occupated(Obstacle, box or deposit)
;; We haven't finished the levels

(defrule pushTop
  (sokoban ?sx ?sy ?last level ?level boxes $?boxes1 b ?bx ?by $?boxes2 deposits $?deposits)
  (test (eq ?bx ?sx))
  (test (eq ?by (- ?sy 1)))  
  (not (sokoban $? d ?bx ?by $?))
  
  (max-depth ?depth)
  (map ?width ?height)
  (test (> ?sy 2))
  
  (not (obstacle ?sx =(- ?sy 2)))
   (test (not (member$ (create$ b ?sx (- ?sy 2)) $?boxes1)))
   (test (not (member$ (create$ b ?sx (- ?sy 2)) $?boxes2)))
   (test (not (member$ (create$ d 0 ?sx (- ?sy 2)) $?deposits)))
   (test (not (member$ (create$ d 1 ?sx (- ?sy 2)) $?deposits)))
  (test (< ?level ?depth))
  
  =>
  
  (assert (sokoban ?sx (- ?sy 1) pushTop level (+ ?level 1) boxes $?boxes1 b ?bx (- ?by 1) $?boxes2 deposits $?deposits))
  (bind ?*nod-gen* (+ ?*nod-gen* 1))
)



; ----- PUSH BOTTOM -----
;; Requirements:
;; There is a box under the Sokoban
;; The box is not in the last row
;; The box's downs square isn't occupated(Obstacle, box or deposit)
;; We haven't finished the levels

(defrule pushBottom
  (sokoban ?sx ?sy ?last level ?level boxes $?boxes1 b ?bx ?by $?boxes2 deposits $?deposits)
  (test (eq ?bx ?sx))
  (test (eq ?by (+ ?sy 1)))
  (not (sokoban $? d ?bx ?by $?))
  
  (max-depth ?depth)
  (map ?width ?height)
  (test (< ?sy (- ?height 2)))
  
  (not (obstacle ?sx =(+ ?sy 2)))
   (test (not (member$ (create$ b ?sx (+ ?sy 2)) $?boxes1)))
   (test (not (member$ (create$ b ?sx (+ ?sy 2)) $?boxes2)))
  (test (not (member$ (create$ d 0 ?sx (+ ?sy 2)) $?deposits)))
  (test (not (member$ (create$ d 1 ?sx (+ ?sy 2)) $?deposits)))
  
  (test (< ?level ?depth))
  
  =>
  
  (assert (sokoban ?sx (+ ?sy 1) pushBottom level (+ ?level 1) boxes $?boxes1 b ?bx (+ ?by 1) $?boxes2 deposits $?deposits))
  (bind ?*nod-gen* (+ ?*nod-gen* 1))
)  



; ----- STORE RIGHT -----
;; Requirements:
;; There is a box at the right of the Sokoban
;; The box is not in the last colum
;; The box's right square is occupated by a deposit
;; We haven't finished the levels

(defrule storeRight
  (sokoban ?sx ?sy ?last level ?level boxes $?boxes1 b ?bx ?by $?boxes2 deposits $?deposits1 d ?do ?dx ?dy $?deposits2)
  (test (eq ?bx (+ ?sx 1)))
  (test (eq ?by ?sy))
  
  (max-depth ?depth)
  (map ?width ?height)
  (test (< ?sx (- ?width 2)))
  
  (not (obstacle =(+ ?sx 2) ?sy))
  (test (not (member$ (create$ b (+ ?sx 2) ?sy) $?boxes1)))
  (test (not (member$ (create$ b (+ ?sx 2) ?sy) $?boxes2)))
  (sokoban ? ? ? level ?level boxes $? deposits $?deposits1 d 0 =(+ ?sx 2) ?sy $?deposits2)
  
  (test (< ?level ?depth))
  
  =>
  
  (assert (sokoban (+ ?sx 1) ?sy storeRight level (+ ?level 1) boxes $?boxes1 b (+ ?bx 1) ?by $?boxes2 deposits $?deposits1 d ?dx ?dy (+ ?do 1) $?deposits2))
  (printout t "Box stored at level " =(+ ?level 1) crlf)
  (bind ?*nod-gen* (+ ?*nod-gen* 1))
)



; ----- STORE LEFT -----
;; Requirements:
;; There is a box at the left of the Sokoban
;; The box is not in the first colum
;; The box's first square is occupated by a deposit
;; We haven't finished the levels

(defrule storeLeft
  (sokoban ?sx ?sy ?last level ?level boxes $?boxes1 b ?bx ?by $?boxes2 deposits $?deposits1 d ?do ?dx ?dy $?deposits2)
  (test (eq ?bx (- ?sx 1)))
  (test (eq ?by ?sy))
  
  (max-depth ?depth)
  (test (> ?sx 1))
  
  (not (obstacle =(- ?sx 2) ?sy))
  (test (not (member$ (create$ b (- ?sx 2) ?sy) $?boxes1)))
  (test (not (member$ (create$ b (- ?sx 2) ?sy) $?boxes2)))
  (sokoban ? ? ? level ?level boxes $? deposits $?deposits1 d 0 =(- ?sx 2) ?sy $?deposits2)
  
  (test (< ?level ?depth))
  
  =>
  
  (assert (sokoban (- ?sx 1) ?sy storeLeft level (+ ?level 1) boxes $?boxes1 b (- ?bx 1) ?by $?boxes2 deposits $?deposits1 d ?dx ?dy (+ ?do 1) $?deposits2))
  (printout t "Box stored at level " =(+ ?level 1) crlf)
  (bind ?*nod-gen* (+ ?*nod-gen* 1))
)



; ----- STORE TOP -----
;; Requirements:
;; There is a box above the Sokoban
;; The box is not in the first row
;; The box's up square is occupated by a deposit
;; We haven't finished the levels

(defrule storeTop
  (sokoban ?sx ?sy ?last level ?level boxes $?boxes1 b ?bx ?by $?boxes2 deposits $?deposits1 d ?do ?dx ?dy $?deposits2)
  (test (eq ?bx ?sx))
  (test (eq ?by (+ ?sy 1)))
  
  (max-depth ?depth)
  (test (> ?sy 2))
  
  (not (obstacle ?sx =(- ?sy 2)))
  (test (not (member$ (create$ b ?sx (- ?sy 2)) $?boxes1)))
  (test (not (member$ (create$ b ?sx (- ?sy 2)) $?boxes2)))
  (sokoban ? ? ? level ?level boxes $? deposits $?deposits1 d 0 ?sx =(- ?sy 2) $?deposits2)
  
  (test (< ?level ?depth))
  
  =>
  
  (assert (sokoban ?sx (- ?sy 1) storeTop level (+ ?level 1) boxes $?boxes1 b ?bx (- ?by 1) $?boxes2 deposits $?deposits1 d ?dx ?dy (+ ?do 1) $?deposits2))
  (printout t "Box stored at level " =(+ ?level 1) crlf)
  (bind ?*nod-gen* (+ ?*nod-gen* 1))
)



; ----- STORE BOTTOM -----
;; Requirements:
;; There is a box under the Sokoban
;; The box is not in the last row
;; The box's down square is occupated by a deposit
;; We haven't finished the levels

(defrule storeBottom
  (sokoban ?sx ?sy ?last level ?level boxes $?boxes1 b ?bx ?by $?boxes2 deposits $?deposits1 d ?do ?dx ?dy $?deposits2)
  (test (eq ?bx ?sx))
  (test (eq ?by (+ ?sy 1)))
  
  (max-depth ?depth)
  (map ?width ?height)
  (test (< ?sy (- ?height 2)))
  
  (not (obstacle ?sx =(+ ?sy 2)))
  (test (not (member$ (create$ b ?sx (+ ?sy 2)) $?boxes1)))
  (test (not (member$ (create$ b ?sx (+ ?sy 2)) $?boxes2)))
  (sokoban ? ? ? level ?level boxes $? deposits $?deposits1 d 0 ?sx =(+ ?sy 2) $?deposits2)
  
  (test (< ?level ?depth))
  
  =>
  
  (assert (sokoban ?sx (+ ?sy 1) storeBotton level (+ ?level 1) boxes $?boxes1 b ?bx (+ ?by 1) $?boxes2 deposits $?deposits1 d ?dx ?dy (+ ?do 1) $?deposits2))
  (printout t "Box stored at level " =(+ ?level 1) crlf)
  (bind ?*nod-gen* (+ ?*nod-gen* 1))
)



; ----- SOLUTION -----
;; Requirements:
;; All deposits are full

(defrule Solution
  (declare (salience 100))
  (sokoban ?sx ?sy ? level ?level boxes $? deposits $?deposits)
  (test (not (member$ (create$ d 0) $?deposits)))
  
  =>

  (printout t "Solution found at level " ?level crlf)
  (printout t "Nodes generated " ?*nod-gen* crlf)
  (halt)
  
)
