#lang racket/gui

(provide make-thing)

(define (make-thing title parent)
  (new panel%
    [parent parent]
    [style (list 'border)]
    [min-height 64])) 
