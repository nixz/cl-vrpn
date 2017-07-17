;;;; -*- Mode: Lisp; indent-tabs-mode: nil -*-
;;;; ==========================================================================
;;;; clientTest.lisp --- 
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

(in-package :vrpn)

;; Make instance of DTrack analog device
(defparameter *DTrack-Analog*
  (make-instance 'vrpn::vrpn-analog-remote :name "Tracker0@localhost"))
(defparameter *DTrack-Button*
  (make-instance 'vrpn::vrpn-button-remote :name "Tracker0@localhost"))
(defparameter *DTrack-Tracker*
  (make-instance 'vrpn::vrpn-tracker-remote :name "Tracker0@localhost"))

;; define callback
(defcallback analog-cb :void ((ptr :pointer) (userdata vrpn_ANALOGCB))
  (format t "~& analog ~a called ~%"
          (cffi:foreign-slot-value userdata 'vrpn_ANALOGCB 'msg-time))
  (format t "~& ------------- ~%"))

;; define callback
(defcallback button-cb :void ((ptr :pointer) (userdata vrpn_BUTTONCB))
  (format t "~& button ~a state  ~%"
          (cffi:foreign-slot-value userdata 'vrpn_BUTTONCB 'state))
  (format t "~& ------------- ~%"))

;; define callback
(defcallback tracker-cb :void ((ptr :pointer) (userdata vrpn_TRACKERCB))
  (format t "~& tracker called ~%")
  (format t "~& ------------- ~%"))


;; register the call back with *DTRACK-analog*
(register-change-handler *DTrack-Analog* (null-pointer) (callback analog-cb))
(unregister-change-handler *DTrack-Analog* (null-pointer) (callback analog-cb))

(register-change-handler *DTrack-Button* (null-pointer) (callback button-cb))
(unregister-change-handler *DTrack-Button* (null-pointer) (callback button-cb))

(register-change-handler *DTrack-Tracker* (null-pointer) (callback tracker-cb))
(unregister-change-handler *DTrack-Tracker* (null-pointer) (callback tracker-cb))

;; Start the main loop
(loop (prog
          (mainloop *DTRACK-Analog*)
         (mainloop *DTRACK-Button*)
         (mainloop *DTRACK-Tracker*)))
