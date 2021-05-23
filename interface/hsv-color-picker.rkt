#lang racket/gui

(provide 
  hsv-color-picker%
  hsv-color-sliders%)

(define hsv-color-sliders%
  (class panel% 
    (init-field 
      parent 
      [on-color (lambda (c) c)])

    (super-new [parent parent])

    (define container
      (new horizontal-panel%
           [parent parent]
           [min-height 100]))

    (define color (make-object color% 0 0 0))

    (define color-box
      (new canvas%
           [parent container]))

    (define (update-color)
      (on-color color)
      (send color-box set-canvas-background color)
      (send color-box refresh-now))

    (update-color)

    (define controls
      (new vertical-panel%
           [parent container]))

    (define r-slider 
      (new slider% 
           [label "R"] 
           [parent controls] 
           [min-value 0] 
           [max-value 255] 
           [init-value 0]
           [callback (lambda (slider e)
                       (send color set (send slider get-value) (send color green) (send color blue))
                       (update-color))]))

    (define g-slider 
      (new slider% 
           [label "G"] 
           [parent controls] 
           [min-value 0] 
           [max-value 255] 
           [init-value 0]
           [callback (lambda (slider e)
                       (send color set (send color red) (send slider get-value) (send color blue))
                       (update-color))]))

    (define b-slider 
      (new slider% 
           [label "B"] 
           [parent controls] 
           [min-value 0] 
           [max-value 255] 
           [init-value 0]
           [callback (lambda (slider e)
                       (send color set (send color red) (send color green) (send slider get-value))
                       (update-color))])) ))

(define hsv-color-picker%
  (class panel%
    (init-field parent)
    (super-new [parent parent])

    (define panel
      (new panel%
        [parent parent]
        [min-height 256]))

    (define canvas
      (new canvas% 
        [parent panel]))))
