(defpackage cl-liblbfgs.t.fiveam
  (:use :cl :fiveam))
(in-package :cl-liblibfgs.t.fiveam)
(def-suite :cl-liblbfgs)
(in-suite :cl-liblbfgs)

(test minimize-polynomial
  (cl-liblbfgs.t.scenario.minimize-polynomial:minimize :test is))
