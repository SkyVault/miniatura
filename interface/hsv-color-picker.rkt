#lang racket/gui

(provide hsv-color-picker%)

(define hsv-color-picker%
  (class pane%
    (super-new [parent parent])

    (define panel
      (new panel%
        [min-height 256]))

    (define canvas
      (new canvas% 
        [parent panel]))))
