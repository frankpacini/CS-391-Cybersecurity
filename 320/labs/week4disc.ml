
(* This file: https://piazza.com/bu/spring2021/cs320/resources *)
(* Zoom: https://bostonu.zoom.us/j/98373892388?pwd=aHR5RzNhMmVvaFNaOW1UckxlY3N6QT09 *)
(* Videos will be available in: https://learn.bu.edu/webapps/blackboard/content/listContentEditable.jsp?content_id=_8868652_1&course_id=_74834_1 *)

(* 
A2 CAS B25B Wed  8:00am  8:50am  Qiancheng "Robin" Fu 
A3 CAS B25B Wed  9:05am  9:55am  Qiancheng "Robin" Fu
A4 CAS 201  Wed 10:10am 11:00am  Qiancheng "Robin" Fu
A5 CAS 201  Wed 11:15am 12:05pm  Qiancheng "Robin" Fu
B2 CAS B06A Wed 12:20pm  1:10pm  Mark Lemay
B3 CAS B06A Wed  1:25pm  2:15pm  Mark Lemay
B4 CAS B06A Wed  2:30pm  3:20pm  Mark Lemay
B5 CAS B06A Wed  3:35pm  4:25pm  Mark Lemay
*)

(* record labs *)

let count i = 
  let rec aux i acc =
    if i >= 0
    then aux (i-1)  (i :: acc)
    else acc
 in aux i []

(* Tail recursive list reversal function. The standard library is
 * not magical. We will use this for defining other tail recursive
 * functions.
 *)

let rev ls =
  let rec aux ls acc =
    match ls with
    | [] -> acc
    | x :: ls -> aux ls (x :: acc)
  in aux ls []

let zip ls1 ls2 =
  let rec aux ls1 ls2 acc =
    match ls1, ls2 with
    | x :: ls1, y :: ls2 -> aux ls1 ls2 ((x, y) :: acc)
    | _ -> rev acc
  in aux ls1 ls2 []

(* The plan for today's lab is more advanced list combinators.
 * Last lab we have seen and used the filter list combinator
 * to easily implement a quicksort function. Filter gives us
 * the basic functionality of traversing a list and selecting
 * elements that satisfies a logical condition of our choosing.
 *
 * But what if we wanted to transform our list to another list?
 * What if we wanted to compute a value looping over our list?
 * Since we have the power of defining recursive functions, it
 * is possible for us to writing whatever list manipulating
 * function that suits our needs.
 *
 * Let us first consider a function that each takes a list of
 * integers and computes the factorial of each element,
 * returning a list of the results in a corresponding order.
 *)

let fact n =
  let rec aux i acc =
    if i <= 0 then acc
    else aux (i - 1) (i * acc)
  in aux n 1

let rec fact_of_list ls = failwith "unimplemented"

(* Now consider a function that computes the Fibonacci number
 * for each element in an integer list.
 *)

let fibo n =
  let rec aux i acc1 acc2 =
    if i <= 0 then acc1
    else aux (i - 1) acc2 (acc1 + acc2)
  in aux n 0 1

let rec fibo_of_list ls = failwith "unimplemented"

(* Notice that the overall structure of these two functions
 * are incredibly similar, they only differ in the function
 * that is applied the each element in the list.
 *
 * let rec fname (ls: int list) : int list =
 * match ls with
 * | []  -> []
 * | x :: ls -> (SomeFunction x) :: (fname ls)
 *
 * We want to parameterize SomeFunction in this list combinator
 * so that we may vary its mode of operation when we apply it.
 *)

let rec map f ls = failwith "unimplemented"

(* Now assuming we have an implementation of factorial and Fibonacci
 * on hand, we can easily implement fact_of_list and fibo_of_list
 * in terms of map_int. Here we rely again on Currying to omit
 * redundant mentions of arguments.
 *)

(* let fact_of_list = failwith "unimplemented" *)

(* let fibo_of_list = failwith "unimplemented" *)

(* Notice that map_int is not a tail recursive function. We can
 * give a better implementation. A great benefit of a tail recursive
 * combinator is that functions defined using it are
 * tail recursive (at its usage point).
 *)

(* let map f ls  = failwith "unimplemented" *)

(* Now what if we wanted to map a function on two lists at the
 * same time? We can accomplish this by first zipping both lists
 * together, then applying a function of type ((int * int) -> int)!
 *
 * Note: we are taking advantage of OCaml's type polymorphism here.
 *)

(* let map2 f  ls1 ls2 = failwith "unimplemented" *)

(* Often we will write this directly *)
(* We can now compute lists from lists using map. But how can we
 * iterate over a list and compute a single element? Let's first
 * look at an analogy from Python.
 *
 * acc = 0
 * for x in SomeList:
 *   acc = SomeFunction(x, acc)
 *
 * How can we define a function that provides the functionality of
 * a for loop? The following foldLeft function does just this.
 * FoldLeft iterates over a list argument ls, applying a parameterized
 * function (f) to each element and an accumulator.
 *)

let rec foldLeft f acc ls  = failwith "unimplemented"

(* Let's see how we can use foldLeft to define functions.
 *
 * Sum_of_list returns the sum of all elements in an integer list.
 * Mul_of_list returns the product of all elements in an integer list.
 *  *)

let sum_of_list ls = failwith "unimplemented"

let mul_of_list ls = failwith "unimplemented"

(* FoldLeft iterates starting from the left of the list, applying
 * f and works to the right. We can also define a variation that
 * works from right to left. The need for two versions is motivated
 * by functions that are not associative. Folding left -> right
 * can yield different results from folding right -> left in general.
 *)

let rec foldRight f acc ls = failwith "unimplemented"

(* Folding is extremely general, they can in actually be used to implement
 * all other list combinators! *)

(* let rev ls =  *)

(* let map f ls = *)

(* Standard Library Functions:
 * List.rev
 * List.map
 * List.map2
 * List.fold_left
 * List.fold_right
 *)
