#lang racket/gui

(provide thing%)

(define thing%
  (class object%
    (init-field title parent) 

    (field 
      [panel 
        (new panel%
          [parent parent]
          [style (list 'border)]
          [min-height 64])])))
