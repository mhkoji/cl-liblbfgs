(defpackage :cl-liblbfgs.t.scenario.minimize-polynomial
  (:use :cl :cl-liblbfgs)
  (:export :minimize))
(in-package :cl-liblbfgs.t.scenario.minimize-polynomial)

;;; Minimize the polynominal f(x) = x^4 - 4x^3.
;;; The derivative is g(x) = 4x^3 - 12x^2, which is need for minimizing.
(cffi:defcallback evaluate lbfgsfloatval-t
    ((instance :pointer)
     (xs       :pointer)
     (g        :pointer)
     (n        :int)
     (step     lbfgsfloatval-t))
  (declare (ignore instance step))
  (let ((x (cffi:mem-ref xs 'lbfgsfloatval-t 0)))
    (let ((fx (- (* 1.0d0 x x x x) (* 4 x x x)))
          (gx (- (* 1.0d0 4 x x x) (* 12 x x))))
      (setf (cffi:mem-aref g 'lbfgsfloatval-t 0) gx)
      fx)))

(cffi:defcallback progress :int
    ((instance  :pointer)
     (xs        :pointer)
     (g         :pointer)
     (fx        lbfgsfloatval-t)
     (xnorm     lbfgsfloatval-t)
     (gnorm     lbfgsfloatval-t)
     (step      lbfgsfloatval-t)
     (n         :int)
     (k         :int)
     (ls        :int))
  (declare (ignore instance xs g n ls))
  (format t "Iteration ~A:~%" k)
  (format t "  fx = ~A~%" fx)
  (format t "  xnorm = ~A, gnorm = ~A, step = ~A%" xnorm gnorm step)
  (format t "~%")
  0)

(defun minimize-f ()
  (cffi:with-foreign-objects ((xs 'lbfgsfloatval-t 1)
                              (param '(:struct lbfgs-parameter-t)))
    (setf (cffi:mem-aref xs 'lbfgsfloatval-t 0) 100.0d0)
    (lbfgs-parameter-init param)
    (let ((ret (lbfgs 1
                      xs
                      (cffi:null-pointer)
                      (cffi:callback evaluate)
                      (cffi:callback progress)
                      (cffi:null-pointer)
                      param)))
      (format t "L-BFGS optimization terminated with status code = ~A~%"
              ret)
      (cffi:mem-aref xs 'lbfgsfloatval-t 0))))

(defmacro minimize (&key test)
  ;; The values of f(x) are minimized at x = 3.
  `(,test (< (abs (- (minimize-f) 3d0)) 1.0d-8)))
