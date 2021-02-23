(* let rec f x = let l = Array.make 2 3 in l.(x) <- 3 in f 1 *)

(* let rec f x = x + 1 in pr (f) *)

(* let rec sum n = if n = 1 then 1 else n + sum (n - 1) in print_int (sum 10) *)

(* let rec f x = if x < 0.1 then 1 else 0 in print_int (f 0.1)  *)

(* let rec f a = let (x, y) = a in x + y in pr (f (1, 3)) *)
(* if (1, 2, 3) = (2, 3, 4) then print (1) else print (0) *)

(* tuple flatteninig test*)

(* print (1, (2, 3)) *)
(* (LET Ti1.7 (INT 1)(LET Ti2.9 (INT 2)(LET Ti3.10 (INT 3)(LET Tt4.8 (TUPLE Ti2.9Ti3.10)(LET Tt5.6 (TUPLE Ti1.7Tt4.8)(AppDir min_caml_print Tt5.6)))))) *)
(* 
let rec f a = let (x, y) = a in x + y in pr (f (1, 3))
f.5  args: a.6  fv:  body: (LETTUPLE TUPLE( x.11 y.12 ) a.6 (ADD x.11 y.12)
(LET Ti1.9 (INT 1)(LET Ti2.10 (INT 3)(LET Tt3.8 (TUPLE Ti1.9Ti2.10)(LET Ti4.7 (AppDir f.5 Tt3.8)(AppDir min_caml_pr Ti4.7)))) *)
(* 
let rec f x = x + 1 in
  let l = if (f 1) > 0 then (2, 3) else (1, 2) in
    let (x, y) = l in
      print_int (x + y) *)

(* let rec f x = x + 1 in
let l = if (f 2) > 1 then (0, 0) else (1, 1) in let (a, b) = l in print_int (a + b) *)

(* f (1, (2, 3)) *)

(* let rec f x = (x, x) in let (y, z) = f 1 in pr (y + z) *)

(* let rec f x = l.(0) <- 2; (x, x) in let (a, b) = f 1 in a + b *)
(* 
let a = x in let b = x *)

(* let rec f a = a in
let rec ack x y k = 
  k
  (if x <= 0 then y + 1 else
  if y <= 0 then ack (x - 1) 1 f
  else let rec g r = ack (x - 1) r f in ack x (y - 1) g)
  in print (ack 3 10 f) *)

(* let l = Array.make 7 0 in print_int(l.(5)) *)

(* let l = Array.make 3 2.1 in print_int(l.(1)) *)

(* let rec mycos x = 1.0 -. x *. x /. 4.0 in pr (mysin 3.1) *)

(* let l = int_to_float(1) in print_float(l) *)
(* print (3.0) *)

(* let rec f x = x + 1 in let y = if f 0 < 1 then f (f 0) else 0 in print_int (y) *)
(* let rec f x = if x < 55 then 0 else 999 in print (f 13) *)

(* let rec gcd m n =
  if m <= 0 then n else
  if m <= n then gcd m (n - m) else gcd n (m - n) in
  print_int (gcd 21600 337500) *)

    (* let rec ack x y =
      if x <= 0 then y + 1 else
      if y <= 0 then ack (x - 1) 1
      else           ack (x - 1) (ack x (y - 1)) in
  print_int (ack 3 10) *)

(* let rec ack2 x y k2 = k2
  (
  let rec f a = a in
  let rec ack x y k =
    k
    (if x <= 0 then y + 1 else
    if y <= 0 then ack (x - 1) 1 f
    else let rec g r = ack (x - 1) r f in ack x (y - 1) g)
    in ack x y f)
    in
    let rec pr r = print_int r
    in ack2 3 10 pr *)

(* prtint_int (-659048) *)

(* let rec f x = x -. 1.3 in print_float(f (f 1.2)) *)

(* let rec read_net_item length =
  let item = read_int () in
  if item = -1 then create_array (length + 1) (-1)
  else
    let v = read_net_item (length + 1) in
    (v.(length) <- item; v)
in  *)

(* let pi = 3.14159265 in
let rec kernel_sin x =
  x -. 0.16666668 *. x *. x *. x +. 0.008332824 *. x *. x *. x *. x *. x -. 0.0001958784 *. x *. x *. x *. x *. x *. x *. x in
let rec kernel_cos y =
  1.0 -. 0.5 *. y *. y +. 0.04166368 *. y *. y *. y *. y -. 0.001369506 *. y *. y *. y *. y *. y *. y in
let rec sin x =
  if x >= pi then -.(sin (x -. pi)) else 
  if x >= pi *. 0.5 then sin (pi -. x) else
  if x <= pi *. 0.25 then kernel_sin (x) else
  kernel_cos (pi *. 0.5 -. x) in
let rec cos y =
  if y >= pi then -.(cos (y -. pi)) else 
  if y >= pi *. 0.5 then -.(cos (pi -. y)) else
  if y <= pi *. 0.25 then kernel_cos (y) else
  kernel_sin (pi *. 0.5 -. y)
in cos 1. +. sin 2. *)

(* pr (3.1415926535) *)
(* let pi = 3.1415926535 in
let rec kernel_atan x = x -. 0.333333 *. x *. x *. x +. 0.2 *. x *. x *. x *. x *. x -. 0.142857142 *. x *. x *. x *. x *. x *. x *. x
  +.  0.111111104 *. x *. x *. x *. x *. x *. x *. x *. x *. x -. 0.08976446 *. x *. x *. x *. x *. x *. x *. x *. x *. x *. x *. x
  +. 0.060035485 *. x *. x *. x *. x *. x *. x *. x *. x *. x *. x *. x *. x *. x in
let rec min_caml_atan y = 
  if y < 0. then -.(min_caml_atan (-.y)) else
  if y < 0.4375 then kernel_atan y else
  if y < 2.4375 then pi *. 0.25 +. kernel_atan ((y -. 1.0) /. (y +. 1.0)) else
  pi *. 0.5 -. kernel_atan (1. /. y) 
in min_caml_atan 1.0 *)

(* let l1 = Array.make 3 0. in
  let a = Array.make 3 l1 in
    a.(0).(0) <- 1.; a.(0).(1) <- 2.; a.(0).(2) <- 3.;
    a.(1).(0) <- 4.; a.(1).(1) <- 5.; a.(1).(2) <- 6.;
    print_int (truncate a.(0).(0));
    print_char 10;
    print_int (truncate a.(0).(1));
    print_char 10;
    print_int (truncate a.(0).(2));
    print_char 10;
    print_int (truncate a.(1).(0));
    print_char 10;
    print_int (truncate a.(1).(1));
    print_char 10;
    print_int (truncate a.(1).(2));
    print_char 10 *)

(* 
    let dummy = Array.make 0 0. in
    let rec make m n =
      let mat = Array.make m dummy in
      let rec init i =
        if i < 0 then () else
        (mat.(i) <- Array.make n 0.;
         init (i - 1)) in
      init (m - 1);
      mat in
    let a = make 2 3 in
    a.(0).(0) <- 1.; a.(0).(1) <- 2.; a.(0).(2) <- 3.;
    a.(1).(0) <- 4.; a.(1).(1) <- 5.; a.(1).(2) <- 6.;
    print_int (truncate a.(0).(0));
    (* print_char 10; *)
    print_int (truncate a.(0).(1));
    (* print_char 10; *)
    print_int (truncate a.(0).(2));
    (* print_char 10; *)
    print_int (truncate a.(1).(0));
    (* print_char 10; *)
    print_int (truncate a.(1).(1));
    (* print_char 10; *)
    print_int (truncate a.(1).(2)); *)
    (* let dummy = Array.make 0 0 in
    let rec make m n =
      let mat = Array.make m dummy in
      let rec init i =
        if i < 0 then () else
        (mat.(i) <- Array.make n 0;
         init (i - 1)) in
      init (m - 1);
      mat in
    let a = make 2 3 in
    a.(0).(0) <- 1; a.(0).(1) <- 2; a.(0).(2) <- 3;
    a.(1).(0) <- 4; a.(1).(1) <- 5; a.(1).(2) <- 6;
    print_int ( a.(0).(0));
    print_int ( a.(0).(1));
    print_int ( a.(0).(2));
    print_int ( a.(1).(0));
    print_int ( a.(1).(1));
    print_int ( a.(1).(2)); *)
(* let rec f n =
let l = Array.make n 0 in
let rec init i =
  if i < 0 then () else
   ( l.(i) <- i;
   init (i - 1)) in 
   init (n - 1); l in
  let a = f 3 in
  print_int (a.(0));
  print_int (a.(1));
  print_int (a.(2))  *)


atan 1.