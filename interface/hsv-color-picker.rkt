#lang racket/gui

(provide hsv-color-picker%)

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
