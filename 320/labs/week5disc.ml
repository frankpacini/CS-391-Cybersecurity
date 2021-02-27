let rec safe_index (ls: 'a list) (i: int) : 'a option =
  match ls with
  | [] -> None
  | h::t -> 
    if i = 0 then Some h 
    else safe_index t (i-1)

let rec rev (ls: 'a list) : 'a list =
  let rec aux ls acc =
    match ls with
    | [] -> []
    | h::t -> aux t (h::acc)
  in aux ls []


let rec keepjust (ao: ('a option) list) : 'a list =
  let rec aux ao acc =
    match ao with
    | [] -> []
    | None::t -> aux t acc
    | (Some h)::t -> aux t (h::acc)
  in rev (aux ao [])


let flatten (ao: 'a option option) : 'a option =
  match ao with
  | None -> None
  | Some x -> x

let map (f: 'a -> 'b) (ao: 'a option): 'b option =
  match ao with 
  | None -> None
  | Some a -> Some (f a)

