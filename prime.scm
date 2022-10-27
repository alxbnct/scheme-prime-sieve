#!/usr/bin/csi -script
(import (chicken base)
	(chicken port)
	(chicken process-context)
	miscmacros
	srfi.160.base
	srfi.160.u32
	(math number-theory))

(define (main)
  (print (u32vector-filter
	   (lambda (e)
	     (not (= 0 e)))
	   (primes (string->number (car (command-line-arguments)))))))


(define (primes n)
  (let ((vec (make-u32vector (- n 2) 0)))
    (do ((i 2 (+ i 1)))
      ((= i n))
      (u32vector-set! vec (- i 2) i))
    (do ((i 0 (+ i 1)))
      ((>= i (sqrt n)))
      (let ((e (u32vector-ref vec i)))
	(if (not (= 0 e))
	    (u32vector-map! (lambda (el)
			      (if (or (= el e)
				      (not (= (modulo el e) 0)))
				  el
				  0)) vec))))
    vec))

(main)

;; compile with
;;   csc -strip prime.scm -O3		# dynamicly linked
;;   csc -strip -static prime.scm -O3	# statically linked
;; time ./prime 200000
;;   real    0m1.565s
;;   user    0m1.542s
;;   sys     0m0.005s

;; Run as script
;; time ./prime.scm 200000
;;   real    0m5.157s
;;   user    0m5.123s
;;   sys     0m0.020s
