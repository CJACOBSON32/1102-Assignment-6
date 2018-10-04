#lang racket

;; #:transparent makes structures display a bit nicer
(define-struct graph (name nodes) #:transparent #:mutable)

(define-struct node (name edges) #:transparent #:mutable)

;; *******************************************************
;; you don't need to understand this part
;; just be sure you use my-eval instead of eval
(define-namespace-anchor a)
(define ns (namespace-anchor->namespace a))


(define-syntax my-eval
  (syntax-rules ()
    [(my-eval arg)
     (eval arg ns)]))
;; *******************************************************

;; some examples of Racket weirdness you will need to work around
(define x 3)
(define y 5)
(set! y 6)

;; in the interpreter, try:
;;     (set! x 10)
;;     (set! y 10)
;; first one fails, second one works
;; --> if you want a variable you can change later, will need both
;;     define and set! in your macro
;; (create z 99) could be a handy macro to define and set a variable

(define z (list y))
;          (list 6)
(set! y 8)
;; in the interpreter, try
;;        y
;;        z
;; it looks like values don't update properly.  how can we make it update properly?

(define z2 (list (quote y)))
(set! y 11)
;; what is z2?
;; it's '(y)
;; how to get back the 11?

;; how about (my-eval (first z2)) ?
;;    -> that's how we'll store lists of nodes

;---------------------------------------------------Part 1---------------------------------------------------
;; graph node -> graph
(define (add-unique g n)
  (if (member n (graph-nodes g))
      empty n))
;use a macro to append a node or empty to an existing list of graph nodes if it is unique
(define-syntax vertex
  (syntax-rules (in)
    [(vertex a in b)
     (set! b (make-graph
              (graph-name b)(append (graph-nodes b) (list (add-unique b a)))))]))