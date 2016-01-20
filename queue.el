(require 'eieio)

(defclass queue ()
  ((content :initarg :content :accessor queue-content :protection :protected :documentation "content of the queue"))
  :abstract t)

(defgeneric queue-clear (queue-object)
  "Remove all elements in queue")

(defgeneric queue-empty-p (queue-object)
  "wether queue is empty")

(defgeneric queue-full-p (queue-object)
  "wether queue is full")

(defgeneric queue-get-head (queue-object)
  "return head element in queue")

(defgeneric queue-enqueue (queue-object value)
  "push Value to the end of queue")

(defgeneric queue-dequeue (queue-object)
  "Remove and return head element in queue")

(defgeneric queue-length (queue-object)
  "Return the total number of elements in queue")

(provide 'queue)
