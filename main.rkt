#lang racket

(require 
  pict 
  pict/convert
  racket/class 
  racket/gui/base
  slideshow-text-style

  "art.rkt")

(define *width*  640)
(define *height* 480)

(define overlay (rect-2tone *width* *height* #:color-1 +clear+ #:x-skew 200))

(show-pict 
  (with-text-style
    #:defaults (#:face "Fira Sans" #:color "white")
    ([title #:size 60 #:bold? #t])
    (cc-superimpose 
      (scale-to-fit 
        (load-png "assets/nature.png") 
        *width* 
        *height* 
        #:mode 'inset/max)
      overlay
      (translate (title "What") -200 -200)

      (-> (title "What") (translate 100 100) (rotate (/pi 4)) (scale 2))))
   *width* *height*)

;;(save-to-png (red-circle 200) "test.png")

;(define (make-thumbnail n) 
;  (vc-append 4 (red-circle 100) (red-circle 100)))
;
;(make-thumbnail 19)
