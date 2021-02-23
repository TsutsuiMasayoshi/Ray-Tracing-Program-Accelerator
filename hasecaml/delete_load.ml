(* open Asm

let last_load = ref []
let last_loadi = ref []
let restore_list = ref []

let find x l = try let _ = List.assoc x l in true with _ -> false

(* 整数ロードで間関係ない命令なら同じの使う *)
let rec g e = match e with
  | Ans(exp) -> 
    (match exp with
      | IfEq (x1, y, e3, e4) -> Ans(IfEq(x1, y, g e3, g e4))
      | IfLT (x1, y, e3, e4) -> Ans(IfLT(x1, y, g e3, g e4))
      | IfLT2 (i, y, e3, e4) -> Ans(IfLT2(i, y, g e3, g e4))
      | IfFEq (x1, y, e3, e4) -> Ans(IfFEq(x1, y, g e3, g e4))
      | IfFLT (x1, y, e3, e4)-> Ans(IfFLT(x1, y, g e3, g e4)) 
      | IfFLTi1 (x1, y, e3, e4) -> Ans(IfFLTi1(x1, y, g e3, g e4)) 
      | IfFLTi2 (x1, y, e3, e4) -> Ans(IfFLTi2(x1, y, g e3, g e4)) 
      | IfFEqz (x1, e3, e4) -> Ans(IfFEqz(x1, g e3, g e4))
      | IfFLTz (x1, e3, e4) -> Ans(IfFLTz(x1, g e3, g e4))
      | IfFGTz (x1, e3, e4) -> Ans(IfFGTz(x1, g e3, g e4))
      | _ -> Ans(exp))
  | Let((x, t), exp, e1) -> 
    (match exp with
      | Lwz(y, z) -> (last_loadi := []; if (find x !last_load)&&(List.assoc x !last_load = (y, z)) then Let((x, t), Nop, g e1) else (last_load := [(x, (y, z))]; Let((x, t), exp, g e1)))
      (* | Lwc (c) ->  (last_load := []; if (find x !last_loadi)&&(List.assoc x !last_loadi = c) then Let((x, t), Nop, g e1) else (last_loadi := [(x, c)]; Let((x, t), exp, g e1))) *)
      | FAdd _ | FSub _ | FMul _ | FDiv _ | FSub2 _ | FDiv2 _ | Lfd _ | Lwfc _ | Comment _ | FLi _ | FMr _ | FNeg _  | CallDir(Id.L("min_caml_read_float"), _, _) -> Let((x, t), exp, g e1)
      | Stfd _ | Stfdz _ | Swfc _ | Swfcz _  -> Let((x, t), exp, g e1)
      (* | Save (y, z) -> Let((x, t), exp, g e1) *)
      (* | Restore(y) -> 
        (last_load := []; last_loadi := []; if (List.mem x allregs)&&(find x !restore_list)&&(List.assoc x !restore_list = y) then Let((x, t), Nop, g e1) else (restore_list := [(x, y)]; Let((x, t), exp, g e1))) *)
      | IfEq (x1, y, e3, e4) -> Let((x, t), IfEq(x1, y, g e3, g e4), g e1)
      | IfLT (x1, y, e3, e4) -> Let((x, t), IfLT(x1, y, g e3, g e4), g e1)
      | IfLT2 (i, y, e3, e4) -> Let((x, t), IfLT2(i, y, g e3, g e4), g e1)
      | IfFEq (x1, y, e3, e4) -> Let((x, t), IfFEq(x1, y, g e3, g e4), g e1)
      | IfFLT (x1, y, e3, e4)-> Let((x, t), IfFLT(x1, y, g e3, g e4), g e1)
      | IfFLTi1 (x1, y, e3, e4) -> Let((x, t), IfFLTi1(x1, y, g e3, g e4), g e1)
      | IfFLTi2 (x1, y, e3, e4) -> Let((x, t), IfFLTi2(x1, y, g e3, g e4), g e1)
      | IfFEqz (x1, e3, e4) -> Let((x, t), IfFEqz(x1, g e3, g e4), g e1)
      | IfFLTz (x1, e3, e4) -> Let((x, t), IfFLTz(x1, g e3, g e4), g e1)
      | IfFGTz (x1, e3, e4) -> Let((x, t), IfFGTz(x1, g e3, g e4), g e1)
      | _ -> last_load := []; last_loadi := []; restore_list := []; Let((x, t), exp, (g e1))
      )

let h { name = l; args = xs; fargs = ys; body = e; ret = t } =
  last_load := []; { name = l; args = xs; fargs = ys; body = g e; ret = t }

let f (Prog(data, fundefs, e, _)) = 
  Prog(data, List.map h fundefs, g e, M.empty) *)
  (* (Prog(data, fundefs, e, M.empty)) *)

open Asm

let find x l = try let _ = List.assoc x l in true with _ -> false

let rec use x l = match l with
  | [] -> []
  | (c, (a, b))::rest -> if a = x || b = V(x) || c = x then use x rest else (c, (a, b))::(use x rest)

let rec use' x l = match l with
  | [] -> []
  | (c, a)::rest -> if a = x || c = x then use' x rest else (c, a)::(use' x rest)

let rec use2 lis l = match lis with
  | [] -> l
  | x::rest -> use2 rest (use x l)

let rec use2' lis l = match lis with
  | [] -> l
  | x::rest -> use2' rest (use' x l)

let rec uwagaki_lis t = match t with
  | Ans(exp) ->
    (match exp with
    | IfEq (x1, y, e3, e4) -> uwagaki_lis e3 @ uwagaki_lis e4
    | IfLT (x1, y, e3, e4) -> uwagaki_lis e3 @ uwagaki_lis e4
    | IfLT2 (i, y, e3, e4) -> uwagaki_lis e3 @ uwagaki_lis e4
    | IfFEq (x1, y, e3, e4) -> uwagaki_lis e3 @ uwagaki_lis e4
    | IfFLT (x1, y, e3, e4)-> uwagaki_lis e3 @ uwagaki_lis e4
    | IfFLTi1 (x1, y, e3, e4) -> uwagaki_lis e3 @ uwagaki_lis e4
    | IfFLTi2 (x1, y, e3, e4) -> uwagaki_lis e3 @ uwagaki_lis e4
    | IfFEqz (x1, e3, e4) -> uwagaki_lis e3 @ uwagaki_lis e4
    | IfFLTz (x1, e3, e4) -> uwagaki_lis e3 @ uwagaki_lis e4
    | IfFGTz (x1, e3, e4) -> uwagaki_lis e3 @ uwagaki_lis e4
    | _ -> []
    )
  | Let((x, _), exp, t2) -> 
    (match exp with
      | IfEq (x1, y, e3, e4) -> x :: uwagaki_lis e3 @ uwagaki_lis e4 @ uwagaki_lis t2
      | IfLT (x1, y, e3, e4) -> x :: uwagaki_lis e3 @ uwagaki_lis e4 @ uwagaki_lis t2
      | IfLT2 (i, y, e3, e4) ->  x :: uwagaki_lis e3 @ uwagaki_lis e4 @ uwagaki_lis t2
      | IfFEq (x1, y, e3, e4) -> x :: uwagaki_lis e3 @ uwagaki_lis e4 @ uwagaki_lis t2
      | IfFLT (x1, y, e3, e4)-> x :: uwagaki_lis e3 @ uwagaki_lis e4 @ uwagaki_lis t2
      | IfFLTi1 (x1, y, e3, e4) -> x :: uwagaki_lis e3 @ uwagaki_lis e4 @ uwagaki_lis t2
      | IfFLTi2 (x1, y, e3, e4) -> x :: uwagaki_lis e3 @ uwagaki_lis e4 @ uwagaki_lis t2
      | IfFEqz (x1, e3, e4) -> x :: uwagaki_lis e3 @ uwagaki_lis e4 @ uwagaki_lis t2
      | IfFLTz (x1, e3, e4) -> x :: uwagaki_lis e3 @ uwagaki_lis e4 @ uwagaki_lis t2
      | IfFGTz (x1, e3, e4) -> x :: uwagaki_lis e3 @ uwagaki_lis e4 @ uwagaki_lis t2
      | _ -> x::(uwagaki_lis t2)
    )

(* 整数ロードで間関係ない命令なら同じの使う *)
let rec g env env2 e = match e with
  | Ans(exp) -> 
    (match exp with
      | IfEq (x1, y, e3, e4) -> Ans(IfEq(x1, y, g env env2 e3, g env env2 e4))
      | IfLT (x1, y, e3, e4) -> Ans(IfLT(x1, y, g env env2 e3, g env env2 e4))
      | IfLT2 (i, y, e3, e4) -> Ans(IfLT2(i, y, g env env2 e3, g env env2 e4))
      | IfFEq (x1, y, e3, e4) -> Ans(IfFEq(x1, y, g env env2 e3, g env env2 e4))
      | IfFLT (x1, y, e3, e4)-> Ans(IfFLT(x1, y, g env env2 e3, g env env2 e4)) 
      | IfFLTi1 (x1, y, e3, e4) -> Ans(IfFLTi1(x1, y, g env env2 e3, g env env2 e4)) 
      | IfFLTi2 (x1, y, e3, e4) -> Ans(IfFLTi2(x1, y, g env env2 e3, g env env2 e4)) 
      | IfFEqz (x1, e3, e4) -> Ans(IfFEqz(x1, g env env2 e3, g env env2 e4))
      | IfFLTz (x1, e3, e4) -> Ans(IfFLTz(x1, g env env2 e3, g env env2 e4))
      | IfFGTz (x1, e3, e4) -> Ans(IfFGTz(x1, g env env2 e3, g env env2 e4))
      | _ -> Ans(exp))
  | Let((x, t), exp, e1) -> 
    (match exp with
      | Lwz(y, z) -> (if (find x env)&&(List.assoc x env = (y, z)) then Let((x, t), Nop, g env (use' x env2) e1) else Let((x, t), exp, g ((x, (y, z))::(use x env)) (use' x env2) e1))
      (* | Lwc (c) ->  (if (find x env2)&&(List.assoc x env2 = c) then Let((x, t), Nop, g [] env2 e1) else  Let((x, t), exp, g [] [(x, c)] e1)) *)
      | Nop | FAdd _ | FSub _ | FMul _ | FDiv _ | FSub2 _ | FDiv2 _ | Lfd _ | Lwfc _ | Comment _ | FLi _ | FMr _ | FNeg _  | CallDir(Id.L("min_caml_read_float"), _, _) -> Let((x, t), exp, g env env2 e1)
      | Stfd _ | Stfdz _ | Swfc _ | Swfcz _ -> Let((x, t), exp, g env env2 e1)
      | Save(_, y) -> Let((x, t), exp, g env (use' y env2) e1)
      | Restore(y) -> (if (find x env2)&&(List.assoc x env2 = y) then (print_string "ok\n"; Let((x, t), Nop, g (use x env) env2 e1)) else (Let((x, t), exp, g (use x env) ((x, y)::(use' x env2)) e1)))
      | IfEq (x1, y, e3, e4) -> Let((x, t), IfEq(x1, y, g env env2 e3, g env env2 e4), g (use2 (x::(uwagaki_lis e3)@(uwagaki_lis e4)) env) (use2' (x::(uwagaki_lis e3)@(uwagaki_lis e4)) env2) e1)
      | IfLT (x1, y, e3, e4) -> Let((x, t), IfLT(x1, y, g env env2 e3, g env env2 e4), g (use2 (x::(uwagaki_lis e3)@(uwagaki_lis e4)) env) (use2' (x::(uwagaki_lis e3)@(uwagaki_lis e4)) env2) e1)
      | IfLT2 (i, y, e3, e4) -> Let((x, t), IfLT2(i, y, g env env2 e3, g env env2 e4), g (use2 (x::(uwagaki_lis e3)@(uwagaki_lis e4)) env) (use2' (x::(uwagaki_lis e3)@(uwagaki_lis e4)) env2) e1)
      | IfFEq (x1, y, e3, e4) -> Let((x, t), IfFEq(x1, y, g env env2 e3, g env env2 e4), g (use2 (x::(uwagaki_lis e3)@(uwagaki_lis e4)) env) (use2' (x::(uwagaki_lis e3)@(uwagaki_lis e4)) env2) e1)
      | IfFLT (x1, y, e3, e4)-> Let((x, t), IfFLT(x1, y, g env env2 e3, g env env2 e4), g (use2 (x::(uwagaki_lis e3)@(uwagaki_lis e4)) env) (use2' (x::(uwagaki_lis e3)@(uwagaki_lis e4)) env2) e1)
      | IfFLTi1 (x1, y, e3, e4) -> Let((x, t), IfFLTi1(x1, y, g env env2 e3, g env env2 e4), g (use2 (x::(uwagaki_lis e3)@(uwagaki_lis e4)) env) (use2' (x::(uwagaki_lis e3)@(uwagaki_lis e4)) env2) e1)
      | IfFLTi2 (x1, y, e3, e4) -> Let((x, t), IfFLTi2(x1, y, g env env2 e3, g env env2 e4), g (use2 (x::(uwagaki_lis e3)@(uwagaki_lis e4)) env) (use2' (x::(uwagaki_lis e3)@(uwagaki_lis e4)) env2) e1)
      | IfFEqz (x1, e3, e4) -> Let((x, t), IfFEqz(x1, g env env2 e3, g env env2 e4), g (use2 (x::(uwagaki_lis e3)@(uwagaki_lis e4)) env) (use2' (x::(uwagaki_lis e3)@(uwagaki_lis e4)) env2) e1)
      | IfFLTz (x1, e3, e4) -> Let((x, t), IfFLTz(x1, g env env2 e3, g env env2 e4), g (use2 (x::(uwagaki_lis e3)@(uwagaki_lis e4)) env) (use2' (x::(uwagaki_lis e3)@(uwagaki_lis e4)) env2) e1)
      | IfFGTz (x1, e3, e4) -> Let((x, t), IfFGTz(x1, g env env2 e3, g env env2 e4), g (use2 (x::(uwagaki_lis e3)@(uwagaki_lis e4)) env) (use2' (x::(uwagaki_lis e3)@(uwagaki_lis e4)) env2) e1)
      (* | Stw _ | Swc _ | Save _ -> Let((x, t), exp, (g [] [] e1)) *)
      | _ -> Let((x, t), exp, (g (use x env) (use' x env2) e1))
      )


let rec my_last e = 
  (match e with
  | Ans(exp) -> 
  (match exp with
  | IfEq (x1, C(i), e3, e4) -> (match e3 with
        | Let((x', _), Li(i'), e3') when x' = x1 && i' = i ->  (print_string "jij"; Ans(IfEq(x1, C(i), my_last e3', my_last e4)))
        | _ -> Ans(IfEq(x1, C(i), my_last e3, my_last e4))
      )
  (* | IfEq (x1, y, e3, e4) -> Ans(IfEq(x1, y, my_last e3, my_last e4)) *)
  | IfLT (x1, y, e3, e4) -> Ans(IfLT(x1, y, my_last e3, my_last e4))
  | IfLT2 (i, y, e3, e4) -> Ans(IfLT2(i, y, my_last e3, my_last e4))
  | IfFEq (x1, y, e3, e4) -> Ans(IfFEq(x1, y, my_last e3, my_last e4))
  | IfFLT (x1, y, e3, e4)-> Ans(IfFLT(x1, y, my_last e3, my_last e4)) 
  | IfFLTi1 (x1, y, e3, e4) -> Ans(IfFLTi1(x1, y, my_last e3, my_last e4)) 
  | IfFLTi2 (x1, y, e3, e4) -> Ans(IfFLTi2(x1, y, my_last e3, my_last e4)) 
  | IfFEqz (x1, e3, e4) -> Ans(IfFEqz(x1, my_last e3, my_last e4))
  | IfFLTz (x1, e3, e4) -> Ans(IfFLTz(x1, my_last e3, my_last e4))
  | IfFGTz (x1, e3, e4) -> Ans(IfFGTz(x1, my_last e3, my_last e4))
  | _ -> Ans(exp)
  )
  | Let((x, t), exp, e1) -> 
  (match exp with
      | IfEq (x1, C(i), e3, e4) -> (match e3 with
        | Let((x', _), Li(i'), e3') when x' = x1 && i' = i ->  (print_string "jij"; Let((x, t), (IfEq(x1, C(i), my_last e3', my_last e4)), my_last e1))
        | _ -> Let((x, t), IfEq(x1, C(i), my_last e3, my_last e4), my_last e1)
      )
      (* | IfEq (x1, y, e3, e4) -> Let((x, t), IfEq(x1, y, my_last e3, my_last e4)), my_last e1) *)
      | IfLT (x1, y, e3, e4) -> Let((x, t), IfLT(x1, y, my_last e3, my_last e4), my_last e1)
      | IfLT2 (i, y, e3, e4) -> Let((x, t), IfLT2(i, y, my_last e3, my_last e4), my_last e1)
      | IfFEq (x1, y, e3, e4) -> Let((x, t), IfFEq(x1, y, my_last e3, my_last e4), my_last e1)
      | IfFLT (x1, y, e3, e4)-> Let((x, t), IfFLT(x1, y, my_last e3, my_last e4) , my_last e1)
      | IfFLTi1 (x1, y, e3, e4) -> Let((x, t), IfFLTi1(x1, y, my_last e3, my_last e4), my_last e1) 
      | IfFLTi2 (x1, y, e3, e4) -> Let((x, t), IfFLTi2(x1, y, my_last e3, my_last e4), my_last e1) 
      | IfFEqz (x1, e3, e4) -> Let((x, t), IfFEqz(x1, my_last e3, my_last e4), my_last e1)
      | IfFLTz (x1, e3, e4) -> Let((x, t), IfFLTz(x1, my_last e3, my_last e4), my_last e1)
      | IfFGTz (x1, e3, e4) -> Let((x, t), IfFGTz(x1, my_last e3, my_last e4), my_last e1)
      | _ -> Let((x, t), exp, my_last e1)
      )
  )


let h { name = l; args = xs; fargs = ys; body = e; ret = t } =
 { name = l; args = xs; fargs = ys; body = (g [] [] e); ret = t }

let f (Prog(data, fundefs, e, _)) = 
  Prog(data, List.map h fundefs, (g [] [] e), M.empty)