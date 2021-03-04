(* stack *)

type 'a stack = 'a list

(* stack functions *)

let empty_stack () : 'a stack = []

let push (x: 'a) (st: 'a stack) : 'a stack = x::st

let pop (st : 'a stack) : 'a stack = 
  match st with 
  | [] -> []
  | h::t -> t

let peek (st: 'a stack) : 'a option =
  match st with 
  | [] -> None
  | h::t -> Some h

let x = empty_stack ();;

let x = push "frank" x
let x = push "cs320" x
let x = push "BU" x

let x = pop x

let v = peek x

(* naive queue *)

type 'a queue = 'a list

let empty_queue () : 'a queue = []

let enqueue (x: 'a) (q: 'a queue) : 'a queue = x::q

let dequeue (q: 'a queue) : 'a queue =
  let rq = List.rev q in
  match rq with 
  | [] -> []
  | _::q -> List.rev q

let last (q: 'a queue) : 'a option = 
  let rq = List.rev q in
  match rq with 
  | [] -> None
  | x::q -> Some x


(* better queue *)

type 'a queue = ('a list * 'a list)

let empty_queue () : 'a queue = ([], [])

let enqueue (x: 'a) (q: 'a queue) =
  let (l, r) = q in (x::l, r)

let dequeue (q: 'a queue) = 
  let (l, r) = q in
  match r with
  | _::r -> (l, r)
  | [] ->
    match List.rev l with
    | _::r -> ([], r)
    | [] -> ([], [])

let last (q: 'a queue) : 'a option =
  let (l, r) = q in
  match r with
  | x::_ -> Some x
  | [] -> 
    match List.rev l with
    | x::_ -> Some x
    | [] -> None
  

  (* binary tree *)

type 'a tree = 
  | Leaf
  | Node of 'a * 'a tree * 'a tree

let empty_tree () = Leaf

let rec insert_tree (compare: 'a -> 'a -> bool) (x: 'a) (t: 'a tree) =
  match t with
  | Leaf -> Node(x, Leaf, Leaf)
  | Node(y, t1, t2) -> 
    if compare x y then  
      let t1 = (insert_tree compare x t1) in Node(y, t1, t2)
    else let t2 = (insert_tree compare x t2) in Node (y, t1, t2)

let rec flatten (t: 'a tree) : 'a list =
  match t with 
  | Leaf -> []
  | Node (x, t1, t2) -> 
    x :: (flatten t1) @ (flatten t2)

let rec invert (t: 'a tree) : 'a tree =
  match t with
  | Leaf -> Leaf
  | Node (x,l,r) -> 
    let l = invert l in 
    let r = invert r in
    Node(x,r,l)

let l = [5; 1; 6; 2; 9; 0; 3; 4; 8; 7]

(* insertion into tree *)

let t = List.fold_left 
  (fun acc x -> insert_tree (<) x acc)
  (empty_tree ()) l

(* fold tree *)

let rec fold (f: 'a -> 'b -> 'b -> 'b) (acc: 'b) (t: 'a tree) : 'b =
  match t with
  | Leaf -> acc
  | Node (a,l,r) ->
    let l = fold f acc l in
    let r = fold f acc r in
    f a l r

let sum_tree (t: int tree) : int =
  fold (fun v l r -> v + l + r) 0 t
