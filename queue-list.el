(require 'eieio)
(require 'queue)

(defclass queue-list (queue)
  ((content :initform nil :initarg :content :protection :protected)
   (reversed-content :initform nil :initarg :content :protection :protected)))

(defun queue-list-create ()
  (make-instance 'queue-list))

(defmethod queue-rearrange ((queue-object queue-list))
  (setf (oref queue-object content)
        (append (oref queue-object content)
                (reverse (oref queue-object reversed-content))))
  (setf (oref queue-object reversed-content) nil))

(defmethod queue-content ((queue-object queue-list))
  (queue-rearrange queue-object)
  (oref queue-object content))

(defmethod queue-clear ((queue-object queue-list))
  (setf (oref queue-object content) nil)
  (setf (oref queue-object reversed-content) nil))

(defmethod queue-length ((queue-object queue-list))
  (length (queue-content queue-object)))

(defmethod queue-empty-p ((queue-object queue-list))
  (and (null (oref queue-object content))
       (null (oref queue-object reversed-content))))

(defmethod queue-get-head ((queue-object queue-list))
  (when (queue-empty-p queue-object)
    (error "queue is empty"))
  (let ((content (oref queue-object content))
        (reversed-content (oref queue-object reversed-content)))
    (if content
        (car content)
      (car (queue-content queue-object)))))

(defmethod queue-enqueue ((queue-object queue-list) value)
  (setf (oref queue-object reversed-content)
        (cons value (oref queue-object reversed-content)))
  queue-object)

(defmethod queue-dequeue ((queue-object queue-list))
  (when (queue-empty-p queue-object)
    (error "queue is empty"))
  (let ((content (oref queue-object content))
        (reversed-content (oref queue-object reversed-content))
        head-element)
    (if content
        (progn
          (setq head-element (car content))
          (setf (oref queue-object content) (cdr content)))
      (queue-rearrange queue-object)
      (queue-dequeue queue-object))))
