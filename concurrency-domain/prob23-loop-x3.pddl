; This problem demonstrates an interesting property I discovered about the
; "interleaving x++ threads" programs, when writing a 15-213 exam question when
; I TAed it long ago. The idea is when the thread bodies look like:
;     for i = 0 to N {
;         temp <- x;
;         temp++;
;         x <- temp;
;     }
; Then possible values for x at the end of the program range from 2 to 2N, yet
; not 1 (as long as N isn't 1).
;
; This variant of the problem (with the goal being for x to be 3) is possible.
(define (problem threads-loop-x3)
	(:domain threads)
	(:objects
        n0 n1 n2 n3 n4 - number

		addr_x x temp1 temp2
		out i0 i1
		c1i0 c1i1 c1i2 c1i3 c1i4 c1i5 c1i6
		c2i0 c2i1 c2i2 c2i3 c2i4 c2i5 c2i6
		- label
	)
	(:init
        (succ n0 n1) (succ n1 n2) (succ n2 n3) (succ n3 n4)

		; .data
		(value x n0)
		(value temp1 n0)
		(value temp2 n0)

		; .text
		(eval i0 out)
		(fork i0 i1 c1i0 c2i0)
		; child program 1
		(load c1i0 c1i1 temp1 x)
		(incr c1i1 c1i2 temp1)
		(load c1i2 c1i3 x temp1)
		(load c1i3 c1i4 temp1 x)
		(incr c1i4 c1i5 temp1)
		(load c1i5 c1i6 x temp1)
		(exit c1i6)
		; child program 2
		(load c2i0 c2i1 temp2 x)
		(incr c2i1 c2i2 temp2)
		(load c2i2 c2i3 x temp2)
		(load c2i3 c2i4 temp2 x)
		(incr c2i4 c2i5 temp2)
		(load c2i5 c2i6 x temp2)
		(exit c2i6)
		; parent joins and immediately exits
		(exit i1)
	)
	(:goal (and
			(done out)
			(value x n3) ; x = 3
		)
	)
)
