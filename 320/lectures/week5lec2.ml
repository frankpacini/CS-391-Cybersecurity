let length l = List.fold_right (fun x y -> 1 + y) l 0

let toUppercase l = List.fold_right (fun x y -> String.uppercase x :: y) l []

let ($$)f g = fun x -> f (g x)

let toUppercaseClean l = List.fold_right (List.cons $$ String.uppercase) l []

let sum l = List.fold_right (+) l 0

let fancy l = List.map (abs $$ sum) l

let sumMatrix m = List.fold_right ((+) $$ sum) m 0

(* let test (a: int list * unit) (b: float list) : float =
  match (a,b) with
  | ([], x), [] -> 0.
  | ([], x), hd::tl -> hd
  | (hd::tl, x), [] -> float hd
  | (hdx::tlx, x), hdy::tly -> float hdx +. hdy;;

test ([1], ()) [1.] *)

let foo1 ls = 
  let rec aux ls a =
    match ls with 
    | [] -> a
    | hd::tl -> aux tl (hd +. a)
  in aux ls 0.

let rec foo2 ls =
  match ls with
  | [] -> 1
  | hd::tl -> hd + (foo2 tl);;

foo1([1.; 2.; 3.; 4.]);;

foo2([1; 2; 3; 4]);;