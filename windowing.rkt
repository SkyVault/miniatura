#lang racket

(require 
  pict 
  racket/class 
  racket/gui/base)

(define container 
  (new frame% 
    [label "Thumbnail"]
    [width 1280]
    [height 720]
    [alignment '(center center)]))

(define (add-drawing picture)
  (let ([drawer (make-pict-drawer picture)])
    (new canvas% [parent container]
                 [style '(border)]
                 [paint-callback (lambda (self draw-ctx)
                                   (drawer draw-ctx 0 0))])))

(send container show #t)

(dc (λ (dc dx dy)
               (define old-brush
                 (send dc get-brush))
               (define old-pen
                 (send dc get-pen))
               (define gradient
                 (make-object
                  linear-gradient%
                  dx dy
                  dx (+ dy height)
                  `((0 ,(make-object color% color-1))
                    (1 ,(make-object color% color-2)))))
               (send dc set-brush
                 (new brush% [gradient gradient]))
               (send dc set-pen
                 (new pen% [width border-width]
                           [color border-color]))
               (send dc draw-rectangle dx dy width height)
               (send dc set-brush old-brush)
               (send dc set-pen old-pen))
             width height)
