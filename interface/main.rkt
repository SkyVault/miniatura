#lang racket/gui

(require "thing-card.rkt")

(define-syntax-rule (defn name args body)
  (define name (lambda args body)))

(define application% 
  (class object%
    (init-field width height)

    (define frame
      (new frame% 
        [label "Minitura"]
        [width width]
        [height height]))

    (define main-menu
      (new menu-bar% [parent frame]))

    (new menu% [label "&File"] [parent main-menu]) 
    (new menu% [label "&Tools"] [parent main-menu]) 
    (new menu% [label "&Help"] [parent main-menu]) 

    (define main-container
      (new horizontal-panel%
           [parent frame]
           [style (list 'border)]))

    (define preview-panel 
      (new panel% [parent main-container] [min-width 480]))

    (define preview-canvas
      (new canvas%
           [parent preview-panel]
           [label "Preview"]))

    (define things-list
      (new vertical-panel%
         [parent main-container]
         [style (list 'auto-vscroll)]))

    ;(for ([i 10])
    ;  (make-thing "Hello" things-list))

    (send frame show #t)
    (super-new)))

(new application% 
   [width 1280] 
   [height 480])
