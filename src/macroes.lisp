;;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; indent-tabs-mode: nil -*-
;;;
;;;  macroes.lisp -- top-level macroes for work with various features lists.
;;;

(in-package #:cl-features)

;;; top-level macro for define new features list.

(defmacro define-features-list (name &key value documentation macro-character)
  "Define a new features list called NAME and its related readers."
 `(progn
    (declaim (type list ,name))
    (defparameter ,name ,value ,documentation)
    (set-dispatch-macro-character #\# ,macro-character #'features-reader)))

;;; when-* macroes

;;; when-features
;;; when-not-features
;;; when-some-features
;;; when-not-some-features

;(when-features ((*features* :sbcl :linux)
;                (*my-features* :all :good))
;  (do-something))

;;; with-features


