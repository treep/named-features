
(defpackage #:named-features
  (:use     #:common-lisp)
  (:export  #:feature-match-p
            #:define-features-list))

(in-package #:named-features)

(defun feature-match-p (feature list)
  "Is FEATURE (symbol or expression) match with features LIST?"
  (etypecase feature
    (keyword (find feature list))
    (symbol  (find (intern (string feature) (find-package "KEYWORD")) list))
    (cons    (flet ((subfeature-match-p (subfeature)
                      (feature-match-p subfeature list)))
               (ecase (first feature)
                 ((:or or)
                  (some  #'subfeature-match-p (rest feature)))
                 ((:and and)
                  (every #'subfeature-match-p (rest feature)))
                 ((:not not)
                  (let ((rest (rest feature)))
                    (if (or (null (first rest))
                            (rest rest))
                        (error "wrong number of terms in compound feature ~S"
                               feature)
                        (not (subfeature-match-p (second feature)))))))))))

(defmacro define-features-list (name &key initial-value documentation macro-character)
  "Define a new features list called NAME with related reader macro."
  `(progn
     (defparameter ,name ,initial-value ,documentation)
     (set-dispatch-macro-character
      #\#
      ,macro-character
      #'(lambda (stream sub-character infix-parameter)
          (when infix-parameter
            (error "illegal read syntax: #~D~C" infix-parameter sub-character))
          (let* ((next-char (read-char stream))
                 (plus-p
                  (case next-char
                    (#\+ t)
                    (#\- nil)
                    (t (error "illegal read syntax: #~C~C" sub-character next-char))))
                 (feature (read stream))
                 (match-p (not (null (feature-match-p feature ,name))))
                 (result (read stream t nil t)))
            (if match-p
                (if plus-p
                    result
                    (values))
                (if plus-p
                    (values)
                    result)))))))
