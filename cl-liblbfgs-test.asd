(asdf:defsystem :cl-liblbfgs-test
  :serial t
  :pathname "t"
  :components
  ((:module :scenario
    :pathname "scenario"
    :components
    ((:file "minimize-polynomial")))

   (:file "fiveam"))

  :perform (asdf:test-op (o s)
             (funcall (intern (symbol-name :run!) :fiveam) :cl-liblbfgs))

  :depends-on (:cl-liblbfgs :fiveam))
