;; A chat server in 30 lines
;; -------------------------

;; First define classes for rooms and users. Make these subclasses of
;; `websocket-resource` and `websocket-client`.

(defpackage :my-chat (:use :cl))
(in-package :my-chat)

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload :hunchensocket))

(use-package '(:hunchentoot :hunchensocket))

(defclass easy-websocket-acceptor (websocket-acceptor easy-acceptor) ()
  (:documentation "Special easy WebSocket acceptor"))

(defclass chat-room (hunchensocket:websocket-resource)
  ((name :initarg :name :initform (error "Name this room!") :reader name))
  (:default-initargs :client-class 'user))

(defclass channel ()
  ((name :initarg :name :initform (error "Name this channel!") :reader name)
   (clients :accessor clients :initform nil)))

(defclass user (hunchensocket:websocket-client)
  ((name :initarg :user-agent :reader name :initform (error "Name this user!"))))

;; Define a list of rooms. Notice that
;; `hunchensocket:*websocket-dispatch-table*` works just like
;; `hunchentoot:*dispatch-table*`, but for websocket specific resources.

(defvar *room* nil)
(defvar *user* nil)

(defvar *channels* nil)

(defvar *chat-rooms* (list (make-instance 'chat-room :name "/bongo")
                           (make-instance 'chat-room :name "/fury")))

(defun find-room (request)
  (find (hunchentoot:script-name request) *chat-rooms* :test #'string= :key #'name))

(pushnew 'find-room hunchensocket:*websocket-dispatch-table*)

(defun find-channel (name)
  (find name *channels* :test #'string= :key #'name))

;; OK, now a helper function and the dynamics of a chat room.

(defun broadcast-except (client room message &rest args)
  (loop for peer in (hunchensocket:clients room)
     do (if (eq client peer) T
	    (hunchensocket:send-text-message peer (apply #'format nil message args)))))

(defun broadcast (room message &rest args)
  (loop for peer in (hunchensocket:clients room)
        do (hunchensocket:send-text-message peer (apply #'format nil message args))))

(defmethod hunchensocket:client-connected ((room chat-room) user)
  (broadcast room "~a has joined ~a" (name user) (name room)))

(defmethod hunchensocket:client-disconnected ((room chat-room) user)
  (broadcast room "~a has left ~a" (name user) (name room)))

(defun eval-message (message)
  (format t "PRE-EVAL::~s::~s~%" (name *user*) message)
  (let ((ret (eval (read-from-string message))))
    (format t "POSTEVAL::~s::~s::~s~%" (name *user*) message ret)
    ret))

(defmethod hunchensocket:text-message-received ((*room* chat-room) *user* message)
  (declare (special *user* *room*))
  (if (eq #\( (schar message 0)) (eval-message message)
      (broadcast *room* "~a says ~a" (name *user*) message)))

;; Finally, start the server. `hunchensocket:websocket-acceptor` works
;; just like `hunchentoot:acceptor`, and you can probably also use
;; `hunchensocket:websocket-ssl-acceptor`.

(defvar *server* (make-instance 'easy-websocket-acceptor
				:port 1234 :document-root "c/"))

(defun main (&rest argv)
  (declare (ignorable argv))
  (hunchentoot:start *server*)
  (sleep 1000))

;; Now open two browser windows on http://www.websocket.org/echo.html,
;; enter `ws://localhost:12345/bongo` as the host and play around chatting with
;; yourself.
