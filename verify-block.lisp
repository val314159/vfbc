#|-*- mode:lisp -*-
exec ros -Q -- $0 "$@" # |#
(progn ;;init forms
  (ros:ensure-asdf)
  #+quicklisp(ql:quickload '(:hunchensocket :websocket-driver :cffi) :silent t)
  )

(defpackage :ros.script.verify-block.3831993281
  (:use :cl :hunchentoot :hunchensocket :websocket-driver :cffi))
(in-package :ros.script.verify-block.3831993281)

(defun main (&rest argv)
  (declare (ignorable argv))

  
  
  T)
;;; vim: set ft=lisp lisp:
