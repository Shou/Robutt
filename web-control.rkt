#lang racket


; XXX
;   - Use the time ticker event to control the robutt smoothly
;       - Keep a list of directions it's going in and every tick go there
;           - Global state variable, dirs :: [String]
;           - "stop-right" etc can now work!
;       - Lower to something like 300ms rather than 1000ms

; TODO
;   - Finish controls!
;   - Buy more high fashion clothes
;       - Rick Owens x Adidas sneakers!
;       - Stutterheim Stockholm Svart raincoat or Y-3 Raindrop.
;       - F/W is coming!!


(require "MIRTOlib.rkt")
(require net/rfc6455)


(define (trace x)
  (printf "~v\n" x)
  x)

(define (robutt-send c s)
  (printf " > ~a\n" s)
  (ws-send! c s))

(define (robutt-recv c)
  (define s (ws-recv c #:payload-type 'text))
  (printf " < ~a\n" s)
  s)

(define (move-robot d)
  (cond [ (eq? d "left") (void) ]
        [ (eq? d "right") (void) ]
        [ (eq? d "front") (void) ]
        [ (eq? d "back") (void) ]
        [ (eq? d "stop") (stopMotors) ]))

(define (parse-cmds s)
  (map move-robot (string-split s " ")))

(define (con-han c state)
  (let loop ()
    (sync (handle-evt (alarm-evt (+ (current-inexact-milliseconds) 1000))
                      (lambda _
                        ; (robutt-send c "Waited another second")
                        (loop)))
          (handle-evt c
                      (lambda _
                        (define m (robutt-recv c))
                        (unless (eof-object? m)
                          (if (equal? m "quit")
                            (void)
                            (begin (parse-cmds m)
                                   (loop))))))))
  (ws-close! c))

; stop-service :: Void
(define stop-service
    (ws-serve #:port 8081 con-han))

(define (main)
  (printf "Server running. Press Enter to stop.\n")
  ; (setup)
  (read-line)
  (stop-service))


(main)

