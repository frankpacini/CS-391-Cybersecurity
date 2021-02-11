(* reminder to self: record zoom *)

(*----------------------------------------------------*)

(* Keep the function declaration and stubs
   even if you cannot finish the assignment.
   The autograder requires everything to compile
   in order to give you a grade.
*)

(*----------------------------------------------------*)

(* ocaml repl demo *)
(* Load files into repl with "#use".
   Exit the repl and return to shell with "#quit".
   All repl commands should be followed by ";;".
*)

(*----------------------------------------------------*)

(* string vs char *)

(* string operations *)
(* Strings in ocaml are not lists of characters.
   Char operations CANNOT be used to manipulate strings.
   List operations CANNOT be used to manipulate strings.
   String have their own set of atomic operators.
*)

(*----------------------------------------------------*)

(* How to print stuff to the stdout *)

(* the baisc way *)

(* the formated way *)

(*----------------------------------------------------*)

(* Recursive functions *)

(* Recursive functions are defined using the "rec" keyword
 * right after a let declaration. The variable defined by
 * let must have parameters in order for it to be registered
 * as a function. Non-recursive functions do not need the
 * "rec" keyword. *)

(* standard factorial *)

(* tail recursive factorial *)

(* standard fibo  *)

(* tail recursive fibo *)

(* Compare performance of standard fibo to tail recursive fibo.
 * Why is there a large performance difference? *)

(* question to think about on you own:
 *  is there a general way to convert
 *  any recursive function to
 *  tail recursive form? *)
