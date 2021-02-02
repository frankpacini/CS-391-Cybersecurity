let rec factorial = fun x -> 
  if x=1 then 1
  else factorial (x-1)*x

let factorialt x = 
  let rec aux accum x =
    if x = 1 then accum
    else aux (accum*x) (x-1)
  in aux 1 x

let _ =
  print_int(factorial 5);
  print_int(factorialt 5)