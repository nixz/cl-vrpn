;;;; -*- Mode: Lisp; indent-tabs-mode: nil -*-
;;;; ==========================================================================
;;;; shell-script.lisp --- start applicationa and redirect input output and error streams
;;;;
;;;; Copyright (c) 2017, Nikhil Shetty <nikhil.j.shetty@gmail.com>
;;;;   All rights reserved.
;;;;
;;;; Redistribution and use in source and binary forms, with or without
;;;; modification, are permitted provided that the following conditions
;;;; are met:
;;;;
;;;;  o Redistributions of source code must retain the above copyright
;;;;    notice, this list of conditions and the following disclaimer.
;;;;  o Redistributions in binary form must reproduce the above copyright
;;;;    notice, this list of conditions and the following disclaimer in the
;;;;    documentation and/or other materials provided with the distribution.
;;;;  o Neither the name of the author nor the names of the contributors may
;;;;    be used to endorse or promote products derived from this software
;;;;    without specific prior written permission.
;;;;
;;;; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
;;;; "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
;;;; LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
;;;; A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT
;;;; OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
;;;; SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
;;;; LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
;;;; DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
;;;; THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
;;;; (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
;;;; OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
;;;; ==========================================================================

(ql:quickload :external-program)

(defparameter *process*
  (external-program:start "/home/nshetty/lisp/cl-vrpn/build/print-vrpn-sexp"
                          (list "Tracker0@localhost")
                          :input  :stream
                          :output :stream
                          :error  :stream)) 

(defparameter *output*
  (external-program:process-output-stream *process*)) 

(defparameter *input*
  (external-program:process-input-stream *process*)))

(defparameter *error*
  (external-program:process-error-stream *process*)) 


(defun read-the-output () (read *output*))

(as:poll (sb-sys:fd-stream-fd *output*) #'read-the-output :poll-for :readable)

(defun work (operation)
  "Run `operation` in a background thread, and resolve the returned promise with
   the result(s) of the operation once complete. The promise will be resolved on
   the same thread `(work ...)` was spawned from (your event-loop thread)."
  (bb:with-promise (resolve reject :resolve-fn resolver)
    (let* ((err nil)
           (result nil)
           (notifier (as:make-notifier (lambda ()
                                         (if err
                                             (reject err)
                                             (apply resolver result))))))
      (bt:make-thread (lambda ()
                        (handler-case
                          (setf result (multiple-value-list (funcall operation)))
                          (t (e) (setf err e)))
                        (as:trigger-notifier notifier))))))

(as:with-event-loop ()
  (as:with-delay (1) (format t "event loop still running...~%"))
  (bb:catcher
    (alet ((val (work (read *output*))))
      (format t "got val: ~a~%" val))
    (t (e) (format t "err: ~a~%" e))))
