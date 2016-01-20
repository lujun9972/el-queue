(require 'eieio)
(require 'queue)

(defclass queue-vector (queue)
  ((content :initform (vector) :initarg :content :protection :protected)
   (front 0)
   (rear 0)))

(defun queue-vector-create (capacity)
  (make-instance 'queue-vector :content (make-vector (+ 1 capacity) nil)))

(defmethod queue--content-length ((queue-object queue-vector))
  (length (queue-content queue-object)))

(defmethod queue-capacity ((queue-object queue-vector))
  (- (length (queue-content queue-object)) 1))

(defmethod queue-clear ((queue-object queue-vector))
  (setf (queue-content queue-object) (make-vector (queue--content-length queue-object) nil)) ;free vector elements
  (setf (oref queue-object front) 0)
  (setf (oref queue-object rear) 0))

(defmethod queue-length ((queue-object queue-vecto))
  (let ((front (oref queue-object front))
        (rear (oref queue-object rear))
        (content-length (queue--content-length queue-object)))
    (mod (- (+ rear content-length) front)
         content-length)))

(defmethod queue-empty-p ((queue-object queue-vector))
  (= 0 (queue-length queue-object)))

(defmethod queue-full-p ((queue-object queue-vector))
  (= (queue-length queue-object)
     (queue-capacity queue-object)))

(defmethod queue-get-head ((queue-object queue-vector))
  (when (queue-empty-p queue-object)
    (error "queue is empty"))
  (let ((front (oref queue-object front))
        (content (queue-content queue-object)))
    (aref content front)))

(defmethod queue-enqueue ((queue-object queue-vector) value)
  (when (queue-full-p queue-object)
    (error "queue is full"))
  (let ((rear (oref queue-object rear)))
    (setf (aref (queue-content queue-object) rear)
          value)
    (setf (oref queue-object rear)
          (mod (+ 1 rear) (queue--content-length queue-object))))
  queue-object)

(defmethod queue-deque ((queue-object queue-vector))
  (when (queue-empty-p queue-object)
    (error "queue is empty"))
  (let* ((front (oref queue-object front))
         (element (aref (queue-content queue-object) front)))
    (setf (aref (queue-content queue-object front) nil)) ;free array element
    (setf (oref queue-object front)
          (mod (+ 1 front) (queue--content-length queue-object)))))

(provide 'queue-vector)
