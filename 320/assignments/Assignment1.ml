(*
Honor code comes here:

First Name: Francis
Last Name: Pacini
BU ID: U01490529

I pledge that this program represents my own
program code and that I have coded on my own. I received
help from no one in designing and debugging my program.
I have read the course syllabus of CS 320 and have read the sections on Collaboration
and Academic Misconduct. I also understand that I may be asked to meet the instructor
or the TF for a follow up interview on Zoom. I may be asked to explain my solution in person and
may also ask you to solve a related problem.
*)



(* 
a print_list function useful for debugging.
*)

let rec print_list (ls: int list): unit =
  let rec aux ls = match ls with
    | [] -> print_string ""
    | e::[] -> print_int e
    | e::l -> 
      let _ = print_int e 
      in let _ = print_string "; " 
      in aux l

  in let _ = print_string "[" 
  in let _ = aux ls
  in         print_string "]" 

(* Problems *)

exception Foo

let is_empty (lst: int list) = 
  match lst with [] -> true | hd::tl -> false

let hd (lst: int list) = 
  match lst with [] -> raise Foo | hd::tl -> hd

let tl (lst: int list) = 
  match lst with [] -> raise Foo | hd::tl -> tl

let length ell = 
  let rec aux accum ell =
    match ell with
    | [] -> accum
    | hd :: tl -> aux (accum + 1) (tl)
  in aux 0 ell

let rev ell = 
  let rec aux accum ell = 
    match ell with
    | [] -> accum
    | hd::tl -> aux (hd::accum) tl
  in aux [] ell
(*
TODO: Write a function called between that lists the integers between two integers (inclusive)
If the first number is greater then the second return the empty list
the solution should be tail recursive

For example,
between 4 7 = [4; 5; 6; 7]
between 3 3 = [3]
between 10 2 = []
between 4 1000000 does not stack overflow
*)


let rec between (n:int) (e:int): int list = 
  if n > e then []
  else let rec aux x y accum = 
         if (match accum with 
             | [] -> false
             | hd::tl -> hd = x) then accum
         else aux x (y-1) (y::accum)
    in aux n e [];;
(*
TODO: Write a zip function that takes two lists of integers and combines them into a list of pairs of ints
If the two input list are of unequal lengths, combine as long as possible
your method should be tail recursive.

For example,
zip_int [1;2;3;5] [6;7;8;9] = [(1,6);(2,7);(3,8);(5,9)]
zip_int [1] [2;4;6;8] = [(1,2)]
zip_int (between 0 1000000) (between 0 1000000) does not stack overflow
*)

let zip_int (a: int list) (b: int list): (int * int) list = 
  let rec aux x y accum =
    if is_empty x || is_empty y then accum
    else aux (tl x) (tl y) (((hd x),(hd y))::accum)
  in rev(aux a b []);;

(*
TODO: Write a dotProduct function for lists of integers,
If the two list are of unequal lengths then return 0

For example,
dotProduct [1;2;3;4] [6;7;8;9] = 80            (since 1*6+2*7+3*8+4*9 = 80)
dotProduct [1;2;3;4] [6] = 0
*)

let rec dotProduct (x: int list) (y: int list): int = 
  if (length x) != (length y) then 0 
  else let rec aux x y accum =
         if (length x) = 0 then accum
         else aux (tl x) (tl y) ((hd x) * (hd y) + accum)
    in aux x y 0;;

(* 
TODO:
Write a function that takes a list of tuples and returns a string representation of that list

your representation should be valid as OCaml source:
* every element of a list must be separated by ";"
* the list must be wrapped in "[" and "]"
* tuples should (1,2)
* You may use whitespace however you like

For example,
list_of_tuple_as_string [(1,2);(3,4);(5,6)] = "[ (1,2); (3,4); (5,6) ]"
*)


let rec list_of_tuple_as_string (list: (int*int) list): string = 
  let rec aux lst accum = 
    match lst with 
    | [] -> accum
    | hd::tl -> let (e1, e2) = hd in 
      aux tl (accum ^ "(" ^ string_of_int(e1) ^ "," ^ string_of_int(e2) ^ ")" ^ (
          match tl with 
          | [] -> ""
          | h::t -> ";"
        ))
  in  (aux list "[") ^ "]";;

print_string(list_of_tuple_as_string [])

(* print_string(list_of_tuple_as_string [(1,2);(3,4);(5,6)]) *)

(* 
TODO:
Write an insertion sort function for lists of integers

for example,
sort [6;7;1] = [1;6;7]
*)

(* 
Hint: We encourage you to write the following helper function 

that takes a a number, an already sorted ls and returns a new sorted list with that number inserted
for example,
insert 5 [1;3;5;7] = [1;3;5;5;7]

You can  then call this helper function inside sort. 
*)

let rec insert (i: int) (list: int list): int list = 
  match list with 
  | [] -> [i]
  | hd::tl -> 
    if hd >= i then i::list
    else hd::(insert i tl);;

let rec sort (ls: int list): int list = 
  match ls with
  | [] -> []
  | hd::tl -> insert hd (sort tl);;