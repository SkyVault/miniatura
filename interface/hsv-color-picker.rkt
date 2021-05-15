#lang racket/gui

(define hsv-color-picker%
  (class panel%
    (init-field parent) 
    (super-new 
      [parent parent]
      [min-height 256])))
