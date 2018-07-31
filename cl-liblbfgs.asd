(asdf:defsystem :cl-liblbfgs
  :serial t
  :pathname "src"
  :components ((:file "liblbfgs"))
  :depends-on (:cffi))
