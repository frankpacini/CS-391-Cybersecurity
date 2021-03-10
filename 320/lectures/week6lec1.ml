let rec fold_right f l b =
  match l with
  | [] -> b
  | h::t -> f h (fold_right f t b)


let rec fold_left f l b =
  match l with 
  | [] -> b
  | h::t -> fold_left f t (f h b)

let fold_left f l b =
  let rec aux f l acc =
    match l with
    | [] -> acc
    | h::t -> aux f t (f h acc)
  in aux f l b 

let heads l = List.map (fun x -> List.nth x 0) l

let flip f y x = f x y

let heads2 l = List.map (flip List.nth 0) l 

type nat = Zero | Succ of nat

let z = Zero
let o = Succ Zero

let rec convert_nat_to_int n =
  match n with
  | Zero -> 0
  | Succ x -> 1 + convert_nat_to_int x

type 'a binaryTree = Empty | Node of ('a binaryTree * 'a * 'a binaryTree)


