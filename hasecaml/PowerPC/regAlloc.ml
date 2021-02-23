open Asm

(* let fundef_ref = ref []

let rec fun_use_lis label lis =
  (* if label = "min_caml_read_float" then ["$sp"; "$ra"; "$f0"] *)
  (* else if label = "min_caml_read_int" then ["$a0"] 
  else if label = "min_caml_print_int" then []
  else if label = "min_caml_print_char" then [] 
  else if label = "min_caml_sqrt" then []
  else if label = "min_caml_floor" then [] 
  else if label = "min_caml_int_of_float" then []
  else if label = "min_caml_float_of_int" then []
  else if label = "min_caml_create_array" then []
  else if label = "min_caml_create_float_array" then [] *)
  else 
 (match lis with
  | [] -> allregs@allfregs
  | f1::rest -> if f1.name = Id.L(label) then (fv f1.body) else fun_use_lis label rest
  ) *)
let rec reverse l = match l with
  | [] -> []
  | a::rest -> (reverse rest)@[a]

let rec an2 num l = if num = 0 then l else 
  match l with
    | a::rest -> an2 (num - 1) rest

(* for register coalescing *)
(* [XXX] Callがあったら、そこから先は無意味というか逆効果なので追わない。
         そのために「Callがあったかどうか」を返り値の第1要素に含める。 *)
let rec target' src (dest, t) = function
  | Mr(x) when x = src && is_reg dest ->
      assert (t <> Type.Unit);
      assert (t <> Type.Float);
      false, [dest]
  | FMr(x) when x = src && is_reg dest ->
      assert (t = Type.Float);
      false, [dest]
  | IfEq(_, _, e1, e2) | IfLT(_, _, e1, e2) 
  | IfFEq(_, _, e1, e2) | IfFLT(_, _, e1, e2) ->
      let c1, rs1 = target src (dest, t) e1 in
      let c2, rs2 = target src (dest, t) e2 in
      c1 && c2, rs1 @ rs2
  (* | CallCls(x, ys, zs) ->
      true, (target_args src regs 0 ys @
             target_args src fregs 0 zs @
             if x = src then [reg_cl] else []) *)
  | CallDir(_, ys, zs) ->
      true, (target_args src regs 0 ys @
             target_args src fregs 0 zs)
  | _ -> false, []
and target src dest = function (* register targeting (caml2html: regalloc_target) *)
  | Ans(exp) -> target' src dest exp
  | Let(xt, exp, e) ->
      let c1, rs1 = target' src xt exp in
      if c1 then true, rs1 else
      let c2, rs2 = target src dest e in
      c2, rs1 @ rs2
and target_args src all n = function (* auxiliary function for Call *)
  | [] -> []
  | y :: ys when src = y -> all.(n) :: target_args src all (n + 1) ys
  | _ :: ys -> target_args src all (n + 1) ys

type alloc_result = (* allocにおいてspillingがあったかどうかを表すデータ型 *)
  | Alloc of Id.t (* allocated register *)
  | Spill of Id.t (* spilled variable *)
let rec alloc dest cont regenv x t gyakukara =
  (* allocate a register or spill a variable *)
  assert (not (M.mem x regenv));
  let all =
    match t with
    | Type.Unit -> ["%r0"] (* dummy *)
    | Type.Float -> allfregs
    | _ -> (if gyakukara then an2 16 allregs else allregs) in
  if all = ["%r0"] then Alloc("%r0") else (* [XX] ad hoc optimization *)
  if is_reg x then Alloc(x) else
  let free = fv cont in
  try
    let (c, prefer) = target x dest cont in
    let live = (* 生きているレジスタ *)
      List.fold_left
        (fun live y ->
          if is_reg y then S.add y live else
          try S.add (M.find y regenv) live
          with Not_found -> live)
        S.empty
        free in
    let r = (* そうでないレジスタを探す *)
      List.find
        (fun r -> not (S.mem r live))
        (prefer @ all) in
    (* Format.eprintf "allocated %s to %s@." x r; *)
    Alloc(r)
  with Not_found ->
    Format.eprintf "register allocation failed for %s@." x;
    let y = (* 型の合うレジスタ変数を探す *)
      List.find
        (fun y ->
          not (is_reg y) &&
          try List.mem (M.find y regenv) all
          with Not_found -> false)
        (List.rev free) in
    Format.eprintf "spilling %s from %s@." y (M.find y regenv);
    Spill(y)

(* auxiliary function for g and g'_and_restore *)
let add x r regenv =
  if is_reg x then (assert (x = r); regenv) else
  M.add x r regenv


(* auxiliary functions for g' *)
exception NoReg of Id.t * Type.t
let find x t regenv =
  if is_reg x then x else
  try M.find x regenv
  with Not_found -> raise (NoReg(x, t))
let find' x' regenv =
  match x' with
  | V(x) -> V(find x Type.Int regenv)
  | c -> c
let findf x regenv = 
  match x with
    | Vf(x) -> Vf(find x Type.Float regenv)
    | cf -> cf

let rec g dest cont regenv = function (* 命令列のレジスタ割り当て (caml2html: regalloc_g) *)
  | Ans(exp) -> g'_and_restore dest cont regenv exp
  | Let((x, t) as xt, exp, e) ->
      assert (not (M.mem x regenv));  (* 今から定義するんだからレジスタ環境にあるわけないよね〜 *)
      let cont' = concat e dest cont in
      let (e1', regenv1) = g'_and_restore xt cont' regenv exp in
      let k = (match exp with 
        | Lwz _ -> alloc dest cont' regenv1 x t true
        | _ -> alloc dest cont' regenv1 x t false) in
      (match k with
      | Spill(y) ->
          let r = M.find y regenv1 in
          let (e2', regenv2) = g dest cont (add x r (M.remove y regenv1)) e in
          let save =
            try Save(M.find y regenv, y)
            with Not_found -> Nop in
          (seq(save, concat e1' (r, t) e2'), regenv2)
      | Alloc(r) ->
          let (e2', regenv2) = g dest cont (add x r regenv1) e in
          (concat e1' (r, t) e2', regenv2))
and g'_and_restore dest cont regenv exp = (* 使用される変数をスタックからレジスタへRestore (caml2html: regalloc_unspill) *)
  try g' dest cont regenv exp
  with NoReg(x, t) ->
    ((* Format.eprintf "restoring %s@." x; *)
     g dest cont regenv (Let((x, t), Restore(x), Ans(exp))))
and g' dest cont regenv = function (* 各命令のレジスタ割り当て (caml2html: regalloc_gprime) *)
  | Nop | Li _ | SetL _ | Comment _ | Restore _ | FLi _ | Lwc _ | Lwfc _ | Swfcz _ as exp -> (Ans(exp), regenv)
  | Mr(x) -> (Ans(Mr(find x Type.Int regenv)), regenv)
  | Neg(x) -> (Ans(Neg(find x Type.Int regenv)), regenv)
  | Add(x, y') -> (Ans(Add(find x Type.Int regenv, find' y' regenv)), regenv)
  | Sub(x, y') -> (Ans(Sub(find x Type.Int regenv, find' y' regenv)), regenv)
  | Slw(x, y') -> (Ans(Slw(find x Type.Int regenv, find' y' regenv)), regenv)
  | Slr(x, y') -> (Ans(Slr(find x Type.Int regenv, find' y' regenv)), regenv)
  | Lwz(x, y') -> (Ans(Lwz(find x Type.Int regenv, find' y' regenv)), regenv)
  | Stw(x, y, z') -> (Ans(Stw(find x Type.Int regenv, find y Type.Int regenv, find' z' regenv)), regenv)
  | Swc(x, i) -> (Ans(Swc(find x Type.Int regenv, i)), regenv)
  | Swfc(x, i) -> (Ans(Swfc(find x Type.Float regenv, i)), regenv)
  | FMr(x) -> (Ans(FMr(find x Type.Float regenv)), regenv)
  | FNeg(x) -> (Ans(FNeg(find x Type.Float regenv)), regenv)
  | FAdd(x, y) -> (Ans(FAdd(find x Type.Float regenv, findf y regenv)), regenv)
  | FSub(x, y) -> (Ans(FSub(find x Type.Float regenv, findf y regenv)), regenv)
  | FMul(x, y) -> (Ans(FMul(find x Type.Float regenv, findf y regenv)), regenv)
  | FDiv(x, y) -> (Ans(FDiv(find x Type.Float regenv, findf y regenv)), regenv)
  | FSub2(f, y) -> (Ans(FSub2(f, find y Type.Float regenv)), regenv)
  | FDiv2(f, y) -> (Ans(FDiv2(f, find y Type.Float regenv)), regenv)
  | Lfd(x, y') -> (Ans(Lfd(find x Type.Int regenv, find' y' regenv)), regenv)
  | Stfd(x, y, z') -> (Ans(Stfd(find x Type.Float regenv, find y Type.Int regenv, find' z' regenv)), regenv)
  | Stfdz(y, z') -> (Ans(Stfdz(find y Type.Int regenv, find' z' regenv)), regenv)
  | IfEq(x, y', e1, e2) as exp -> g'_if dest cont regenv exp (fun e1' e2' -> IfEq(find x Type.Int regenv, find' y' regenv, e1', e2')) e1 e2
  | IfLT(x, y', e1, e2) as exp -> g'_if dest cont regenv exp (fun e1' e2' -> IfLT(find x Type.Int regenv, find' y' regenv, e1', e2')) e1 e2
  | IfLT2(i, y, e1, e2) as exp -> g'_if dest cont regenv exp (fun e1' e2' -> IfLT2(i, find y Type.Int regenv, e1', e2')) e1 e2
  | IfFEq(x, y, e1, e2) as exp -> g'_if dest cont regenv exp (fun e1' e2' -> IfFEq(find x Type.Float regenv, find y Type.Float regenv, e1', e2')) e1 e2
  | IfFLT(x, y, e1, e2) as exp -> g'_if dest cont regenv exp (fun e1' e2' -> IfFLT(find x Type.Float regenv, find y Type.Float regenv, e1', e2')) e1 e2
  | IfFLTi1(x, y, e1, e2) as exp -> g'_if dest cont regenv exp (fun e1' e2' -> IfFLTi1(x, find y Type.Float regenv, e1', e2')) e1 e2
  | IfFLTi2(x, y, e1, e2) as exp -> g'_if dest cont regenv exp (fun e1' e2' -> IfFLTi2(find x Type.Float regenv, y, e1', e2')) e1 e2
  | IfFEqz(x, e1, e2) as exp -> g'_if dest cont regenv exp (fun e1' e2' -> IfFEqz(find x Type.Float regenv, e1', e2')) e1 e2
  | IfFLTz(x, e1, e2) as exp -> g'_if dest cont regenv exp (fun e1' e2' -> IfFLTz(find x Type.Float regenv, e1', e2')) e1 e2
  | IfFGTz(x, e1, e2) as exp -> g'_if dest cont regenv exp (fun e1' e2' -> IfFGTz(find x Type.Float regenv, e1', e2')) e1 e2
  | CallDir(Id.L(x), ys, zs) as exp ->
      if List.length ys > Array.length regs - 1 || List.length zs > Array.length fregs - 1 then
        failwith (Format.sprintf "cannot allocate registers for arugments to %s" x)
      else
        g'_call dest cont regenv exp (fun ys zs -> CallDir(Id.L(x), ys, zs)) ys zs
  | Save(x, y) -> assert false
and g'_if dest cont regenv exp constr e1 e2 = (* ifのレジスタ割り当て (caml2html: regalloc_if) *)
  let (e1', regenv1) = g dest cont regenv e1 in
  let (e2', regenv2) = g dest cont regenv e2 in
  let regenv' = (* 両方に共通のレジスタ変数だけ利用 *)
    List.fold_left
      (fun regenv' x ->
        try
          if is_reg x then regenv' else
          let r1 = M.find x regenv1 in
          let r2 = M.find x regenv2 in
          if r1 <> r2 then regenv' else
          M.add x r1 regenv'
        with Not_found -> regenv')
      M.empty
      (fv cont) in
  (List.fold_left
     (fun e x ->
       if x = fst dest || not (M.mem x regenv) || M.mem x regenv' then e else
       seq(Save(M.find x regenv, x), e)) (* そうでない変数は分岐直前にセーブ *)
     (Ans(constr e1' e2'))
     (fv cont),
   regenv')
and g'_call dest cont regenv exp constr ys zs = (* 関数呼び出しのレジスタ割り当て (caml2html: regalloc_call) *)
  (List.fold_left
     (fun e x ->
       if x = fst dest || not (M.mem x regenv) (*|| not (List.mem (M.find x regenv) (fun_use_lis label !fundef_ref))*) then e else
       seq(Save(M.find x regenv, x), e))
     (Ans(constr
            (List.map (fun y -> find y Type.Int regenv) ys)
            (List.map (fun z -> find z Type.Float regenv) zs)))
     (fv cont),
   M.empty)

let h { name = Id.L(x); args = ys; fargs = zs; body = e; ret = t } = (* 関数のレジスタ割り当て (caml2html: regalloc_h) *)
  let regenv = M.add x reg_cl M.empty in
  let (i, arg_regs, regenv) =
    List.fold_left
      (fun (i, arg_regs, regenv) y ->
        let r = regs.(i) in
        (i + 1,
         arg_regs @ [r],
         (assert (not (is_reg y));
          M.add y r regenv)))
      (0, [], regenv)
      ys in
  let (d, farg_regs, regenv) =
    List.fold_left
      (fun (d, farg_regs, regenv) z ->
        let fr = fregs.(d) in
        (d + 1,
         farg_regs @ [fr],
         (assert (not (is_reg z));
          M.add z fr regenv)))
      (0, [], regenv)
      zs in
  let a =
    match t with
    | Type.Unit -> Id.gentmp Type.Unit
    | Type.Float -> fregs.(0)
    | _ -> regs.(0) in
  let (e', regenv') = g (a, t) (Ans(Mr(a))) regenv e in
  { name = Id.L(x); args = arg_regs; fargs = farg_regs; body = e'; ret = t }

let f (Prog(data, fundefs, e, _)) = (* プログラム全体のレジスタ割り当て (caml2html: regalloc_f) *)
  Format.eprintf "register allocation: may take some time (up to a few minutes, depending on the size of functions)@.";
  let fundefs' = List.map h fundefs in
  (* fundef_ref := fundefs'; *)
  let e', regenv' = g (Id.gentmp Type.Unit, Type.Unit) (Ans(Nop)) M.empty e in
  Prog(data, fundefs', e', M.empty)


(* ここから書いていく *)

(* 注:　ここでのExpにはIf文は現れないはずである。 error1  *)
(* exception My_Error1
exception My_Error2
type inst = Exp of exp | Brunch of (Id.t * id_or_imm) | Brunchf of (Id.t * Id.t) | Brunch_fzero of (Id.t)
type def = Def of (Id.t * Type.t) | Nothing
type instruction_tree = Tree of def * inst * instruction_tree * instruction_tree | Leaf     (* if文以外では右の子treeはLeafとなる。 *)

let rec henkan_if x1 ty1 e1 t =           (* ifの分岐(e1)と後続命令列(t)を繋げる *)
    match e1 with
      | Ans(exp) -> Let((x1, ty1), exp, t)
      | Let((x2, ty2), exp2, t2) -> Let((x2, ty2), exp2, (henkan_if x1 ty1 t2 t))

let rec e_to_tree t = match t with   (* 命令列をtreeに変える。 *)
    | Ans(exp1) -> (match exp1 with
      | IfEq(x, y, e1, e2) | IfLT(x, y, e1, e2) -> Tree(Nothing, Brunch(x, y), e_to_tree e1, e_to_tree e2)
      | IfFEq(x, y, e1, e2) | IfFLT(x, y, e1, e2) -> Tree(Nothing, Brunchf(x, y), e_to_tree e1, e_to_tree e2)
      | IfFEqz(x, e1, e2)| IfFLTz(x, e1, e2)| IfFGTz(x, e1, e2) -> Tree(Nothing, Brunch_fzero(x), e_to_tree e1, e_to_tree e2)
      | _ -> Tree(Nothing, Exp(exp1), Leaf, Leaf))
    | Let((x1, ty1), exp1, t1) -> (match exp1 with
     | IfEq(x, y, e1, e2) | IfLT(x, y, e1, e2) -> Tree(Nothing, Brunch(x, y), e_to_tree (henkan_if x1 ty1 e1 t1), e_to_tree (henkan_if x1 ty1 e2 t1))
     | IfFEq(x, y, e1, e2) | IfFLT(x, y, e1, e2) -> Tree(Nothing, Brunchf(x, y), e_to_tree (henkan_if x1 ty1 e1 t1), e_to_tree (henkan_if x1 ty1 e2 t1))
     | IfFEqz(x, e1, e2)| IfFLTz(x, e1, e2)| IfFGTz(x, e1, e2) -> Tree(Nothing, Brunch_fzero(x), e_to_tree (henkan_if x1 ty1 e1 t1), e_to_tree (henkan_if x1 ty1 e2 t1))
     | _ -> Tree(Def(x1, ty1), Exp(exp1), e_to_tree t1, Leaf)
    )

let def tree = match tree with
    | Leaf -> ([], [])
    | Tree(def1, _, _, _) -> (match def1 with
      | Nothing -> ([], [])
      | Def(x1, Type.Float) -> ([], [x1])
      | Def(x1, _) -> ([x1], [])
    )

let use tree = match tree with
    | Leaf -> ([], [])
    | Tree(def, inst, _, _) -> (
   match inst with      (* 整数型のものと浮動小数点型のものは勿論区別 *)
    | Exp(exp) -> (
      match exp with
      | Nop | Li _ | SetL _ | Comment _ | Restore _ | FLi _ | Lwc _ | Lwfc _ | Swfcz _ -> ([], [])
      | Mr(x) | Neg(x) | Swc(x, _) -> ([x], [])
      | Add(x, y') | Sub(x, y') | Slr(x, y') | Slw(x, y') | Lwz(x, y') | Lfd(x, y') | Stfdz(x, y') -> (match y' with 
        | V(y) -> ([x; y], [])
        | C(_) -> ([x], []) )
      | Stw(x, y, z') -> (match z' with 
        | V(z) -> ([x; y; z], [])
        | C(_) -> ([x; y], []) )
      | Swfc(x, _) | FMr(x) | FNeg (x) -> ([], [x])
      | FAdd(x, y) | FSub(x, y) | FMul(x, y) | FDiv(x, y) -> ([], [x; y])
      | Stfd(x, y, z') ->  (match z' with 
        | V(z) -> ([y; z], [x])
        | C(_) -> ([y], [x]) )
      | CallDir (label, argi, argf) -> (argi, argf) 
      | Save _ ->([], [])        (* ここまだ適当*)
      | IfEq(_) | IfLT(_) | IfFEq(_) | IfFLT(_) | IfFEqz(_)  | IfFLTz(_)  | IfFGTz(_) -> raise My_Error1
      | _ -> raise My_Error2
    )
    | Brunch (x, y') -> (match y' with 
      | V(y) -> ([x; y], [])
      | C(_) -> ([x], []) ) 
    | Brunchf (x, y) -> ([], [x; y])
    | Brunch_fzero (x) -> ([], [x])
    )

let int_graph = ref []
let float_graph = ref []

let rec union l1 l2 = match l1 with  (* 和集合をとる。 *)
  | [] -> l2
  | x::rest -> if List.mem x l2 then union rest l2 else x::(union rest l2)

let rec remove x l = match l with  (* l から要素xを削除 *)
  | [] -> []
  | a::rest -> if a = x then rest else a::(remove x rest)

let rec diff l1 l2 = match l2 with (* l1 - l2 *)
  | [] -> l1
  | x::rest -> if List.mem x l1 then diff (remove x l1) rest else diff l1 rest

let live_lis = ref []

let rec make_graph tree =       (* graphを参照を使いながら構成しつつ、返り値は live を返す *)
(* Format.eprintf "%d@." (List.length !live_lis); *)
  if List.mem_assoc tree !live_lis then List.assoc tree !live_lis else
    match tree with
      | Leaf -> ([], [])
      | Tree (_, _, tree1, tree2) ->  (
  let (int_live1, float_live1) = make_graph tree1 in
  let (int_live2, float_live2) = make_graph tree2 in
  let (int_def1, float_def1) = def tree1 in
  let (int_def2, float_def2) = def tree2 in
  let (int_use1, float_use1) = use tree1 in
  let (int_use2, float_use2) = use tree2 in
  let int_live_now = union (union (diff int_live1 int_def1) int_use1) (union (diff int_live2 int_def2) int_use2) in
  let float_live_now = union (union (diff float_live1 float_def1) float_use1) (union (diff float_live2 float_def2) float_use2) in
  live_lis := (tree, (int_live_now, float_live_now))::!live_lis;
  int_graph := (Graph.add !int_graph (Graph.complete int_live_now));
  float_graph := (Graph.add !float_graph (Graph.complete float_live_now));
  (int_live_now, float_live_now)  
      ) 

let subst l id = if is_reg id then id else (try List.assoc id l with _ -> id)      

let substimm l idimm = match idimm with
    | V(x) -> if is_reg x then V(x) else (try V(List.assoc x l) with _ -> idimm)
    | _ -> idimm

let rec substitute_exp l exp = match exp with
  | Mr(x) -> Mr(subst l x)
  | Neg(x) -> Neg(subst l x)
  | Swc(x, i) -> Swc(subst l x, i)
  | FMr(x) -> FMr(subst l x)
  | FNeg(x) -> FNeg(subst l x)
  | Swfc(x, i) -> Swfc(subst l x, i)
  | Restore(x) -> Restore(subst l x)
  | Add(x, y') -> Add(subst l x, substimm l y') 
  | Sub(x, y') -> Sub(subst l x, substimm l y') 
  | Slw(x, y') -> Slw(subst l x, substimm l y') 
  | Slr(x, y') -> Slr(subst l x, substimm l y') 
  | Lwz(x, y') -> Lwz(subst l x, substimm l y') 
  | Lfd(x, y') -> Lfd(subst l x, substimm l y') 
  | Stfdz(x, y') -> Stfdz(subst l x, substimm l y')
  | FAdd(x, y) -> FAdd(subst l x, subst l y)
  | FSub(x, y) -> FSub(subst l x, subst l y)
  | FMul(x, y) -> FMul(subst l x, subst l y)
  | FDiv(x, y) -> FDiv(subst l x, subst l y)
  | Save(x, y) -> Save(x, y)
  | Stw(x, y, z') -> Stw(subst l x, subst l y, substimm l z')
  | Stfd(x, y, z') -> Stfd(subst l x, subst l y, substimm l z')
  | IfEq (x, y', t1, t2) -> IfEq(subst l x, substimm l y', substitute l t1, substitute l t2)
  | IfLT (x, y', t1, t2) -> IfLT(subst l x, substimm l y', substitute l t1, substitute l t2)
  | IfFEq (x, y, t1, t2) -> IfFEq(subst l x, subst l y, substitute l t1, substitute l t2)
  | IfFLT (x, y, t1, t2) -> IfFLT(subst l x, subst l y, substitute l t1, substitute l t2)
  | IfFEqz (x, t1, t2) ->  IfFEqz(subst l x, substitute l t1, substitute l t2)
  | IfFLTz (x, t1, t2) ->  IfFLTz(subst l x, substitute l t1, substitute l t2)
  | IfFGTz (x, t1, t2) ->  IfFGTz(subst l x, substitute l t1, substitute l t2)
  | CallDir (label, argi, argf) -> CallDir (label, List.map (fun x -> subst l x) argi, List.map (fun x -> subst l x) argf) 
  | _ -> exp
and substitute l e = match e with
  | Ans(exp) -> Ans(substitute_exp l exp)
  | Let((x, ty), exp, t) -> (try Let(((List.assoc x l), ty), substitute_exp l exp, substitute l t) with _ ->  Let((x, ty), substitute_exp l exp, substitute l t) )

(*
基本
let x1 = exp1 in      (( i = 1
let x2 = exp2 in      (( i = 2
....
と続いていくのでこれらを一塊として見る。
ここで、
expがif文の場合   
let x = if a < b then t1 else t2 in t3　となっているとし、
t1 = let c1_1 = ex1_1 in let c1_2 = ex1_2 in ..... let c1_n = ex1_n in Ans(ex1)
t2 = let c2_1 = ex2_1 in let c2_2 = ex2_2 in ..... let c2_n = ex2_n in Ans(ex2)としたとき、
let c1_1 = ex1_1 in let c1_2 = ex1_2 in ..... let c1_n = ex1_n in let x = Ans(ex1) in t3　　と
let c2_1 = ex2_1 in let c2_2 = ex2_2 in ..... let c2_n = ex2_n in let x = Ans(ex2) in t3　　の
二つのパターンに書ける。
このようにしてif文を消すと木構造になる。

expが関数呼び出しの時 ここ考える必要ありそう。理想では引数、返り値の変数にそのままa0,a1とかって与えたいけど要求がぶつかる可能性あるよね。
そんときにMove命令入れなきゃいけないっぽい。
つまり exp = CallDir(Id.L(x), ys, zs)のとき、は意外とそのまま
*)

(* 関数呼び出しのときはどうやっても生きている変数を退避させる必要があるね。　*)
let rec var_exp_int e = match e with
  | Mr(x) | Neg(x) -> [x]
  | Add(x, y') | Sub(x, y') | Slw(x, y') | Slr(x, y') | Lfd(x, y') | Lwz(x, y') -> union [x] (fv_id_or_imm y')
  | Stfdz(x, y') -> fv_id_or_imm y'
  | Stw(x, y, z') | Stfd(x, y, z') -> union [y] (fv_id_or_imm z')
  | IfEq(x, y', e1, e2) | IfLT(x, y', e1, e2) ->  union [x] (union (fv_id_or_imm y') (union (var_int e1) (var_int e2)))
  | IfFEq(x, y, e1, e2) | IfFLT(x, y, e1, e2) -> union (var_int e1) (var_int e2)
  | IfFEqz(x, e1, e2) | IfFLTz(x, e1, e2) | IfFGTz(x, e1, e2)  -> union (var_int e1) (var_int e2)
  | CallDir(_, ys, zs) -> ys
  | _ -> []
and var_int e = match e with
    | Ans(exp) -> var_exp_int exp
    | Let((x, t), exp, e1) -> union (if t = Type.Int then [x] else []) (union (var_exp_int exp) (var_int e1))

let rec var_exp_float e = match e with
  | FMr(x) | FNeg(x) -> [x]
  | Stfdz(x, y') -> [x]
  | Stw(x, y, z') | Stfd(x, y, z') -> [x]
  | Swc(x, _) | Swfc(x, _) -> [x]
  | FAdd(x, y) | FSub(x, y) | FMul(x, y) | FDiv(x, y) -> union [x] [y]
  | IfEq(x, y', e1, e2) | IfLT(x, y', e1, e2) -> union (var_float e1) (var_float e2)
  | IfFEq(x, y, e1, e2) | IfFLT(x, y, e1, e2) -> union [x] (union [y] (union (var_float e1) (var_float e2)))
  | IfFEqz(x, e1, e2) | IfFLTz(x, e1, e2) | IfFGTz(x, e1, e2)  -> union [x] (union (var_float e1) (var_float e2))
  | CallDir(_, ys, zs) -> zs
  | _ -> []
and var_float e = match e with
    | Ans(exp) -> var_exp_float exp
    | Let((x, t), exp, e1) -> union (if t = Type.Float then [x] else []) (union (var_exp_float exp) (var_float e1))

let rec print_list l = match l with
    | [] -> ()
    | x::rest -> print_string x; print_string " "; print_list rest

let rec arg_alloc arglis reg_lis = match arglis with
    | [] -> []
    | arg1::rest -> (match reg_lis with
                      | reg1::rest2 -> (arg1, reg1)::(arg_alloc rest rest2))

(* 先頭k要素をlから除いたものを返す *)
let rec last k l = if k = 0 then l else match l with _::rest -> last (k - 1) rest

(* 関数の中身は取り敢えず引数にa0, a1... を代入してからそれらのレジスタを抜いたもので残りを割りあて 
ここあかん気がする。
*)
(* let rec ret_taihi e = match e with
  | Ans(exp) -> e
  | Let((x, Type.Float), CallDir(label, ys, zs), t) -> Let((Id.gentmp Type.Unit, Type.Unit), Save("%$f0", x), Let((x, Type.Float), CallDir(label, ys, zs), Let(("%$f0", Type.Float), Restore(x), ret_taihi t)))
  | Let((x, ty), CallDir(label, ys, zs), t) -> Let((Id.gentmp Type.Unit, Type.Unit), Save("%$a0", x), Let((x, ty), CallDir(label, ys, zs), Let(("%$a0", ty), Restore(x), ret_taihi t)))
  | Let(ty, exp, t) -> Let(ty, exp, ret_taihi t) *)

let fun_alloc f = 
  let int_arg_alloc = arg_alloc f.args (Array.to_list regs) in
  let float_arg_alloc = arg_alloc f.fargs (Array.to_list fregs) in
  (* let body2 = substitute (int_arg_alloc@float_arg_alloc) f.body in *)
  make_graph(e_to_tree f.body);
  (* let int_sub = Graph.alloc (last (List.length f.args) (Array.to_list regs)) (var_int body2) !int_graph in
  let float_sub = Graph.alloc (last (List.length f.fargs) (Array.to_list fregs)) (var_float body2) !float_graph in
  let body3 = substitute (int_sub@float_sub) body2 in *)
  let int_sub = Graph.alloc_priority (last 12 (Array.to_list regs)) (var_int f.body) !int_graph int_arg_alloc in
  let float_sub = Graph.alloc_priority (last 12 (Array.to_list fregs)) (var_float f.body) !float_graph float_arg_alloc in
  let body2 = substitute (int_sub@float_sub) f.body in
  {name = f.name; args = f.args; fargs = f.fargs; body = body2; ret = f.ret}

let f (Prog(data, fundefs, e, _)) =
  Format.eprintf "register allocation: may take some time (up to a few minutes, depending on the size of functions)@.";
  make_graph(e_to_tree e);
  Format.eprintf "register allocation: may take some time (up to a few minutes, depending on the size of functions)@.";
  (* print_string "int_graph\n";
  Graph.print_graph !int_graph;
  print_string "\nfloat_graph\n";
  Graph.print_graph !float_graph;
  print_string "\nvarの整数リスト\n";
  print_list (var_int e);
  print_char '\n';
  print_string "\nvarの浮動小数点リスト\n";
  print_list (var_float e);
  print_char '\n'; *)
  let int_sub = Graph.alloc (Array.to_list regs) (var_int e) !int_graph in
  let float_sub = Graph.alloc (Array.to_list fregs) (var_float e) !float_graph in
  (* Graph.print_graph int_sub;
  Graph.print_graph float_sub; *)
  (Prog(data, List.map fun_alloc fundefs, substitute (int_sub@float_sub) e, M.empty))
  Prog(data, fundefs, e, M.empty) *)