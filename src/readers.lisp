;;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; indent-tabs-mode: nil -*-
;;;
;;;  readers.lisp -- reader macroes for features list.
;;;

(in-package #:cl-features)

;;; helper function which know about how to calculate :or/:and/:not predicates
;;; in test list.

(declaim (ftype (function ((or keyword cons) list) boolean) feature-in-list-p))
(defun feature-in-list-p (feature list)
  "Is FEATURE or FEATURES-EXPR in LIST?"
  (etypecase feature
    (symbol (member feature list :test #'eq))
    (cons (flet ((subfeature-in-list-p (subfeature)
                   (feature-in-list-p subfeature list)))
            (ecase (first feature)
              (:or  (some  #'subfeature-in-list-p (rest feature)))
              (:and (every #'subfeature-in-list-p (rest feature)))
              (:not (let ((rest (cdr feature)))
                      (if (or (null (car rest)) (cdr rest))
                        (error "wrong number of terms in compound feature ~S"
                               feature)
                        (not (subfeature-in-list-p (second feature)))))))))))

;;; reader macro.

(defun features-reader (stream sub-character infix-parameter)
  "Definition of #<.>+ and #<.>- reader macroes."
  (declare (type stream stream) (type character sub-character))
  (when infix-parameter
    (error "illegal read syntax: #~D~C" infix-parameter sub-character))
  (let ((next-char (read-char stream)))
    (unless (find next-char "+-")
      (error "illegal read syntax: #~C~C" sub-character next-char))
    (when (let* ((*package* (find-package "KEYWORD"))
                 (*read-suppress* nil)
                 (not-p (char= next-char #\-))
                 (feature (read stream)))
            (if (feature-in-list-p feature *hunchentoot-features*)
                not-p
                (not not-p)))
      (let ((*read-suppress* t))
        (read stream t nil t))))
  (values))
