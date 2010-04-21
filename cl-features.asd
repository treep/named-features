;;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; indent-tabs-mode: nil -*-
;;;
;;;  cl-features.asd -- ASDF definition for CL-FEATURES system.
;;;

(asdf:defsystem :cl-features
  :description "Features managment for CL."
  :licence     "Public domain"
  :version     "0.0.1"
  :pathname    (merge-pathnames "src/" *load-truename*)
  :serial      t
  :depends-on  (:trivial-features)
  :components ((:file "package")
               (:file "readers")
               (:file "macroes")
               (:file "mapping")))
