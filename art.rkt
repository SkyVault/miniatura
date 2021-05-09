#lang racket

(require 
  pict 
  racket/class 
  racket/gui/base)

(provide 
  +clear+ 
  rect
  rect-2tone
  load-png
  save-to-png)

(define +clear+ (make-object color% 0 0 0 0.0))

(define (rect x y width height)
  (dc (lambda (dc dx dy) 
        (send dc draw-rectangle dx dy width height))
      width height))

(define (rect-2tone 
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

(define (load-png path)
  (let ([bmp (make-object bitmap% 1 1)])
    (send bmp load-file path 'png)
    (bitmap bmp)))

(define (save-to-png pic output)
  (let ([bmp (pict->bitmap pic)])
    (send bmp save-file output 'png)))

