#lang racket/gui

(require 
  pict 
  "thing-card.rkt"
  "hsv-color-picker.rkt"
  "../art.rkt")

(define-syntax-rule (defn name args body)
  (define name (lambda args body)))

(define (new-rect-panel parent)
  (define 
    container
    (new group-box-panel%
      [parent parent]
      [label "Rect"]
      [min-height 200]))
    
  (new message% 
    [parent container]
    [label "Rectangle"]))

(define application% 
  (class object%
    (init-field width height)

    (define result 
      (thumbnail '()))

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
         [label "Preview"]
         [paint-callback 
           (lambda (self dc)
             ((make-pict-drawer 
                (scale-to-fit 
                  (render-thumbnail result)
                  (send self get-width) 
                  (send self get-height))) dc 0 0))]))

    (define right-side-panel
      (new vertical-panel%
        [parent main-container]))

    (define tool-bar 
      (new horizontal-panel%
        [parent right-side-panel]
        [alignment (list 'right 'center)]
        [stretchable-height #f]))

    (define (update-preview-canvas)
      (send preview-canvas refresh-now))

    (define (on-new-thing)
      (let ([x (* *thumb-width* (randf))]
            [y (* *thumb-height* (randf))])
        (set-thumbnail-things!
          result
          (cons 
            (+thing 
              (filled-rectangle 10 10 #:color "Purple") 
              `((translate ,x ,y))
              'rect)
            (thumbnail-things result)))
        (update-preview-canvas)
        (update-things-list)))

    (define new-buttton
      (new button%
        [label "New"]
        [parent tool-bar]
        [callback (lambda (b e) (on-new-thing))]))

    (define things-list
      (new vertical-panel%
         [parent right-side-panel]
         [style (list 'auto-vscroll)]))

    (define (update-things-list)
      (for ([x (thumbnail-things result)])

          (match (+thing-type x)
            ['rect (new-rect-panel things-list)]
            [else '()])
        
        ))

    (send frame show #t)
    (super-new)))

(new application% 
   [width 1280] 
   [height 480])
