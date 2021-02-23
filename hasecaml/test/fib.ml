(* let rec fib n =
  if n <= 1 then n else
  fib (n - 1) + fib (n - 2) in
print_int (fib 30) *)

(* OK! *)

let rec fib n = 
  if n <= 1.0 then n else
  fib (n -. 1.2) +. fib (n -. 2.3) in
fib 10.1