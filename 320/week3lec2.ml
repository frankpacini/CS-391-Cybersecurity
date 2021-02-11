let rec mergesort ls f =
  let split ls =
    let rec aux ls left right = 
      match ls with
      | [] -> (left, right)
      | head::tail -> 
          aux tail right (head::left) 
    in aux ls [] []
  in

  let rev ell = 
    let rec aux accum ell = 
      match ell with
      | [] -> accum
      | hd::tl -> aux (hd::accum) tl
    in aux [] ell
  in 

  let merge left right =
    let rec aux ls left right =
      match left, right with
      | [], [] -> ls
      | _, [] -> rev left @ ls
      | [], _ -> rev right @ ls
      | headx::tailx, heady::taily -> 
        if f headx heady then aux (headx::ls) tailx right
        else aux (heady::ls) left taily
    in rev(aux [] left right)
  in

  match ls with
  | []->[]
  | [x] -> ls
  | _ -> let (left,right)= split ls
    in merge (mergesort left f) (mergesort right f)

let _ = mergesort [6;5;1;2;0] (fun x y -> x>y);;

(* given list of characters sorted, return list of tuples of the 
unique characters with their num of occurrences *)

let encode ls = 
  let rec aux count acc ls =
    match ls with
    | [] -> acc
    | [x] -> (x,count+1)::acc
    | head1::(head2::tail as t) -> 
      if head1 = head2 then aux (count+1) acc t
      else aux 0 ((head1,count+1)::acc) t
  in aux 0 [] ls