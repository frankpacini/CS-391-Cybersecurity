let f = fun a b -> a+b
let f1 (a:int) (b:int) = a+b

let rec factorial = fun x ->
  if x=1 then 1
  else 
    factorial(x-1)*x

let factorial2 = fun x ->
  let rec aux = fun accum x ->
    if x = 1 then accum
    else aux (accum*x) (x-1)
  in aux 1 x

let _ = 
  print_int (factorial 5);