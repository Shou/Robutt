#lang racket

(require web-server/servlet
         web-server/servlet-env)

; page :: IO [Bytes]
(define page
  (string->bytes/utf-8 (string-join (file->lines "index.html") "\n")))

(define (app req)
  (response/full 200
                 #"OK"
                 (current-seconds)
                 TEXT/HTML-MIME-TYPE
                 (list (make-header #"Location"
                                    (string->bytes/utf-8 (url->string (request-uri req)))))
                 ; '(#"<body><h1>hello</h1></body>")))
                 (list page)))

(define (xapp req)
  (response/xexpr
    '(html (head (title "hello man"))
           (body (h1 "potato")))))

(serve/servlet app
               #:port 8888
               #:listen-ip "0.0.0.0"
               #:servlet-path "/robutt/"
               #:extra-files-paths (list "/home/hatate/Prog/Racket/Robutt/")
               #:banner? #f
               #:servlets-root "index.html"
               )

