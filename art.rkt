#lang racket

(require 
  pict 
  racket/class 
  racket/gui/base
  math)

(provide 
  +clear+ 
  rect
  rectangle-gradient-vertical
  rectangle-gradient-horizontal
  load-png
  save-to-png

  randf

  *thumb-width*
  *thumb-height*
  +thing-type

  do-align
  do-scale
  do-rotate
  do-pipe

  thumbnail
  set-thumbnail-things!
  thumbnail-things

  +thing

  make-background
  make-wallpaper

  render-thumbnail)

;; This code is used for eval to allow it to
;; see pict
(define-namespace-anchor anc)
(define ns (namespace-anchor->namespace anc))

(define +clear+ (make-object color% 0 0 0 0.0))

(define (rect x y width height)
  (dc (lambda (dc dx dy) 
        (send dc draw-rectangle dx dy width height))
      width height))

(define (rectangle-gradient-vertical
          width 
          height 
          #:border-width [border-width 1] 
          #:border-color [border-color "transparent"]
          #:color-1 [color-1 "white"]
          #:color-2 [color-2 "black"]
          #:x-skew [x-skew 0])
  (dc (lambda (dc dx dy)
        (let ([old-brush (send dc get-brush)]
              [old-pen (send dc get-pen)])
          (define gradient
            (make-object 
              linear-gradient% 
              (- dx (/ x-skew 2))
              dy
              (+ dx (/ x-skew 2)) 
              (+ dy height)
              `((0 ,(make-object color% color-1))
                (1 ,(make-object color% color-2)))))
          (send dc set-brush (new brush% [gradient gradient]))
          (send dc set-pen "black" 1 'transparent)
          (send dc draw-rectangle dx dy width height)
          (send dc set-brush old-brush)
          (send dc set-pen old-pen)))
    width height))

(define (rectangle-gradient-horizontal
          width 
          height 
          #:border-width [border-width 1] 
          #:border-color [border-color "transparent"]
          #:color-1 [color-1 "white"]
          #:color-2 [color-2 "black"]
          #:x-skew [x-skew 0])
  (dc (lambda (dc dx dy)
        (let ([old-brush (send dc get-brush)]
              [old-pen (send dc get-pen)])

          (define gradient
            (make-object 
              linear-gradient% 
              (- dx (/ width 2))
              dy
              (- (+ dx width) (/ width 2))
              (+ dy height)
              `((0 ,(make-object color% color-1))
                (1 ,(make-object color% color-2)))))

          (send dc set-brush (new brush% [gradient gradient]))
          (send dc set-pen "black" 1 'transparent)
          (send dc draw-rectangle dx dy width height)
          (send dc set-brush old-brush)
          (send dc set-pen old-pen)))
    width height))

(define (load-png path)
  (let ([bmp (make-object bitmap% 1 1)])
    (send bmp load-file path 'png)
    (bitmap bmp)))

(define (save-to-png pic output)
  (let ([bmp (pict->bitmap pic)])
    (send bmp save-file output 'png)))

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

(define (do-align [side 'center])
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

(struct +thing (pic pipe type) #:transparent #:mutable)
(struct 
  thumbnail 
  (things)
  #:transparent
  #:mutable)

;; constructors
(define (make-background color)
  (+thing
   (filled-rectangle *thumb-width* *thumb-height* #:color color)
   '()))

(define (make-wallpaper path)
  (+thing (scale-to-fit (load-png path) *thumb-width* *thumb-height* #:mode 'inset/max) '()))

(define (render-thumbnail thumb)
  (define pictures
    (for/list ([it (thumbnail-things thumb)])
      (do-pipe 
        (+thing-pipe it) 
        (+thing-pic it))))
  (apply lt-superimpose (cons (blank *thumb-width* *thumb-height*) pictures)))

(define (randf)
  (/ (random-integer 0 100) 100.0))
