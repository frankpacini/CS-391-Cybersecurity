let rec factorial = fun x -> 
  if x=1 then 1
  else factorial (x-1)*x

let factorialt x = 
  let rec aux accum x =
    if x = 1 then accum
    else aux (accum*x) (x-1)
  in aux 1 x

let rec length ell = 
  match ell with 
  | [] -> 0
  | hd :: tl -> 1 + length tl

let lengtht ell = 
  let rec aux accum ell =
    match ell with
    | [] -> accum
    | hd :: tl -> aux (accum + 1) (tl)
  in aux 0 ell

let reverset ell =
  let rec aux accum ell =
    match ell with 
    | [] -> accum
    | hd :: tl -> aux (hd::accum) tl
  in aux [] ell

let _ =
  print_int(length [1;2]);
  print_int(lengtht [])