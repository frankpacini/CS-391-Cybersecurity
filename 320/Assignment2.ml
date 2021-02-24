(*
Honor code comes here:

First Name:
Last Name:
BU ID:

I pledge that this program represents my own
program code and that I have coded on my own. I received
help from no one in designing and debugging my program.
I have read the course syllabus of CS 320 and have read the sections on Collaboration
and Academic Misconduct. I also understand that I may be asked to meet the instructor
or the TF for a follow up interview on Zoom. I may be asked to explain my solution in person and
may also ask you to solve a related problem.
*)

(*
Write a safe_zip_int function that takes two lists of integers and combines them into a list of pairs of ints
If the two input list are of unequal lengths, return None
your method must be tail recursive.

For example,
safe_zip_int [1;2;3;5] [6;7;8;9] = Some [(1,6);(2,7);(3,8);(5,9)]
safe_zip_int [1] [2;4;6;8] = None
safe_zip_int (between 0 1000000) (between 0 1000000) does not stack overflow

Note: The between function is from the previous programming assignment 1. 
You can use the between function from the previous assignment for testing purposes. 
*)

let rec between (n:int) (e:int): int list = 
   if n > e then []
   else let rec aux x y accum = 
          if (match accum with 
              | [] -> false
              | hd::tl -> hd = x) then accum
          else aux x (y-1) (y::accum)
     in aux n e [];;

let rev ell = 
   let rec aux accum ell = 
     match ell with
     | [] -> accum
     | hd::tl -> aux (hd::accum) tl
   in aux [] ell


let rec safe_zip_int (ls1: int list) (ls2: int list) : ((int * int) list) option =
   let rec aux ls1 ls2 acc = 
      match ls1, ls2 with
      | [], [] -> Some (rev acc)
      | _, [] -> None
      | [], _ -> None
      | h1::t1, h2::t2 -> aux t1 t2 ((h1,h2)::acc)
   in aux ls1 ls2 []

(*
Write a function that produces the ith Pell number:
https://en.wikipedia.org/wiki/Pell_number
https://oeis.org/A000129
your function must be tail recursive, and needs to have the correct output up to integer overflow

pell 0 = 0
pell 1 = 1
pell 7 = 169
pell 1000000  does not stack overflow
*)


let rec pell (i: int) : int = 
   let rec aux i p1 p2 = 
      if i = 0 then 0
      else if i = 1 then p2
      else aux (i-1) p2 (2 * p2 + p1)
    in aux i 0 1

(* The nth Tetranacci number T(n) is mathematically defined as follows.
 *
 *      T(0) = 0
 *      T(1) = 1
 *      T(2) = 1
 *      T(3) = 2
 *      T(n) = T(n-1) + T(n-2) + T(n-3) + T(n-4)
 *
 * For more information, you may consult online sources.
 *
 *    https://en.wikipedia.org/wiki/Generalizations_of_Fibonacci_numbers
 *    https://mathworld.wolfram.com/TetranacciNumber.html
 *
 * Write a tail recursive function tetra that computes the nth Tetranacci
 * number efficiently. In particular, large inputs such as (tetra 1000000)
 * should neither cause stackoverflow nor timeout.
*)

let tetra (n : int) : int = 
   let rec aux n t1 t2 t3 t4 = 
      if n = 0 then 0
      else if n = 1 then 1
      else if n = 2 then 1
      else if n = 3 then t4
      else aux (n-1) t2 t3 t4 (t4 + t3 + t2 + t1)
   in aux n 0 1 1 2


(*
infinite precision natural numbers can be represented as lists of ints between 0 and 9

Write a function that takes an integer and represents it with a list of integers between 0 and 9 where the head 
of the list holds the least signifigant digit and the very last element of the list represents the most significant digit.
If the input is negative return None. We provide you with some use cases:

For example:
toDec 1234 = Some [4; 3; 2; 1]
toDec 0 = Some []
toDec -1234 = None
*)

(* Hint use 
   mod 10
   / 10
*)

let rec toDec (i : int) : int list option = 
   let rec aux i acc =
      if i < 0 then None
      else if i = 0 then Some (rev acc)
      else aux (i/10) ((i mod 10)::acc)
   in aux i []

(*
Write a function that sums 2 natrual numbers as represented by a list of integers between 0 and 9 where the head is the least signifigant digit.
Your function should be tail recursive

sum [4; 3; 2; 1] [1;0;1] = [5; 3; 3; 1]
sum [1] [9;9;9] = [0; 0; 0; 1]
sum [] [] = []
sum (nines 1000000) [1] does not stack overflow, when (nines 1000000) provides a list of 1000000 9s
*)

let extract o =
   match o with
   | Some i -> i
   | None -> []

let nines i = 
   let rec aux i acc =
      if i = 0 then acc
      else aux (i-1) (9::acc)
   in aux i []

let rec sum (a : int list) (b : int list) (carry : int) : int list = 
   let rec aux a b carry acc = 
      match a, b with
      | [], [] -> 
         if carry == 0 then rev acc
         else aux [] [] 0 (carry::acc) 
      | [], h::t -> aux [] t ((h + carry) / 10) (((h + carry) mod 10)::acc)
      | h::t, [] -> aux t [] ((h + carry) / 10) (((h + carry) mod 10)::acc)
      | h1::t1, h2::t2 -> aux t1 t2 ((h1 + h2 + carry) / 10) (((h1 + h2 + carry) mod 10)::acc)
   in aux a b carry []   


   (* let a = sum [4; 3; 2; 1] [1;0;1] 0;;
   let a = sum [1] [9;9;9] 0 ;;
   let a = sum [] [] 0;;
   let a = tetra 27;;
   let a = tetra 28;;
   let a = sum (extract (toDec (tetra 27))) (extract (toDec (tetra 28))) 0;;
   let a = sum (nines 1000000) [1] 0;; *)


(*
Write an infinite precision version of the pel function from before

pell2 0 = []
pell2 1 = [1]
pell2 7 = [9; 6; 1]
pell2 50 = [2; 2; 5; 3; 5; 1; 4; 2; 9; 2; 4; 6; 2; 5; 7; 6; 6; 8; 4]

Hint: You may want to use the sum function from above again inside 
pell2. 

*)

let rec pell2 (i: int) : int list = 
   let rec aux i p1 p2 = 
      if i = 0 then [0]
      else if i = 1 then p2
      else aux (i-1) p2 (sum (sum p2 p2 0) p1 0)
    in aux i [0] [1]
   
   let a = pell2 50;;
