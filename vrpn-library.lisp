;;; This file was automatically generated by SWIG (http://www.swig.org).
;;; Version 3.0.0
;;;
;;; Do not make changes to this file unless you know what you are doing--modify
;;; the SWIG interface file instead.

(cl:in-package :vrpn)

(define-foreign-library (cl-vrpn :search-path (asdf:system-source-directory :vrpn))
  (:darwin (:framework "cl-vrpn"))
  (:windows "cl-vrpn.dll" :convention :stdcall)
  (:unix "libcl-vrpn.so"))

(use-foreign-library cl-vrpn)
