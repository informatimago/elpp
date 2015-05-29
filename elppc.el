;; ELPP routines specific for C and C++.



(elpp-defun elpp-def-struct-field (fnames type name &optional docstring)
  "Defines a field in a structure. Adds the field info to the list of
fields, fnames."
  (if fnames (add-to-list fnames (list type name docstring)))
  (c-var-decl type name))
