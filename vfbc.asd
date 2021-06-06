;;;; vfbc.asd

(asdf:defsystem #:vfbc
  :description "Describe vfbc here"
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t
  :depends-on (#:hunchensocket #:websocket-driver #:cffi)
  :components ((:file "package")
               (:file "vfbc")))
