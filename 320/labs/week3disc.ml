let rec lesser0 (x: int) (ls: int list): int list =
  match ls with
  | []-> []
  | head::tail ->
    if head < x
    then head::(lesser0 x tail)
    else lesser0 x tail;;

lesser0 3 [1;444;32;2;5;3]
;;

let rec greater0 (x: int) (ls: int list): int list =
  match ls with
  | [] -> []
  | head::tail ->
    if head >= x
    then head::(greater0 x tail)
    else greater0 x tail;;

let rec qsort0 (ls: int list): int list =
  match ls with
  | [] -> []
  | pivot::tail ->
    let l = lesser0 pivot tail in
    let g = greater0 pivot tail
    in qsort0 l @ [pivot] @ qsort0 g;;

qsort0 [1;444;32;2;5;3]
;;

(* Sort by absolute value *)
(* Compare x to abs(head) in greater0 and lesser0*)


let rec filter_int
    (p: int -> bool) (* condition expressed as a function *)
    (ls: int list)  (* list input*)
  : int list
  = match ls with
  | [] -> []
  | head::tail ->
    let res = filter_int p tail in
    if p head
    then head::res
    else res;;

filter_int (fun x -> x > 3) [1;2;3;4;5];;
filter_int (fun _ -> true) [1;2;3;4;5];;
filter_int (fun x -> x > 1) [1;2;3;4;5];;

let lesser1 (x: int) (ls: int list): int list = 
  filter_int (fun y -> y < x) ls

let greater1 (x: int) (ls: int list): int list = 
  filter_int (fun y -> y > x) ls