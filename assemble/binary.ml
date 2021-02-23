open  Instruction

let label_list = ref []
let jp_list = ref []

let rec pow a n = 
  if n = 0 then 1
  else a * (pow a (n - 1))

let rec out_bit_plus oc n keta =
  if keta = 0 then () else (out_bit_plus oc (n / 2) (keta - 1); Printf.fprintf oc ("%d") (n mod 2))

let rec out_bit oc n keta =
  if n < 0 
  then out_bit_plus oc (n + (pow 2 keta)) keta
  else out_bit_plus oc n keta

let rec assocmem x l = match l with
  | [] -> false
  | (a, b)::rest -> if x = a then true else assocmem x rest

 (* 機械語は op,rs,rt,rd,shamt,funct *)
(* 
*)
let h oc ins = 
  match ins with
  | RdRsRt (`Add, gp1, gp2, gp3) -> Printf.fprintf oc ("000000"); out_bit oc gp2 5; out_bit oc gp3 5; out_bit oc gp1 5; out_bit oc 0 5; Printf.fprintf oc ("100000\n");
  | RdRsRt (`Sub, gp1, gp2, gp3) -> Printf.fprintf oc ("000000"); out_bit oc gp2 5; out_bit oc gp3 5; out_bit oc gp1 5; out_bit oc 0 5; Printf.fprintf oc ("100010\n");
  | RdRsRt (`And, gp1, gp2, gp3) -> Printf.fprintf oc ("000000"); out_bit oc gp2 5; out_bit oc gp3 5; out_bit oc gp1 5; out_bit oc 0 5; Printf.fprintf oc ("100100\n");
  | RdRsRt (`Or, gp1, gp2, gp3) -> Printf.fprintf oc ("000000"); out_bit oc gp2 5; out_bit oc gp3 5; out_bit oc gp1 5; out_bit oc 0 5; Printf.fprintf oc ("100101\n");
  | RdRsRt (`Slt, gp1, gp2, gp3) -> Printf.fprintf oc ("000000"); out_bit oc gp2 5; out_bit oc gp3 5; out_bit oc gp1 5; out_bit oc 0 5; Printf.fprintf oc ("101010\n");
  | RdRsRt (`Fadd, gp1, gp2, gp3) -> Printf.fprintf oc ("010001"); out_bit oc gp2 5; out_bit oc gp3 5; out_bit oc gp1 5; out_bit oc 16 5; Printf.fprintf oc ("000000\n");
  | RdRsRt (`Fsub, gp1, gp2, gp3) -> Printf.fprintf oc ("010001"); out_bit oc gp2 5; out_bit oc gp3 5; out_bit oc gp1 5; out_bit oc 16 5; Printf.fprintf oc ("000001\n");
  | RdRsRt (`Fmul, gp1, gp2, gp3) -> Printf.fprintf oc ("010001"); out_bit oc gp2 5; out_bit oc gp3 5; out_bit oc gp1 5; out_bit oc 16 5; Printf.fprintf oc ("000010\n");
  | RdRsRt (`Fdiv, gp1, gp2, gp3) -> Printf.fprintf oc ("010001"); out_bit oc gp2 5; out_bit oc gp3 5; out_bit oc gp1 5; out_bit oc 16 5; Printf.fprintf oc ("000011\n");
  | RdRsRt (`Feq, gp1, gp2, gp3) -> Printf.fprintf oc ("010001"); out_bit oc gp2 5; out_bit oc gp3 5; out_bit oc gp1 5; out_bit oc 16 5; Printf.fprintf oc ("110010\n");
  | RdRsRt (`Flt, gp1, gp2, gp3) -> Printf.fprintf oc ("010001"); out_bit oc gp2 5; out_bit oc gp3 5; out_bit oc gp1 5; out_bit oc 16 5; Printf.fprintf oc ("111100\n");
  (* こいつらはI形式だけどめんどくさいんで。*)
  | RdRsRt (`Lw2, gp1, gp2, gp3) -> Printf.fprintf oc ("101101"); out_bit oc gp2 5; out_bit oc gp1 5; out_bit oc gp3 5; out_bit oc 0 5; Printf.fprintf oc ("000000\n");
  | RdRsRt (`Sw2, gp1, gp2, gp3) -> Printf.fprintf oc ("101110"); out_bit oc gp2 5; out_bit oc gp1 5; out_bit oc gp3 5; out_bit oc 0 5; Printf.fprintf oc ("000000\n");

  | RdRsRti (`FAddi, gp1, gp2, gp3) ->
   if gp3 < 32 then
    (Printf.fprintf oc ("010001"); out_bit oc gp2 5; out_bit oc gp3 5; out_bit oc gp1 5; out_bit oc 19 5; Printf.fprintf oc ("000000\n"))
    else 
   (Printf.fprintf oc ("010001"); out_bit oc gp2 5; out_bit oc (gp3 - 32) 5; out_bit oc gp1 5; out_bit oc 20 5; Printf.fprintf oc ("000000\n"))
  | RdRsRti (`FSubi, gp1, gp2, gp3) -> 
  if gp3 < 32 then
    (Printf.fprintf oc ("010001"); out_bit oc gp2 5; out_bit oc gp3 5; out_bit oc gp1 5; out_bit oc 19 5; Printf.fprintf oc ("000001\n"))
    else 
   (Printf.fprintf oc ("010001"); out_bit oc gp2 5; out_bit oc (gp3 - 32) 5; out_bit oc gp1 5; out_bit oc 20 5; Printf.fprintf oc ("000001\n")) 
  | RdRsRti (`FMuli, gp1, gp2, gp3) -> 
  if gp3 < 32 then
  (Printf.fprintf oc ("010001"); out_bit oc gp2 5; out_bit oc gp3 5; out_bit oc gp1 5; out_bit oc 19 5; Printf.fprintf oc ("000010\n"))
  else 
 (Printf.fprintf oc ("010001"); out_bit oc gp2 5; out_bit oc (gp3 - 32) 5; out_bit oc gp1 5; out_bit oc 20 5; Printf.fprintf oc ("000010\n"))
  | RdRsRti (`FDivi, gp1, gp2, gp3) ->
  if gp3 < 32 then
  (Printf.fprintf oc ("010001"); out_bit oc gp2 5; out_bit oc gp3 5; out_bit oc gp1 5; out_bit oc 19 5; Printf.fprintf oc ("000011\n"))
  else 
 (Printf.fprintf oc ("010001"); out_bit oc gp2 5; out_bit oc (gp3 - 32) 5; out_bit oc gp1 5; out_bit oc 20 5; Printf.fprintf oc ("000011\n"))
  | RdRsRti (`FSubi2, gp1, gp2, gp3) -> 
   if gp2 < 32 then
    (Printf.fprintf oc ("010001"); out_bit oc gp2 5; out_bit oc gp3 5; out_bit oc gp1 5; out_bit oc 17 5; Printf.fprintf oc ("000001\n"))
    else 
    (Printf.fprintf oc ("010001"); out_bit oc (gp2 - 32) 5; out_bit oc gp3 5; out_bit oc gp1 5; out_bit oc 18 5; Printf.fprintf oc ("000001\n"))
  | RdRsRti (`FDivi2, gp1, gp2, gp3) -> 
    if gp2 < 32 then
    (Printf.fprintf oc ("010001"); out_bit oc gp2 5; out_bit oc gp3 5; out_bit oc gp1 5; out_bit oc 17 5; Printf.fprintf oc ("000011\n"))
    else 
    (Printf.fprintf oc ("010001"); out_bit oc (gp2 - 32) 5; out_bit oc gp3 5; out_bit oc gp1 5; out_bit oc 18 5; Printf.fprintf oc ("000011\n"))
  | RdRs (`Sqrt, gp1, gp2) -> Printf.fprintf oc ("010001"); out_bit oc gp2 5; out_bit oc 0 5; out_bit oc gp1 5; out_bit oc 16 5; Printf.fprintf oc ("000100\n");
  | RdRs (`Floor, gp1, gp2) -> Printf.fprintf oc ("010001"); out_bit oc gp2 5; out_bit oc 0 5; out_bit oc gp1 5; out_bit oc 16 5; Printf.fprintf oc ("000101\n");
  | RdRs (`Ftoi, gp1, gp2) -> Printf.fprintf oc ("010001"); out_bit oc gp2 5; out_bit oc 0 5; out_bit oc gp1 5; out_bit oc 16 5; Printf.fprintf oc ("000110\n");
  | RdRs (`Itof, gp1, gp2) -> Printf.fprintf oc ("010001"); out_bit oc gp2 5; out_bit oc 0 5; out_bit oc gp1 5; out_bit oc 16 5; Printf.fprintf oc ("000111\n");
  | RdRtshamt (`Sll, gp1, gp2, i) -> Printf.fprintf oc ("000000"); out_bit oc 0 5; out_bit oc gp2 5; out_bit oc gp1 5; out_bit oc i 5; Printf.fprintf oc ("000000\n");
  | RdRtshamt (`Srl, gp1, gp2, i) -> Printf.fprintf oc ("000000"); out_bit oc 0 5; out_bit oc gp2 5; out_bit oc gp1 5; out_bit oc i 5; Printf.fprintf oc ("000010\n");
  | RtRsImm (`Addi, gp1, gp2, i) -> Printf.fprintf oc ("001000"); out_bit oc gp2 5; out_bit oc gp1 5; out_bit oc i 16; Printf.fprintf oc ("\n");
  | RtRsImm (`Slti, gp1, gp2, i) -> Printf.fprintf oc ("001010"); out_bit oc gp2 5; out_bit oc gp1 5; out_bit oc i 16; Printf.fprintf oc ("\n");
  | RtRsImm (`Ori, gp1, gp2, i) -> Printf.fprintf oc ("001101"); out_bit oc gp2 5; out_bit oc gp1 5; out_bit oc i 16; Printf.fprintf oc ("\n");
  | RtRsImm (`Fori, gp1, gp2, i) -> 
  if gp1 < 32 then
  (Printf.fprintf oc ("011100"); out_bit oc gp1 5; out_bit oc gp1 5; out_bit oc i 16; Printf.fprintf oc ("\n"))
  else
  (Printf.fprintf oc ("011101"); out_bit oc (gp1 - 32) 5; out_bit oc (gp1 - 32) 5; out_bit oc i 16; Printf.fprintf oc ("\n"))
  | RtImm (`Lui, gp1, i) -> Printf.fprintf oc ("001111"); out_bit oc 0 5; out_bit oc gp1 5; out_bit oc i 16; Printf.fprintf oc ("\n"); 
  | RtImm (`Flui, gp1, i) -> 
   if gp1 < 32 then
    (Printf.fprintf oc ("011110"); out_bit oc 0 5; out_bit oc gp1 5; out_bit oc i 16; Printf.fprintf oc ("\n"))
    else 
    (Printf.fprintf oc ("011111"); out_bit oc 0 5; out_bit oc (gp1 - 32) 5; out_bit oc i 16; Printf.fprintf oc ("\n"))
  | RtOffsetBase (`Lw, gp1, i, gp2) -> Printf.fprintf oc ("100011"); out_bit oc gp2 5; out_bit oc gp1 5; out_bit oc i 16; Printf.fprintf oc ("\n");
  | RtOffsetBase (`Sw, gp1, i, gp2) -> Printf.fprintf oc ("101011"); out_bit oc gp2 5; out_bit oc gp1 5; out_bit oc i 16; Printf.fprintf oc ("\n");  
  | RtOffsetBase (`Lwc, gp1, i, gp2) -> Printf.fprintf oc ("110001"); out_bit oc gp2 5; out_bit oc gp1 5; out_bit oc i 16; Printf.fprintf oc ("\n");
  | RtOffsetBase (`Swc, gp1, i, gp2) -> Printf.fprintf oc ("111001"); out_bit oc gp2 5; out_bit oc gp1 5; out_bit oc i 16; Printf.fprintf oc ("\n");
  | RsRtOffset (`Beq, gp1, gp2, label, now_addr) -> 
    (try (Printf.fprintf oc ("000100"); out_bit oc gp1 5; out_bit oc gp2 5; out_bit oc ((List.assoc label !label_list) - now_addr - 1) 16; Printf.fprintf oc ("\n");)
      with Not_found -> Printf.fprintf stdout "%s\n" label)
  | RsRtOffset (`Bne, gp1, gp2, label, now_addr) -> 
    (try (Printf.fprintf oc ("000101"); out_bit oc gp1 5; out_bit oc gp2 5; out_bit oc ((List.assoc label !label_list) - now_addr - 1) 16; Printf.fprintf oc ("\n");)
      with Not_found -> Printf.fprintf stdout "%s\n" label)
  | RsRtOffset (`Blt, gp1, gp2, label, now_addr) -> 
      (try (Printf.fprintf oc ("100010"); out_bit oc gp1 5; out_bit oc gp2 5; out_bit oc ((List.assoc label !label_list) - now_addr - 1) 16; Printf.fprintf oc ("\n");)
        with Not_found -> Printf.fprintf stdout "%s\n" label) 
  | RsImmOffset (`Blti, gp1, i, label, now_addr) -> 
        (try (Printf.fprintf oc ("100100"); out_bit oc gp1 5; out_bit oc i 5; out_bit oc ((List.assoc label !label_list) - now_addr - 1) 16; Printf.fprintf oc ("\n");)
          with Not_found -> Printf.fprintf stdout "%s\n" label)
  | ImmRtOffset (`Blti2, i, gp1, label, now_addr) -> 
          (try (Printf.fprintf oc ("100101"); out_bit oc i 5; out_bit oc gp1 5; out_bit oc ((List.assoc label !label_list) - now_addr - 1) 16; Printf.fprintf oc ("\n");)
            with Not_found -> Printf.fprintf stdout "%s\n" label)
  | RsImmOffset (`Bnei, gp1, i, label, now_addr) -> 
        (try (Printf.fprintf oc ("100001"); out_bit oc gp1 5; out_bit oc i 5; out_bit oc ((List.assoc label !label_list) - now_addr - 1) 16; Printf.fprintf oc ("\n");)
          with Not_found -> Printf.fprintf stdout "%s\n" label)
  | RsRtOffset (`Bflt, gp1, gp2, label, now_addr) -> 
          (try (Printf.fprintf oc ("100111"); out_bit oc gp1 5; out_bit oc gp2 5; out_bit oc ((List.assoc label !label_list) - now_addr - 1) 16; Printf.fprintf oc ("\n");)
            with Not_found -> Printf.fprintf stdout "%s\n" label)
  | RsRtOffset (`Bfeq, gp1, gp2, label, now_addr) -> 
          (try (Printf.fprintf oc ("100110"); out_bit oc gp1 5; out_bit oc gp2 5; out_bit oc ((List.assoc label !label_list) - now_addr - 1) 16; Printf.fprintf oc ("\n");)
            with Not_found -> Printf.fprintf stdout "%s\n" label)
  | RsRtOffset (`Bflti1, gp1, gp2, label, now_addr) ->    (* 前半即値のやつ *)
  (
    if gp1 < 32 then
          (try (Printf.fprintf oc ("101000"); out_bit oc gp1 5; out_bit oc gp2 5; out_bit oc ((List.assoc label !label_list) - now_addr - 1) 16; Printf.fprintf oc ("\n");)
            with Not_found -> Printf.fprintf stdout "%s\n" label)
    else 
    (
      (try (Printf.fprintf oc ("101001"); out_bit oc (gp1 - 32) 5; out_bit oc gp2 5; out_bit oc ((List.assoc label !label_list) - now_addr - 1) 16; Printf.fprintf oc ("\n");)
            with Not_found -> Printf.fprintf stdout "%s\n" label)
    )
  )
   | RsRtOffset (`Bflti2, gp1, gp2, label, now_addr) -> 
   if gp2 < 32 then
          (try (Printf.fprintf oc ("101010"); out_bit oc gp1 5; out_bit oc gp2 5; out_bit oc ((List.assoc label !label_list) - now_addr - 1) 16; Printf.fprintf oc ("\n");)
            with Not_found -> Printf.fprintf stdout "%s\n" label)
    else 
    (
      (try (Printf.fprintf oc ("101100"); out_bit oc gp1 5; out_bit oc (gp2 - 32) 5; out_bit oc ((List.assoc label !label_list) - now_addr - 1) 16; Printf.fprintf oc ("\n");)
            with Not_found -> Printf.fprintf stdout "%s\n" label)
    )
  | InOut (`Outc, gp1) -> Printf.fprintf oc ("111110"); out_bit oc 0 5; out_bit oc gp1 5; out_bit oc 0 5; out_bit oc 0 5; Printf.fprintf oc ("000000\n")
  | InOut (`Outi, gp1) -> Printf.fprintf oc ("111111"); out_bit oc 0 5; out_bit oc gp1 5; out_bit oc 0 5; out_bit oc 0 5; Printf.fprintf oc ("000000\n")
  | InOut (`Readi, gp1) -> Printf.fprintf oc ("111101"); out_bit oc 0 5; out_bit oc gp1 5; out_bit oc 0 5; out_bit oc 0 5; Printf.fprintf oc ("000000\n")
  | InOut (`Readf, gp1) -> Printf.fprintf oc ("111100"); out_bit oc 0 5; out_bit oc gp1 5; out_bit oc 0 5; out_bit oc 0 5; Printf.fprintf oc ("000000\n")
  | Jr (gp1) -> Printf.fprintf oc ("000000"); out_bit oc gp1 5; out_bit oc 0 5; out_bit oc 0 5; out_bit oc 0 5; Printf.fprintf oc ("001000\n")
  | Imm26 (`J, label) -> 
  if assocmem label !jp_list && assocmem (List.assoc label !jp_list) !jp_list then
  (print_string "year2!\n"; Printf.fprintf oc ("000010"); out_bit oc ((List.assoc (List.assoc (List.assoc label !jp_list) !jp_list) !label_list) - 1) 26; Printf.fprintf oc ("\n"))
  else if assocmem label !jp_list then 
  (print_string "year!\n"; Printf.fprintf oc ("000010"); out_bit oc ((List.assoc (List.assoc label !jp_list) !label_list) - 1) 26; Printf.fprintf oc ("\n"))
  else
  (Printf.fprintf oc ("000010"); out_bit oc ((List.assoc label !label_list) - 1) 26; Printf.fprintf oc ("\n"))
  | Imm26 (`Jal, label) -> 
  (try (Printf.fprintf oc ("000011"); out_bit oc ((List.assoc label !label_list) - 1) 26; Printf.fprintf oc ("\n"))
    with Not_found -> Printf.fprintf stdout "%s\n" label)
  | _ -> Printf.fprintf stdout "invalid instruction\n"
  
(* ここからlabel消去のためだけに存在 *)
let rec delete_label l pc = match l with
  | Label id1 -> label_list := (id1, pc)::(!label_list)
  | Labellis (id1, lrest) -> label_list := (id1, pc)::(!label_list); delete_label lrest pc

let rec g' oc e = match e with
  | Labelandins (l1, pc1, ins1) -> delete_label l1 pc1; Labelandins (l1, pc1, ins1)
  | Exp (ins1) -> Exp (ins1)
  
let rec f' oc t =
  match t with
  | Elis (t1, e1) ->  Elis(f' oc t1, g' oc e1)
  | E (e1) -> E(g' oc e1)
(* ここまでlabel消去のためだけに存在 *)

let rec g oc e = match e with
  | Labelandins (l1, pc1, ins1) -> h oc ins1(* メモしておく*)
  | Exp (ins1) -> h oc ins1

let rec add_jp l1 l2 = match l1 with
  | Label id -> jp_list := (id, l2)::!jp_list
  | Labellis (id, rest) -> jp_list := (id, l2)::(!jp_list); add_jp rest l2

let rec sub1 e = match e with
  | Labelandins (l1, _, Imm26(`J, l2)) -> add_jp l1 l2
  | _ -> ()
  
let rec sub_jmp t = match t with
| Elis (t1, e1) ->  sub_jmp t1; sub1 e1
| E (e1) -> sub1 e1

let rec f oc t' =
  let _ = (f' oc t') in
  let _ = sub_jmp t' in
  (* print_int (List.length !jp_list); *)
  let rec f_sub oc  t'' =
    match t'' with
    | Elis (t1, e1) ->  f_sub oc t1; g oc e1
    | E (e1) -> g oc e1
  in
  f_sub oc t'


