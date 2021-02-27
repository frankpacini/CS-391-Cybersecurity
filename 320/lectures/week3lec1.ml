let person = ("Larry", 47, 165.3, 'M')
let person1 = ("Larry", "Dawson", 47, 165.3, 'M')
let point1 = (3.14, 2.1, 4.56)

let add x y = fun x y -> x+y
let add1 (x,y)=x+y


let rec print_list l =
  match l with
  | [] -> ()
  | head::tail -> 
    print_int head; 
    print_string " "; 
    print_list tail

let print_person p = 
  match p with
  | (n,a,w,g) -> 
    print_string n;
    print_string " ";
    print_int a;
    print_string " ";
    print_float w;
    print_string " ";
    print_char g;;

let _ =
  print_person person

let rec quicksort l = 
  match l with
  | [] -> []
  | head::tail -> 
    (quicksort(List.filter (fun x-> x < head) tail) )
    @ [head] 
    @ (quicksort(List.filter (fun x-> x>head) tail))

let rec mergesort l = 
  match l with
  | [] -> []
  | [x] -> l
  | _ -> let (left,right)=split l [] []
             mergesort left mergesort right
