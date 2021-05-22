#lang racket

(require 
  pict 
  pict/convert
  racket/match
  racket/class 
  racket/gui/base

  "art.rkt")

;; This code is used for eval to allow it to
;; see pict
(define-namespace-anchor anc)
(define ns (namespace-anchor->namespace anc))

(define *thumb-width*  1280)
(define *thumb-height* 720)

(define (do-scale [v 2.0]) `(scale ,v))
(define (do-rotate [a (/ pi 3)]) `(rotate ,a))

(define (c-translate p x y)
  (let ([w (pict-width p)]
        [h (pict-height p)])
    (translate p (- x (/ w 2)) (- y (/ h 2)))))

(define (l-translate p x y) (translate p x (- y (/ (pict-height p) 2))))
(define (lb-translate p x y) (translate p x (- y (pict-height p))))
(define (r-translate p x y) (translate p (- x (pict-width p)) (- y (/ (pict-height p) 2))))
(define (br-translate p x y) (translate p (- x (pict-width p)) (- y (pict-height p))))
(define (tr-translate p x y) (translate p (- x (pict-width p)) y))
(define (t-translate p x y) (translate p (- x (/ (pict-width p) 2)) y))
(define (b-translate p x y) (translate p (- x (/ (pict-width p) 2)) (- y (pict-height p))))

(define (do-align [side 'center] [margin '(0 0)])
  (match side
    ['top-left '(translate 0 0)]
    ['left '(l-translate 0 (/ *thumb-height* 2))]
    ['bottom-left '(lb-translate 0 *thumb-height*)]
    ['center '(c-translate (/ *thumb-width* 2) (/ *thumb-height* 2))]
    ['top '(t-translate (/ *thumb-width* 2) 0)]
    ['bottom '(b-translate (/ *thumb-width* 2) *thumb-height*)]
    ['top-right '(tr-translate *thumb-width* 0)]
    ['right '(r-translate *thumb-width* (/ *thumb-height* 2))]
    ['bottom-right '(br-translate *thumb-width* *thumb-height*)]
    [else '(translate 0 0)]))

(define (inject transform pic)
  (cons (car transform)
        (cons pic (cdr transform))))

(define (do-pipe pipe p)
  (eval (foldr inject p pipe) ns))

(struct +thing (pic pipe))
(struct +thumbnail (things))

;; constructors
(define (make-background color)
  (+thing
   (filled-rectangle *thumb-width* *thumb-height* #:color color)
   '()))

(define *pic* (filled-rectangle 100 100 #:color "Purple"))
(define *pipe* (list (do-align 'left) (do-scale 0.5))) 

(define (render-thumbnail thumb)
  (define pictures
    (for/list ([it (+thumbnail-things thumb)])
      (do-pipe (+thing-pipe it) (+thing-pic it))))
  (apply lt-superimpose (cons (blank *thumb-width* *thumb-height*) pictures)))

(define *thumb*
  (+thumbnail
   (list
    (make-background "black")
    (+thing *pic* (list (do-align 'top-left))))))

(render-thumbnail *thumb*)

(show-pict (render-thumbnail *thumb*) *thumb-width* *thumb-height*)

;;(save-to-png (red-circle 200) "test.png")