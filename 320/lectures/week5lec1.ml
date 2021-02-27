let rec map f l =
  match l with
  | [] -> []
  | h::t -> f h::map f t

let rec filter f l =
  match l with 
  | [] -> []
  | h::t -> 
    if f h then h::filter f t
    else filter f t

let multiply l = List.fold_right ( * ) l 0;;

let concat l1 l2 = List.fold_right List.cons l1 l2

let reverse l = List.fold_right (fun x rest -> rest @ [x]) l [];;

(*Given list of all lower case letters, return list of all upper case letters using List.fold_right*)
let toUpperCase l = List.fold_right (fun x y -> String.uppercase x :: y) l [];;