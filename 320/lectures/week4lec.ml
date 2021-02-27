let div x y = x/.y

let div x y =
  if y = 0. then None
  else Some (x/.y)

let print_option_float f = 
  match f with
  | None -> print_string "None"
  | Some x -> print_float x

let slope p1 p2 = 
  match p1, p2 with
  | (x1, y1), (x2, y2) -> 
    if x2 -. x1 = 0. then None
    else Some ((y2-.y1) /. (x2-.x1))

let slopenew p1 p2 =
  let (x1, y1),(x2, y2)=p1,p2 in
  if (x2-.x1=0.) then None
  else Some ((y2-.y1)/.(x2-.x1))

let sum ls =
  let rec aux ls acc = 
    match ls with
    | [] -> None
    | [x] -> Some (acc+x)
    | h::t -> aux t (acc + h)
  in aux ls 0

let rec map f l =
  match l with
  | [] -> []
  | h::t -> f h :: map f t 

let _ = sum ([]);;

let _ =
  print_option_float(slope (0., 0.) (2., 2.));;