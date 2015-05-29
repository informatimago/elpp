#!/bin/sh
# This is a shell archive (produced by GNU sharutils 4.11.1).
# To extract the files from this archive, save it to some FILE, remove
# everything before the `#!/bin/sh' line above, then type `sh FILE'.
#
lock_dir=_sh25873
# Made on 2012-05-15 13:00 CEST by <pjb@kuiper>.
# Source directory was `/local/home/pjb/src/miscellaneous/emacs/elpp'.
#
# Existing files will *not* be overwritten, unless `-c' is specified.
#
# This shar contains:
# length mode       name
# ------ ---------- ------------------------------------------
#   6252 -rw-r--r-- cgen.el
#    292 -rw-r--r-- elppc.el
#   9159 -rw-r--r-- elpp.el
#
MD5SUM=${MD5SUM-md5sum}
f=`${MD5SUM} --version | egrep '^md5sum .*(core|text)utils'`
test -n "${f}" && md5check=true || md5check=false
${md5check} || \
  echo 'Note: not verifying md5sums.  Consider installing GNU coreutils.'
if test "X$1" = "X-c"
then keep_file=''
else keep_file=true
fi
echo=echo
save_IFS="${IFS}"
IFS="${IFS}:"
gettext_dir=
locale_dir=
set_echo=false

for dir in $PATH
do
  if test -f $dir/gettext \
     && ($dir/gettext --version >/dev/null 2>&1)
  then
    case `$dir/gettext --version 2>&1 | sed 1q` in
      *GNU*) gettext_dir=$dir
      set_echo=true
      break ;;
    esac
  fi
done

if ${set_echo}
then
  set_echo=false
  for dir in $PATH
  do
    if test -f $dir/shar \
       && ($dir/shar --print-text-domain-dir >/dev/null 2>&1)
    then
      locale_dir=`$dir/shar --print-text-domain-dir`
      set_echo=true
      break
    fi
  done

  if ${set_echo}
  then
    TEXTDOMAINDIR=$locale_dir
    export TEXTDOMAINDIR
    TEXTDOMAIN=sharutils
    export TEXTDOMAIN
    echo="$gettext_dir/gettext -s"
  fi
fi
IFS="$save_IFS"
if (echo "testing\c"; echo 1,2,3) | grep c >/dev/null
then if (echo -n test; echo 1,2,3) | grep n >/dev/null
     then shar_n= shar_c='
'
     else shar_n=-n shar_c= ; fi
else shar_n= shar_c='\c' ; fi
f=shar-touch.$$
st1=200112312359.59
st2=123123592001.59
st2tr=123123592001.5 # old SysV 14-char limit
st3=1231235901

if touch -am -t ${st1} ${f} >/dev/null 2>&1 && \
   test ! -f ${st1} && test -f ${f}; then
  shar_touch='touch -am -t $1$2$3$4$5$6.$7 "$8"'

elif touch -am ${st2} ${f} >/dev/null 2>&1 && \
   test ! -f ${st2} && test ! -f ${st2tr} && test -f ${f}; then
  shar_touch='touch -am $3$4$5$6$1$2.$7 "$8"'

elif touch -am ${st3} ${f} >/dev/null 2>&1 && \
   test ! -f ${st3} && test -f ${f}; then
  shar_touch='touch -am $3$4$5$6$2 "$8"'

else
  shar_touch=:
  echo
  ${echo} 'WARNING: not restoring timestamps.  Consider getting and
installing GNU `touch'\'', distributed in GNU coreutils...'
  echo
fi
rm -f ${st1} ${st2} ${st2tr} ${st3} ${f}
#
if test ! -d ${lock_dir} ; then :
else ${echo} "lock directory ${lock_dir} exists"
     exit 1
fi
if mkdir ${lock_dir}
then ${echo} "x - created lock directory ${lock_dir}."
else ${echo} "x - failed to create lock directory ${lock_dir}."
     exit 1
fi
# ============= cgen.el ==============
if test -n "${keep_file}" && test -f 'cgen.el'
then
${echo} "x - SKIPPING cgen.el (file already exists)"
else
${echo} "x - extracting cgen.el (text)"
  sed 's/^X//' << 'SHAR_EOF' > 'cgen.el' &&
;;; Commentary:
X
;; Useful functions for autogenerating C and C++ code.
;; This package is not meant to be complete. Rather, it is meant to establish
;; a consistent method for generating C code.
X
;; Usage:
X
;; This package is basically designed to build a string which represents
;; your program. Building strings turns out to be more appropriate than
;; accumulating data into a buffer, as will become evident shortly. This
;; string can then be `insert'ed into a buffer using `c-out'.
X
;; Typical use involves calling `c-pretty' to pretty-print chunks of your
;; code, `c-print' to accumulate several statements together, and `c-out'
;; to insert into a buffer. Other functions in this package allow you to
;; build statements (`c-statement'), conditionals, assignments, comparisons,
;; etc.
;;
;; To generate the code
;;
;; if ( test_situation(vv) ) {
;;   b = a;
;; }
;;
;; You would call:
;;
;; (c-if (c-funcall "test_situation" '(vv))
;;       (c-block (c-statement (c-assignment "b" "a"))))
;;
;; The reason for accumulating things into strings rather than buffers
;; should be apparent now: `c-funcall' is evaluated before `c-if', and
;; if it `c-funcall' had the side affect of inserting into a buffer, the
;; output of c-if would happen after the call to test_situation(). Which
;; is bogus. There are hacks around this, but who wants to do that??
X
;; Bugs:
X
;; Strings are not a good way to accumulate things. Rather, a union data
;; structure should be used. I'll do this soon. I'ts just a matter of
;; replacing `c-print' and `c-out' with the right things.
X
X
;;; Code:
X
(require 'cl)
X
X
(defun c-print (&rest code)
X  "Concatenate a series of C expressions together."
X  (apply 'concat (mapcar (lambda (x) (prin1-to-string x t)) code)))
X
(defun c-out (&rest code)
X  "Insert expressions into the current buffer."
X  (insert (apply 'c-print code)))
X
(defun c-pretty (&rest code)
X  "Format the expressions. Does not output to a buffer."
X  (let ((old-buffer (current-buffer)))
X    (prog1
X	(let ((cbuf (generate-new-buffer "*c-indentifyer*")))
X	  (set-buffer cbuf)
X	  (c-out code)
X	  (c-mode)
X	  (c-indent-region (point-min) (point-max))
X	  (prog1 (buffer-string) (kill-buffer cbuf)))
X      (set-buffer old-buffer))))
X
(defun c-var-decl (type name)
X  (c-print type " " name ";"))
X
(defun c-header (return name args)
X  "Output a function header. The only difference with `c-proto' is the
formatting.
This function is mostly used to generate function declarations. It does
not output a semicolon."
X  (c-print return " " name "( " (c-args args) " )"))
X
(defun c-proto (return name args)
X  "Output function prototype.
See documentation for `c-entitle-args' for more info on ARGS.
This function is mostly used to generate function declarations."
X  (c-print return "\n" name "( "  (c-args args) " )"))
X
(defun c-function (return name args body)
X  "Generate function definiton.
See documentation for `c-entitle-args' for more info on ARGS. BODY is a
block."
X  (c-print (c-proto return name args) (c-block body) "\n\n"))
X
(defun c-function2 (proto body)
X  "Second form of `c-function'.
PROTO is the result of a `c-proto'."
X  (c-print proto (c-block body) "\n\n"))
X
(defun c-if (condition yes &optional no)
X  "Generate a conditional.
Optional argument NO results in an else clause being generated."
X  (c-print "if( " condition " )" yes "\n"
X	   (if no (c-print "else" no) "")))
X
(defun c-block (code)
X  (c-print "\n{\n" code "}\n"))
X
(defun c-statement (&rest code)
X  "Turns the elements of CODE into semicolon separate statements."
X  (apply #'c-print
X	 (mapcar (lambda (stm) (c-print stm ";\n")) code)))
X
(defun c-assignment (lhs rhs)
X  (c-print lhs " = " rhs))
X
(defun c-eq (lhs rhs)
X  (c-print lhs " == " rhs))
X
(defun c-identifier (&rest strings)
X  "Build up an identifier name from its parts.
Variable names such as foo_1, foo_2, foo_3 can be generated by
X calling (c-identifier "foo" 1) (c-identifier "foo" 2) (c-identifer "foo" 3)."
X  (apply 'c-print strings))
X
(defun c-funcall (func args)
X  "Generate a function call.
ARGS is a list of argument names."
X  (c-print func "( " (if (car args) (car args) "")
X	   (apply 'c-print (mapcar (lambda (v) (c-print ", " v)) (cdr args)))
X	   " )"))
X
(defun c-comment (&rest comments)
X  (c-print "// " (apply #'c-print comments) "\n"))
X
(defun var-type (var) (car var))
(defun var-name (var) (cadr var))
(defun var-named-p (var) (caddr var))
X
(defun c-entitle-args (args &optional arg-num)
X  "Accepts a list of the form
X
((TYPE1 [NAME1]) (TYPE2 [NAME2]) (TYPE3 [NAME3]) ...)
X
TYPEi must always be specified, but NAMEi is optional. If NAMEi
is omitted, the string \"argi\" will be used instead. If there is
only one type in the argument list, you may use \"TYPE\" instead of
((TYPE)), or (TYPE NAME) instead of ((TYPE NAME))."
X  (cond
X   ((null args) args)
X   ((and (consp args) (consp (car args)))
X    (cons
X     (if (var-name (car args))
X	 (append (car args) '(t))
X       (list (var-type (car args))
X	     (c-identifier "arg" (number-to-string (if arg-num arg-num 1)))
X	     'nil))
X     (c-entitle-args (cdr args) (1+ (if arg-num arg-num 1)))))
X
X    ((consp args) (c-entitle-args (list args)))
X    (t (c-entitle-args (list (list args))))))
X
(defun c-args (args)
X  "Generate an argument list for function decl or defn.
See `c-entitle-args' for info on how to specify argument lists."
X  (c-print
X   (var-type (car args)) " " (var-name (car args))
X   (apply 'c-print
X	  (mapcar (lambda (arg)
X		    (c-print ", " (var-type arg) " " (var-name arg)))
X		  (cdr args)))))
X
(defun c-commaify-list (lst)
X  "Outputs the elements of the, separating each element with a comma."
X  (c-print (car lst)
X	   (apply 'c-print
X		  (mapcar (lambda (arg) (c-print ", " arg))  (cdr lst)))))
X
(defun c-pointerify-variable (var)
X  "Turns a var decl into a pointer decl.
VAR is an element of an args list suitable for `c-entitle-args'."
X  (list  (c-identifier (var-type var) "* ") (var-name var) (var-named-p var)))
X
(defun c-pointerify-variables (vars)
X  "Pointerify all the variables in VARS.
VARS has the same format as args in `c-entitle-args'."
X  (mapcar 'c-pointerify-variable vars))
X
(defun c-list-to-array (lst)
X  (if (atom lst) (c-print lst)
X    (c-print "\n{ "
X	     (c-commaify-list (mapcar 'list-to-array lst))
X	     " }")))
SHAR_EOF
  (set 20 08 09 16 22 54 14 'cgen.el'
   eval "${shar_touch}") && \
  chmod 0644 'cgen.el'
if test $? -ne 0
then ${echo} "restore of cgen.el failed"
fi
  if ${md5check}
  then (
       ${MD5SUM} -c >/dev/null 2>&1 || ${echo} 'cgen.el': 'MD5 check failed'
       ) << \SHAR_EOF
bf1a03d501ddf573d26142de8aa80f8e  cgen.el
SHAR_EOF
  else
test `LC_ALL=C wc -c < 'cgen.el'` -ne 6252 && \
  ${echo} "restoration warning:  size of 'cgen.el' is not 6252"
  fi
fi
# ============= elppc.el ==============
if test -n "${keep_file}" && test -f 'elppc.el'
then
${echo} "x - SKIPPING elppc.el (file already exists)"
else
${echo} "x - extracting elppc.el (text)"
  sed 's/^X//' << 'SHAR_EOF' > 'elppc.el' &&
;; ELPP routines specific for C and C++.
X
X
X
(elpp-defun elpp-def-struct-field (fnames type name &optional docstring)
X  "Defines a field in a structure. Adds the field info to the list of
fields, fnames."
X  (if fnames (add-to-list fnames (list type name docstring)))
X  (c-var-decl type name))
SHAR_EOF
  (set 20 08 09 16 22 54 14 'elppc.el'
   eval "${shar_touch}") && \
  chmod 0644 'elppc.el'
if test $? -ne 0
then ${echo} "restore of elppc.el failed"
fi
  if ${md5check}
  then (
       ${MD5SUM} -c >/dev/null 2>&1 || ${echo} 'elppc.el': 'MD5 check failed'
       ) << \SHAR_EOF
46826ae203e4d3c2169efc1934c2b3a1  elppc.el
SHAR_EOF
  else
test `LC_ALL=C wc -c < 'elppc.el'` -ne 292 && \
  ${echo} "restoration warning:  size of 'elppc.el' is not 292"
  fi
fi
# ============= elpp.el ==============
if test -n "${keep_file}" && test -f 'elpp.el'
then
${echo} "x - SKIPPING elpp.el (file already exists)"
else
${echo} "x - extracting elpp.el (text)"
  sed 's/^X//' << 'SHAR_EOF' > 'elpp.el' &&
;;; Elpp | Ali Rahimi | ali@xcf.berkeley.edu
;;; Elisp PreProcessor |
;;; Time-stamp: <1998-10-17 13:04:12 ali> | 0.9 |
X
;;; Commentary:
X
;; Allows arbitrary elisp code to be embedded within your source code.
;; The main function, elpp-process, takes an input buffer, finds the lisp
;; expressions therein, evaluates them, and substitutes them an output buffer
;; by their value.
X
;; Expressions must be declared before they can be recognized in a source
;; file. You can do this with either elpp-defun or elpp-macro. If you don't
;; wish to declare new functions or macros, you can use elpp-eval.
X
X
;; Usage:
X
;; This package is most useful when run by emacs in batch mode. I typically
;; define some file "codegen.el" which contains something like:
;;
;;    (defun process-all-my-code ()
;;       (load "elpp.el")
;;       (find-file "foo.C") (find-file "foo.c") (elpp-process "foo.C" "foo.c")
;;       (find-file "bar.C") (find-file "bar.c") (elpp-process "bar.C" "bar.c")
;;     )
;;
;; An example C program that uses Elpp:
;;
;;  (elpp-defvar elements '(0 1 2 3))
;;
;;  (elpp-defun arrangements (lst &optional prn)
;;   "Computes all the permutations of the elements in LST. Returns a list of
;;  the permutations."
;;   (if (null lst) (list prn)
;;     (mapcan (lambda (x) (arrangements (remove x lst) (cons x prn))) lst)))
;;
;;  (elpp-defun list-to-array (lst)
;;    (cond ((symbolp lst) (symbol-name lst))
;;  	    ((numberp lst) (number-to-string lst))
;;  	    (t (concat "\n{ "
;;  		       (apply 'concat
;;  			      (list-to-array  (car lst))
;;  			      (mapcar (lambda (l)
;;  				        (concat ", " (list-to-array l)))
;;  				      (cdr lst)))
;;  		       " }"))))
;;
;;  (elpp-defun perm-tab-list () (list-to-array (arrangements elements)))
;;
;;  (elpp-defun n-perms (&optional n) (length (arrangements elements)))
;;
;;
;;  void
;;  permute(const char *lst, char *out, int mode)
;;  {
;;    int i;
;;    int permutation_tab[(n-perms)][(elpp-eval (length elements))] =
;;  				 (perm-tab-list);
;;    for(i=0; i<(elpp-eval (length elements)); ++i)
;;      out[i] = lst[permutation_tab[mode][i]];
;;  }
;;
;;
;; See cgen.el if you are interested in having your Lisp expression
;; autogenerate C or C++ code. I have trouble justifying the use of
;; elpp in C programming without using cgen.el.
X
;;; Bugs and Requests:
X
;; There will be lots, and there will be features that you will want that
;; will be lacking. Mail ali@xcf.berkeley.edu.
X
;;; Code:
X
X
(require 'cl)
X
X
X
(defvar *elpp-macro-list* '("elpp-defun")
X  "List of Lisp function names recognized by ELPP.
This starts off with only `elpp-defun', and is added to by
`elpp-defun' as ELPP and user defined functions are created. I know
Emacs people don't like stars bracketting global function names, but
that's how we did it when I was a boy, and that's how we're gonna do
it for a while longer.")
X
X
(defun elpp-function-p (fname)
X  "Returns true if string FNAME is an ELPP recognized function name."
X  (member fname *elpp-macro-list*))
X
X
(defmacro elpp-defmacro (name arglist &rest body)
X  "Used in source to define an ELPP macro for use in source code.
The name of the macro is added to `*elpp-macro-list*'."
X  (add-to-list '*elpp-macro-list* (symbol-name name))
X  `(progn ,(append (list 'defmacro name arglist) body) ""))
X
X
(defmacro elpp-defun (name arglist &rest body)
X  "Used in source to define an ELPP function for use in source code.
The name of the function is added to `*elpp-macro-list*'."
X  (add-to-list '*elpp-macro-list* (symbol-name name))
X  `(progn ,(append (list 'defun name arglist) body) ""))
X
X
(elpp-defun elpp-eval (&rest r)
X	    "Used in source to evaluate arbirary Lisp expressions.
The return value of this expression is substituted for the expression
in the source."
X	    (car (last r)))
X
(elpp-defmacro elpp-defvar (vname value &optional docstring)
X	       "Used in source to define a variable."
X	       `(progn (defvar ,vname ,value ,docstring) ""))
X
X
(defun eval-exp-1 ()
X  "A useful eval which evaluates the expression at point. Unlike
eval-last-sexp (which evaluates the sexp before point) returns the
result of the expression."
X  (let ((ts (point)))
X      (eval (read (buffer-substring ts (forward-list))))))
X
X
(defun elpp-process (inbuf outbuf)
X  "Preprocess a source file in buffer INBUF and dump the result into OUTBUF.
Normally, the elpp source functions elpp-defun, elpp-macro, elpp-defvar,
and elpp-eval are defined. These can be used in INBUF to create new elpp
symbols."
X  (interactive "bTemplate buffer: \nbOutput buffer: ")
X  (save-excursion
X    (set-buffer outbuf)
X    (erase-buffer)
X
X    (set-buffer inbuf)
X    (lisp-mode)                ; needed for eval-exp-1.
X    (goto-char (point-min))
X
X    (while (not (equal (point) (point-max)))
X      ; Copy everything from here to the next '(' to the output buffer.
X      (let ((ts (point))
X	    (tm (point-max))
X	    (te (search-forward "(" nil t)))
X
X	(set-buffer outbuf)
X
X	(if (null te) (insert-buffer-substring inbuf ts tm)
X
X	   ; everything up to the potential sexp to outbuf.
X	  (insert-buffer-substring inbuf ts (1- te)) (goto-char (point-max))
X
X	  (set-buffer inbuf) (point)
X	  ; see whether the "(" is actually a sexp we can use.
X	  (let ((ts (point))
X		(te (re-search-forward "[^ \n\t()]+" nil t)))
X	    (if (and te (elpp-function-p (buffer-substring ts te)))
X		; need to go to the end of the expression now.
X		(progn (goto-char (1- ts))
X		       (princ (prog1 (eval-exp-1) (set-buffer outbuf)) #'insert)
X		       (set-buffer inbuf))
X
X	      ; It was not a sexp afterall. Output the (. The rest will
X	      ; be taken care of. Just make sure the input is rolled back
X	      ; to the (.
X	      (set-buffer outbuf)
X	      (insert "(")
X	      (set-buffer inbuf)
X	      (goto-char ts)
X	      ))))
X      )))
X
X
(elpp-defmacro elpp-template-begin (tname)
X  "Defines a template called TNAME.
Everything from the end of this funcall to the beginning of the matching
call to `elpp-template-end' is treated as the content of TNAME.
Elpp expressions in the template are not evaluated at this time.
Substitutions will happen when the template is instantiated.
X
There is a lameness herein, because `elpp-template-end' is actually not an
elpp symbol. It's actually just searched for as a dumb string."
;  `(progn (setq ,tname `(,(current-buffer) ,(point) nil nil)) ""))
X  (let ((tts (point)))
X    ; Skip to the matching elpp-template-end.
X    (if (re-search-forward (concat
X			    "(elpp-template-end[ \t$]+"
X			    (symbol-name tname)
X			    "[ \t$]*)") nil nil)
X	       `(progn (setq ,tname
X			     '(,(current-buffer) ,tts ,(search-backward "(")
X			       nil))
X		       (setf (cadddr ,tname) (buffer-substring (cadr ,tname)
X							    (caddr ,tname)))
X		       "")
X      )))
X
(elpp-defun elpp-template-end (tname)
X  "This is a noop, since elpp-template-begin did all the work already."
X  "")
X
X
X
(defun define-template-macros (substs)
X  "Creates a function for each of the substitutions in substs. The name
of each function will be the car of each element in SUBSTS. Each of these
functions is defined with elpp-defmacro and evaluates to the cadr of each
element in SUBSTS."
X  (mapcar (lambda (sub)
X	    (eval (list 'elpp-defun (car sub) nil (cadr sub))))
X	  substs))
X
X
(elpp-defun elpp-template-instantiate (tname substs)
X  "Instantiates the template TNAME by performing the substitutions defined
by SUBSTS.
The substitutions take on the same form they do in `let', with each element
of SUBST being a list, the `car' of each of which issymbol name to substitute
for, and the `cadr' of which is an expression to that the `car' should
evaluate to.
The template then `elpp-process'ed, with each symbol in SUBST defining an
elpp source function which evaluates to the value of the symbol.
X
Verbose rambling aside, here's what you do to get 'foo bar moof bafbaf baz':
X
(elpp-template-begin TT)
foo bar (fluff) (flap) baz
(elpp-template-end TT)
X
(elpp-template-instantiate TT '((fluff moof) (flap bafbaf)))"
X  (let ((*elpp-macro-list* *elpp-macro-list*)
X	(tempbuf           (generate-new-buffer "*template*"))
X	(instbuf           (generate-new-buffer "*template-instance*"))
X	(oldbuf            (current-buffer)))
X
X    (define-template-macros substs)
X
X    (set-buffer tempbuf)
X    (insert (cadddr tname))
X
X    (elpp-process tempbuf instbuf)
X
X    (set-buffer instbuf)
X    (prog1
X	(buffer-string)
X      (kill-buffer tempbuf)
X      (kill-buffer instbuf)
X      (set-buffer oldbuf))
X    ))
X
X
(elpp-defun elpp-annotate-table (titles tab)
X	    "Annotates the columns of TAB with elements of TITLES.
TAB is of the form ((A1 A2 A3 ...)
X                    (B1 B2 B3 ...)
X                    ...)
Titles is an array of symbols with which to annotate the elements of TAB.
The result of annotating the above table with the titles (C1 C2 C2) is
X
X                   (((C1 A1) (C2 A2) (C3 A3))
X                    ((C1 B1) (C2 B2) (C3 B3))
X                    ...)
X
This function is often useful when lists of template substitution values
are being created, and `elpp-template-instatiate' is about to be called
on each element of the annotated list."
X	    (mapcar (lambda (entry) (mapcar* 'list titles entry)) tab))
SHAR_EOF
  (set 20 08 09 16 22 54 14 'elpp.el'
   eval "${shar_touch}") && \
  chmod 0644 'elpp.el'
if test $? -ne 0
then ${echo} "restore of elpp.el failed"
fi
  if ${md5check}
  then (
       ${MD5SUM} -c >/dev/null 2>&1 || ${echo} 'elpp.el': 'MD5 check failed'
       ) << \SHAR_EOF
862d61c1a81bcf61e232fe582170a740  elpp.el
SHAR_EOF
  else
test `LC_ALL=C wc -c < 'elpp.el'` -ne 9159 && \
  ${echo} "restoration warning:  size of 'elpp.el' is not 9159"
  fi
fi
if rm -fr ${lock_dir}
then ${echo} "x - removed lock directory ${lock_dir}."
else ${echo} "x - failed to remove lock directory ${lock_dir}."
     exit 1
fi
exit 0
