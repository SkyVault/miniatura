#lang racket

(require 
  pict 
  pict/convert
  racket/match
  racket/class 
  racket/gui/base

  "art.rkt")

(define *pic* (filled-rectangle 100 100 #:color "Purple"))

(define *thumb*
  (+thumbnail
   (list
    (make-background "black")
    (make-wallpaper "assets/tree.png")
    (+thing (rectangle-gradient-horizontal *thumb-width* *thumb-height* #:color-1 +clear+ #:color-2 "black") '((translate 0 0)))
    (+thing (text "Hello World" (list (make-object color% 255 255 255) 'bold) 96) (list (do-align 'center)))
    (+thing *pic* (list (do-align 'bottom-right) '(translate -64 -64) (do-rotate))))))

(render-thumbnail *thumb*) 

(define *pic2* (render-thumbnail *thumb*))
;; (save-to-png (scale-to-fit (render-thumbnail *thumb*) *thumb-width* *thumb-height*) "test.png")
(show-pict *pic2* *thumb-width* *thumb-height*) 

;;;(save-to-png *pic2* "test.png") 
