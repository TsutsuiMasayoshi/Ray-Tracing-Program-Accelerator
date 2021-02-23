open Asm

external gethi : float -> int32 = "gethi"
(* external getlo : float -> int32 = "getlo" *)

exception Float_Not_Found

let sign = ref 100
let kaeru = ref " "

let float_data = ref []

let stackset = ref S.empty (* すでにSaveされた変数の集合 *)
let stackmap = ref [] (* Saveされた変数の、スタックにおける位置 *)
let save x =
  stackset := S.add x !stackset;
  if not (List.mem x !stackmap) then
    stackmap := !stackmap @ [x]
let savef x =
  stackset := S.add x !stackset;
  if not (List.mem x !stackmap) then
    (let pad =
      if List.length !stackmap mod 2 = 0 then [] else [Id.gentmp Type.Int] in
    stackmap := !stackmap @ pad @ [x; x])
let locate x =
  let rec loc = function
    | [] -> []
    | y :: zs when x = y -> 0 :: List.map succ (loc zs)
    | y :: zs -> List.map succ (loc zs) in
  loc !stackmap
let offset x = 1 * List.hd (locate x)
let stacksize () = align ((List.length !stackmap + 1) * 1)

let reg r =
  if is_reg r
  then String.sub r 1 (String.length r - 1)
  else r

let load_label oc r label =
  let r' = reg r in
  Printf.fprintf oc
    "\tlahi\t%s, %s\n\tlalo\t%s, %s\n"
    r' label r' label
 

(* 関数呼び出しのために引数を並べ替える(register shuffling) (caml2html: emit_shuffle) *)
let rec shuffle sw xys =
  (* remove identical moves *)
  let _, xys = List.partition (fun (x, y) -> x = y) xys in
  (* find acyclic moves *)
  match List.partition (fun (_, y) -> List.mem_assoc y xys) xys with
  | [], [] -> []
  | (x, y) :: xys, [] -> (* no acyclic moves; resolve a cyclic move *)
      (y, sw) :: (x, y) :: shuffle sw (List.map
                                         (function
                                           | (y', z) when y = y' -> (sw, z)
                                           | yz -> yz)
                                         xys)
  | xys, acyc -> acyc @ shuffle sw xys

type dest = Tail | NonTail of Id.t (* 末尾かどうかを表すデータ型 (caml2html: emit_dest) *)
let rec g oc = function (*　命令列のアセンブリ生成 (caml2html: emit_g) *)
  | dest, Ans(exp) -> g' oc (dest, exp)
  | dest, Let((x, t), exp, e) ->
      g' oc (NonTail(x), exp);
      (* sign := 100; *)
      g oc (dest, e);
and g' oc = function (* 各命令のアセンブリ生成 (caml2html: emit_gprime) *)
  (* 末尾でなかったら計算結果をdestにセット　(caml2html: emit_nontail) *)
  | NonTail(_), Nop -> () (* ok *)
  | NonTail(x), Li(i) when -32768 <= i && i < 32768 -> 
  (if !sign = 100 || (!sign <> i) || (!kaeru <> x) then  
    Printf.fprintf oc "\taddi\t%s, %s, %d\n" (reg x) (reg reg_zero) i (* ok *)
    else ()
    )
  | NonTail(x), Li(i) ->
      let n = i lsr 16 in             (* iを右に16ビット右シフト *)
      let m = i lxor (n lsl 16) in
      let r = reg x in
      Printf.fprintf oc "\tlui\t%s, %d\n" r n;
      Printf.fprintf oc "\tori\t%s, %s, %d\n" r r m
  | NonTail(x), FLi(f) ->
     (
     try 
     let addr = List.assoc f !float_data in
     (* Printf.fprintf oc "\tlwc1\t%s, %d($zero)\n" (reg x) addr *)
     Printf.fprintf oc "\tfaddi\t%s, $fzero, $fi%d\n" (reg x) addr
     with _ -> print_float f; raise Float_Not_Found
     )
  | NonTail(x), SetL(Id.L(y)) ->
      load_label oc x y
  | NonTail(x), Mr(y) when x = y -> ()  (* move register ですねー*)  (* ok *)
  | NonTail(x), Mr(y) -> Printf.fprintf oc "\tadd\t%s, %s, %s\n" (reg x) (reg y) (reg reg_zero) (* ok *)
  | NonTail(x), Neg(y) -> Printf.fprintf oc "\tsub\t%s, %s, %s\n" (reg x) (reg reg_zero) (reg y)    (* ok *)
  | NonTail(x), Add(y, V(z)) -> Printf.fprintf oc "\tadd\t%s, %s, %s\n" (reg x) (reg y) (reg z)   (* ok *)
  | NonTail(x), Add(y, C(z)) -> Printf.fprintf oc "\taddi\t%s, %s, %d\n" (reg x) (reg y) z  (* ok *)
  | NonTail(x), Sub(y, V(z)) -> Printf.fprintf oc "\tsub\t%s, %s, %s\n" (reg x) (reg y) (reg z) (* ok *)
  | NonTail(x), Sub(y, C(z)) -> Printf.fprintf oc "\taddi\t%s, %s, %d\n" (reg x) (reg y) (-1 * z)  (* ok *)
  | NonTail(x), Slw(y, C(z)) -> Printf.fprintf oc "\tsll\t%s, %s, %d\n" (reg x) (reg y) z  (* shift left word  ok!*)
  | NonTail(x), Slr(y, C(z)) -> Printf.fprintf oc "\tsrl\t%s, %s, %d\n" (reg x) (reg y) z  (* shift right word  ok!*)
  | NonTail(x), Lwz(y, V(z)) -> (* ok *)
    (* Printf.fprintf oc "\tadd\t%s, %s, %s\n" (reg reg_my_temp) (reg y) (reg z);
    Printf.fprintf oc "\tlw\t%s, 0(%s)\n" (reg x) (reg reg_my_temp) *)
    Printf.fprintf oc "\tlw2\t%s, %s, %s\n" (reg x) (reg y) (reg z)
  | NonTail(x), Lwz(y, C(z)) -> Printf.fprintf oc "\tlw\t%s, %d(%s)\n" (reg x) z (reg y)  (* ok *) 
  | NonTail(x), Lwc(i) -> Printf.fprintf oc "\tlw\t%s, %d($zero)\n" (reg x) i (* ok *) 
  | NonTail(x), Lwfc(i) -> Printf.fprintf oc "\tlwc1\t%s, %d($zero)\n" (reg x) i (* ok *) 
  | NonTail(_), Stw(x, y, V(z)) ->    (* ok *)
    (* Printf.fprintf oc "\tadd\t%s, %s, %s\n" (reg reg_my_temp) (reg y) (reg z);
    Printf.fprintf oc "\tsw\t%s, 0(%s)\n" (reg x) (reg reg_my_temp) *)
    Printf.fprintf oc "\tsw2\t%s, %s, %s\n" (reg x) (reg y) (reg z)
  | NonTail(_), Stw(x, y, C(z)) -> Printf.fprintf oc "\tsw\t%s, %d(%s)\n" (reg x) z (reg y) (* ok *)
  | NonTail(_), Swc(x, i) -> Printf.fprintf oc "\tsw\t%s, %d($zero)\n" (reg x) i  (* ok *) 
  | NonTail(_), Swfc(x, i) -> Printf.fprintf oc "\tswc1\t%s, %d($zero)\n" (reg x) i  (* ok *) 
  | NonTail(_), Swfcz(i) -> Printf.fprintf oc "\tswc1\t%s, %d($zero)\n" (reg reg_fzero) i  (* ok *) 
  | NonTail(x), FMr(y) when x = y -> ()
  | NonTail(x), FMr(y) -> Printf.fprintf oc "\tadd.s\t%s, %s, $fzero\n" (reg x) (reg y) (* ok *)
  | NonTail(x), FNeg(y) -> Printf.fprintf oc "\tsub.s\t%s, $fzero, %s\n" (reg x) (reg y) (* ok *)
  | NonTail(x), FAdd(y, Vf(z)) -> Printf.fprintf oc "\tadd.s\t%s, %s, %s\n" (reg x) (reg y) (reg z) (* ok *)
  | NonTail(x), FAdd(y, Cf(z)) -> Printf.fprintf oc "\tfaddi\t%s, %s, $fi%d\n" (reg x) (reg y) (List.assoc z !float_data) (* ok *)
  | NonTail(x), FSub(y, Vf(z)) -> Printf.fprintf oc "\tsub.s\t%s, %s, %s\n" (reg x) (reg y) (reg z) (* ok *)
  | NonTail(x), FSub(y, Cf(z)) -> Printf.fprintf oc "\tfsubi\t%s, %s, $fi%d\n" (reg x) (reg y) (List.assoc z !float_data) (* ok *)
  | NonTail(x), FSub2(f, y) -> Printf.fprintf oc "\tfsubi2\t%s, $fi%d, %s\n" (reg x) (List.assoc f !float_data) (reg y) (* ok *)
  | NonTail(x), FMul(y, Vf(z)) -> Printf.fprintf oc "\tmul.s\t%s, %s, %s\n" (reg x) (reg y) (reg z) (* ok *)
  | NonTail(x), FMul(y, Cf(z)) -> Printf.fprintf oc "\tfmuli\t%s, %s, $fi%d\n" (reg x) (reg y) (List.assoc z !float_data) (* ok *)
  | NonTail(x), FDiv(y, Vf(z)) -> Printf.fprintf oc "\tdiv.s\t%s, %s, %s\n" (reg x) (reg y) (reg z) (* ok *)
  | NonTail(x), FDiv(y, Cf(z)) -> Printf.fprintf oc "\tfdivi\t%s, %s, $fi%d\n" (reg x) (reg y) (List.assoc z !float_data) (* ok *)
  | NonTail(x), FDiv2(f, y) -> Printf.fprintf oc "\tfdivi2\t%s, $fi%d, %s\n" (reg x) (List.assoc f !float_data) (reg y) (* ok *)
  | NonTail(x), Lfd(y, V(z)) ->    (* ok *)
    Printf.fprintf oc "\tadd\t%s, %s, %s\n" (reg reg_my_temp) (reg y) (reg z);
    Printf.fprintf oc "\tlwc1\t%s, 0(%s)\n" (reg x) (reg reg_my_temp)
    (* Printf.fprintf oc "\tlwc2\t%s, %s, %s\n" (reg x) (reg y) (reg z) *)
  | NonTail(x), Lfd(y, C(z)) -> Printf.fprintf oc "\tlwc1\t%s, %d(%s)\n" (reg x) z (reg y)  (* ok *)
  | NonTail(_), Stfd(x, y, V(z)) ->     (* ok *)
    Printf.fprintf oc "\tadd\t%s, %s, %s\n" (reg reg_my_temp) (reg y) (reg z);
    Printf.fprintf oc "\tswc1\t%s, 0(%s)\n" (reg x) (reg reg_my_temp)
    (* Printf.fprintf oc "\tswc2\t%s, %s, %s\n" (reg x) (reg y) (reg z) *)
  | NonTail(_), Stfdz(y, V(z)) ->     (* ok *)
    Printf.fprintf oc "\tadd\t%s, %s, %s\n" (reg reg_my_temp) (reg y) (reg z);
    Printf.fprintf oc "\tswc1\t%s, 0(%s)\n" (reg reg_fzero) (reg reg_my_temp)
    (* Printf.fprintf oc "\tswc2\t%s, %s, %s\n" (reg reg_fzero) (reg y) (reg z) *)
  | NonTail(_), Stfd(x, y, C(z)) -> Printf.fprintf oc "\tswc1\t%s, %d(%s)\n" (reg x) z (reg y)   (* ok *)
  | NonTail(_), Stfdz(y, C(z)) -> Printf.fprintf oc "\tswc1\t%s, %d(%s)\n" (reg reg_fzero) z (reg y)   (* ok *)
  | NonTail(_), Comment(s) -> Printf.fprintf oc "#\t%s\n" s    (* ok *)
  (* 退避の仮想命令の実装(caml2html: emit_save) *)
  | NonTail(_), Save(x, y) when List.mem x allregs && not (S.mem y !stackset) ->
      save y;
      Printf.fprintf oc "\tsw\t%s, %d(%s)\n" (reg x) (offset y) (reg reg_sp)
  | NonTail(_), Save(x, y) when List.mem x allfregs && not (S.mem y !stackset) ->
      savef y;
      Printf.fprintf oc "\tswc1\t%s, %d(%s)\n" (reg x) (offset y) (reg reg_sp)
  | NonTail(_), Save(x, y) -> assert (S.mem y !stackset); ()
  (* 復帰の仮想命令の実装 (caml2html: emit_restore) *)
  | NonTail(x), Restore(y) when List.mem x allregs ->
      Printf.fprintf oc "\tlw\t%s, %d(%s)\n" (reg x) (offset y) (reg reg_sp)
  | NonTail(x), Restore(y) ->
      assert (List.mem x allfregs);
      Printf.fprintf oc "\tlwc1\t%s, %d(%s)\n" (reg x) (offset y) (reg reg_sp)
  (* 末尾だったら計算結果を第一レジスタにセットしてret (caml2html: emit_tailret) *)
  | Tail, (Nop | Stw _ | Stfd _ | Comment _ | Save _ | Swc _ | Swfc _ | Stfdz _ | Swfcz _ as exp) ->
      g' oc (NonTail(Id.gentmp Type.Unit), exp);
      Printf.fprintf oc "\tjr\t$ra\n";
  | Tail, (Li _ | SetL _ | Mr _ | Neg _ | Add _ | Sub _ | Slw _ | Slr _ | Lwz _ | Lwc _ as exp) ->
      g' oc (NonTail(regs.(0)), exp);
      Printf.fprintf oc "\tjr\t$ra\n";
  | Tail, (FLi _ | FMr _ | FNeg _ | FAdd _ | FSub _ | FMul _ | FDiv _ | FSub2 _ | FDiv2 _ | Lfd _ | Lwfc _ as exp) ->
      g' oc (NonTail(fregs.(0)), exp);
      Printf.fprintf oc "\tjr\t$ra\n";
  | Tail, (Restore(x) as exp) ->
      (match locate x with
      | [i] -> g' oc (NonTail(regs.(0)), exp)
      | [i; j] when i + 1 = j -> g' oc (NonTail(fregs.(0)), exp)
      | _ -> assert false);
      Printf.fprintf oc "\tjr\t$ra\n";
  | Tail, IfEq(x, V(y), e1, e2) when x = y -> 
      g oc (Tail, e1)
  | Tail, IfEq(x, V(y), e1, e2) ->    (* ok *)
      let b_else = Id.genid ("bne_else") in
      Printf.fprintf oc "\tbne\t%s, %s, %s\n" (reg x) (reg y) b_else;
      let stackset_back = !stackset in
      g oc (Tail, e1);
      Printf.fprintf oc "%s:\n" b_else;
      stackset := stackset_back;
      g oc (Tail, e2)
  | Tail, IfEq(x, C(y), e1, e2) ->    (* ok *)
      let b_else = Id.genid ("bne_else") in
      (if (0 <= y) && (y < 32) then
      Printf.fprintf oc "\tbnei\t%s, %d, %s\n" (reg x) y b_else
      else
      (
      Printf.fprintf oc "\taddi\t$s1, $zero, %d\n" y;
      Printf.fprintf oc "\tbne\t%s, $s1, %s\n" (reg x) b_else
      ));
      let stackset_back = !stackset in

      g oc (Tail, e1);
      Printf.fprintf oc "%s:\n" b_else;
      stackset := stackset_back;
      g oc (Tail, e2)
   | Tail, IfLT(x, V(y), e1, e2) ->  (* ok *)
      (* Printf.fprintf oc "\tslt\t$s0, %s, %s\n" (reg x) (reg y);  (*  (y < x thenとelseを逆に)   x <= y  *)
      g'_tail_if oc e1 e2 "bne" "beq" *)
      let b_else = Id.genid ("blt_true") in
      Printf.fprintf oc "\tblt\t%s, %s, %s\n" (reg x) (reg y) b_else;
      let stackset_back = !stackset in
      g oc (Tail, e2);
      Printf.fprintf oc "%s:\n" b_else;
      stackset := stackset_back;
      g oc (Tail, e1)
  | Tail, IfLT(x, C(y), e1, e2) ->  (* ok *)
      (* Printf.fprintf oc "\tslti\t$s0, %s, %d\n" (reg x) y; 
      g'_tail_if oc e1 e2 "bne" "beq" *)
      if (y >= 32) then
      (Printf.fprintf oc "\tslti\t$s0, %s, %d\n" (reg x) y; 
      g'_tail_if oc e1 e2 "bne" "beq")
      else (
      let b_else = Id.genid ("blti_true") in
      Printf.fprintf oc "\tblti\t%s, %d, %s\n" (reg x) y b_else;
      let stackset_back = !stackset in
      g oc (Tail, e2);
      Printf.fprintf oc "%s:\n" b_else;
      stackset := stackset_back;
      g oc (Tail, e1))
  | Tail, IfLT2(i, y, e1, e2) ->  (* ok *)
      let b_else = Id.genid ("blti_true") in
      Printf.fprintf oc "\tblti2\t%d, %s, %s\n" i (reg y) b_else;
      let stackset_back = !stackset in
      g oc (Tail, e2);
      Printf.fprintf oc "%s:\n" b_else;
      stackset := stackset_back;
      g oc (Tail, e1)
  | Tail, IfFEq(x, y, e1, e2) -> 
    let b_else = Id.genid ("c.ne_else") in
    (* Printf.fprintf oc "\tc.eq.s\t%s, %s, %s\n" (reg reg_my_temp) (reg x) (reg y);
    Printf.fprintf oc "\tbeq\t%s, %s, %s\n" (reg reg_my_temp) (reg reg_zero) b_else; *)
    Printf.fprintf oc "\tbfeq\t%s, %s, %s\n" (reg x) (reg y) b_else;
    let stackset_back = !stackset in
    g oc (Tail, e2);
    Printf.fprintf oc "%s:\n" b_else;
    stackset := stackset_back;
    g oc (Tail, e1)
  | Tail, IfFEqz(x, e1, e2) -> 
    let b_else = Id.genid ("c.ne_else") in
    (* Printf.fprintf oc "\tc.eq.s\t%s, %s, %s\n" (reg reg_my_temp) (reg x) (reg reg_fzero);
    Printf.fprintf oc "\tbeq\t%s, %s, %s\n" (reg reg_my_temp) (reg reg_zero) b_else; *)
    Printf.fprintf oc "\tbfeq\t%s, $fzero, %s\n" (reg x) b_else;
    let stackset_back = !stackset in
    g oc (Tail, e2);
    Printf.fprintf oc "%s:\n" b_else;
    stackset := stackset_back;
    g oc (Tail, e1)
  | Tail, IfFLT(x, y, e1, e2) ->    (* ok *)
      (* Printf.fprintf oc "\tc.lt.s\t$s0, %s, %s\n" (reg x) (reg y);       
      g'_tail_if oc e1 e2 "bne" "beq" *)
      let b_else = Id.genid ("bflt_true") in
      Printf.fprintf oc "\tbflt\t%s, %s, %s\n" (reg x) (reg y) b_else;
      let stackset_back = !stackset in
      g oc (Tail, e2);
      Printf.fprintf oc "%s:\n" b_else;
      stackset := stackset_back;
      g oc (Tail, e1)
   | Tail, IfFLTi1(x, y, e1, e2) ->    (* ok *)
      let b_else = Id.genid ("bflt_true") in
      Printf.fprintf oc "\tbflti1\t$fi%d, %s, %s\n" (List.assoc x !float_data) (reg y) b_else;
      let stackset_back = !stackset in
      g oc (Tail, e2);
      Printf.fprintf oc "%s:\n" b_else;
      stackset := stackset_back;
      g oc (Tail, e1)
  | Tail, IfFLTi2(x, y, e1, e2) ->    (* ok *)
      let b_else = Id.genid ("bflt_true") in
      Printf.fprintf oc "\tbflti2\t%s, $fi%d, %s\n" (reg x) (List.assoc y !float_data) b_else;
      let stackset_back = !stackset in
      g oc (Tail, e2);
      Printf.fprintf oc "%s:\n" b_else;
      stackset := stackset_back;
      g oc (Tail, e1)
  | Tail, IfFLTz(x, e1, e2) ->    (* ok *)
      (* Printf.fprintf oc "\tc.lt.s\t$s0, %s, %s\n" (reg x) (reg reg_fzero);       
      g'_tail_if oc e1 e2 "bne" "beq" *)
      let b_else = Id.genid ("bflt_true") in
      Printf.fprintf oc "\tbflt\t%s, $fzero, %s\n" (reg x) b_else;
      let stackset_back = !stackset in
      g oc (Tail, e2);
      Printf.fprintf oc "%s:\n" b_else;
      stackset := stackset_back;
      g oc (Tail, e1)
  | Tail, IfFGTz(x, e1, e2) ->    (* ok *)
      (* Printf.fprintf oc "\tc.lt.s\t$s0, %s, %s\n" (reg reg_fzero) (reg x);       
      g'_tail_if oc e1 e2 "bne" "beq" *)
      let b_else = Id.genid ("bflt_true") in
      Printf.fprintf oc "\tbflt\t$fzero, %s, %s\n" (reg x) b_else;
      let stackset_back = !stackset in
      g oc (Tail, e2);
      Printf.fprintf oc "%s:\n" b_else;
      stackset := stackset_back;
      g oc (Tail, e1)
  | NonTail(z), IfEq(x, V(y), e1, e2) when x = y -> 
    let dest = NonTail(z) in
    g oc (dest, e1);
  | NonTail(z), IfEq(x, V(y), e1, e2) -> (* ok *)
      let dest = NonTail(z) in
      let b = "beq" in
      let b_else = Id.genid (b ^ "_else") in
      let b_cont = Id.genid (b ^ "_cont") in
      Printf.fprintf oc "\tbne\t%s, %s, %s\n" (reg x) (reg y) (if e2 = Ans(Nop) then b_cont else b_else);
      let stackset_back = !stackset in
      g oc (dest, e1);
      let stackset1 = !stackset in
      if e2 = Ans(Nop) then () else (
      Printf.fprintf oc "\tj\t%s\n" b_cont;
      Printf.fprintf oc "%s:\n" b_else);
      stackset := stackset_back;
      g oc (dest, e2);
      Printf.fprintf oc "%s:\n" b_cont;
      let stackset2 = !stackset in
      stackset := S.inter stackset1 stackset2
  | NonTail(z), IfEq(x, C(y), e1, e2) -> (* ok *)
      let dest = NonTail(z) in
      let b = "beq" in
      let b_else = Id.genid (b ^ "_else") in
      let b_cont = Id.genid (b ^ "_cont") in
      (if (0 <= y) && (y < 32) then
      Printf.fprintf oc "\tbnei\t%s, %d, %s\n" (reg x) y (if e2 = Ans(Nop) then b_cont else b_else)
      else
      (
      Printf.fprintf oc "\taddi\t$s1, $zero, %d\n" y;
      Printf.fprintf oc "\tbne\t%s, $s1, %s\n" (reg x) (if e2 = Ans(Nop) then b_cont else b_else);
      ));
      let stackset_back = !stackset in
      (match e1 with 
        | Let((x', _), Li(y'), e3) when x = x' && y = y' -> (g oc (dest, e3))
        | _ -> (sign := y; kaeru:= x; g oc (dest, e1); kaeru:= " "; sign := 100) );
      let stackset1 = !stackset in
      if e2 = Ans(Nop) then () else (
      Printf.fprintf oc "\tj\t%s\n" b_cont;
      Printf.fprintf oc "%s:\n" b_else);
      stackset := stackset_back;
      g oc (dest, e2);
      kaeru := " ";
      Printf.fprintf oc "%s:\n" b_cont;
      let stackset2 = !stackset in
      stackset := S.inter stackset1 stackset2
  | NonTail(z), IfLT(x, V(y), e1, e2) ->  (*  ok  *)
      (* Printf.fprintf oc "\tslt\t$s0, %s, %s\n" (reg x) (reg y);
      g'_non_tail_if oc (NonTail(z)) e1 e2 "bne" "beq" *)
      let dest = NonTail(z) in
      let b = "beq" in
      let b_else = Id.genid (b ^ "_else") in
      let b_cont = Id.genid (b ^ "_cont") in
      Printf.fprintf oc "\tblt\t%s, %s, %s\n" (reg x) (reg y) (if e1 = Ans(Nop) then b_cont else b_else);
      let stackset_back = !stackset in
      g oc (dest, e2);
      let stackset1 = !stackset in
      if e1 = Ans(Nop) then () else (
      Printf.fprintf oc "\tj\t%s\n" b_cont;
      Printf.fprintf oc "%s:\n" b_else);
      stackset := stackset_back;
      g oc (dest, e1);
      Printf.fprintf oc "%s:\n" b_cont;
      let stackset2 = !stackset in
      stackset := S.inter stackset1 stackset2
  | NonTail(z), IfLT2(i, y, e1, e2) ->  (*  ok  *)
      let dest = NonTail(z) in
      let b = "beq" in
      let b_else = Id.genid (b ^ "_else") in
      let b_cont = Id.genid (b ^ "_cont") in
      Printf.fprintf oc "\tblti2\t%d, %s, %s\n" i (reg y) (if e1 = Ans(Nop) then b_cont else b_else);
      let stackset_back = !stackset in
      g oc (dest, e2);
      let stackset1 = !stackset in
      if e1 = Ans(Nop) then () else (
      Printf.fprintf oc "\tj\t%s\n" b_cont;
      Printf.fprintf oc "%s:\n" b_else);
      stackset := stackset_back;
      g oc (dest, e1);
      Printf.fprintf oc "%s:\n" b_cont;
      let stackset2 = !stackset in
      stackset := S.inter stackset1 stackset2
  | NonTail(z), IfFEqz(x, e1, e2) ->
    let dest = NonTail(z) in
    let b = "c.eq" in
    let b_else = Id.genid (b ^ "_else") in
    let b_cont = Id.genid (b ^ "_cont") in
    (* Printf.fprintf oc "\tc.eq.s\t%s, %s, %s\n" (reg reg_my_temp) (reg x) (reg reg_fzero);
    Printf.fprintf oc "\tbeq\t%s, %s, %s\n" (reg reg_my_temp) (reg reg_zero) b_else; *)
    Printf.fprintf oc "\tbfeq\t%s, $fzero, %s\n" (reg x) (if e1 = Ans(Nop) then b_cont else b_else);
    let stackset_back = !stackset in
    g oc (dest, e2);
    let stackset1 = !stackset in
    if e1 = Ans(Nop) then () else (
      Printf.fprintf oc "\tj\t%s\n" b_cont;
      Printf.fprintf oc "%s:\n" b_else);
    stackset := stackset_back;
    g oc (dest, e1);
    Printf.fprintf oc "%s:\n" b_cont;
    let stackset2 = !stackset in
    stackset := S.inter stackset1 stackset2
   | NonTail(z), IfLT(x, C(y), e1, e2) ->  (*  ok  *)
      (* Printf.fprintf oc "\tslti\t$s0, %s, %d\n" (reg x) y;
      g'_non_tail_if oc (NonTail(z)) e1 e2 "bne" "beq" *)
      if (y >= 32) then
      (Printf.fprintf oc "\tslti\t$s0, %s, %d\n" (reg x) y; 
      g'_tail_if oc e1 e2 "bne" "beq")
      else (
      let dest = NonTail(z) in
      let b = "beq" in
      let b_else = Id.genid (b ^ "_else") in
      let b_cont = Id.genid (b ^ "_cont") in
      Printf.fprintf oc "\tblti\t%s, %d, %s\n" (reg x) y (if e1 = Ans(Nop) then b_cont else b_else);
      let stackset_back = !stackset in
      g oc (dest, e2);
      let stackset1 = !stackset in
      if e1 = Ans(Nop) then () else (
      Printf.fprintf oc "\tj\t%s\n" b_cont;
      Printf.fprintf oc "%s:\n" b_else);
      stackset := stackset_back;
      g oc (dest, e1);
      Printf.fprintf oc "%s:\n" b_cont;
      let stackset2 = !stackset in
      stackset := S.inter stackset1 stackset2
      )
   | NonTail(z), IfFLTi1(x, y, e1, e2) ->  (*  ok  *)
      let dest = NonTail(z) in
      let b = "beq" in
      let b_else = Id.genid (b ^ "_else") in
      let b_cont = Id.genid (b ^ "_cont") in
      Printf.fprintf oc "\tbflti1\t$fi%d, %s, %s\n" (List.assoc x !float_data) (reg y) (if e1 = Ans(Nop) then b_cont else b_else);
      let stackset_back = !stackset in
      g oc (dest, e2);
      let stackset1 = !stackset in
      if e1 = Ans(Nop) then () else (
        Printf.fprintf oc "\tj\t%s\n" b_cont;
        Printf.fprintf oc "%s:\n" b_else); 
      stackset := stackset_back;
      g oc (dest, e1);
      Printf.fprintf oc "%s:\n" b_cont;
      let stackset2 = !stackset in
      stackset := S.inter stackset1 stackset2
   | NonTail(z), IfFLTi2(x, y, e1, e2) ->  (*  ok  *)
      let dest = NonTail(z) in
      let b = "beq" in
      let b_else = Id.genid (b ^ "_else") in
      let b_cont = Id.genid (b ^ "_cont") in
      Printf.fprintf oc "\tbflti2\t%s, $fi%d, %s\n" (reg x) (List.assoc y !float_data) (if e1 = Ans(Nop) then b_cont else b_else);
      let stackset_back = !stackset in
      g oc (dest, e2);
      let stackset1 = !stackset in
      if e1 = Ans(Nop) then () else (
      Printf.fprintf oc "\tj\t%s\n" b_cont;
      Printf.fprintf oc "%s:\n" b_else);
      stackset := stackset_back;
      g oc (dest, e1);
      Printf.fprintf oc "%s:\n" b_cont;
      let stackset2 = !stackset in
      stackset := S.inter stackset1 stackset2
  | NonTail(z), IfFEq(x, y, e1, e2) ->
    let dest = NonTail(z) in
    let b = "c.eq" in
    let b_else = Id.genid (b ^ "_else") in
    let b_cont = Id.genid (b ^ "_cont") in
    (* Printf.fprintf oc "\tc.eq.s\t%s, %s, %s\n" (reg reg_my_temp) (reg x) (reg y);
    Printf.fprintf oc "\tbeq\t%s, %s, %s\n" (reg reg_my_temp) (reg reg_zero) b_else; *)
    Printf.fprintf oc "\tbfeq\t%s, %s, %s\n" (reg x) (reg y) (if e1 = Ans(Nop) then b_cont else b_else);
    let stackset_back = !stackset in
    g oc (dest, e2);
    let stackset1 = !stackset in
    if e1 = Ans(Nop) then () else (
      Printf.fprintf oc "\tj\t%s\n" b_cont;
      Printf.fprintf oc "%s:\n" b_else);
    stackset := stackset_back;
    g oc (dest, e1);
    Printf.fprintf oc "%s:\n" b_cont;
    let stackset2 = !stackset in
    stackset := S.inter stackset1 stackset2
  | NonTail(z), IfFEqz(x, e1, e2) ->
    let dest = NonTail(z) in
    let b = "c.eq" in
    let b_else = Id.genid (b ^ "_else") in
    let b_cont = Id.genid (b ^ "_cont") in
    (* Printf.fprintf oc "\tc.eq.s\t%s, %s, %s\n" (reg reg_my_temp) (reg x) (reg reg_fzero);
    Printf.fprintf oc "\tbeq\t%s, %s, %s\n" (reg reg_my_temp) (reg reg_zero) b_else; *)
    Printf.fprintf oc "\tbfeq\t%s, $fzero, %s\n" (reg x) (if e1 = Ans(Nop) then b_cont else b_else);
    let stackset_back = !stackset in
    g oc (dest, e2);
    let stackset1 = !stackset in
    if e1 = Ans(Nop) then () else (
      Printf.fprintf oc "\tj\t%s\n" b_cont;
      Printf.fprintf oc "%s:\n" b_else);
    stackset := stackset_back;
    g oc (dest, e1);
    Printf.fprintf oc "%s:\n" b_cont;
    let stackset2 = !stackset in
    stackset := S.inter stackset1 stackset2
  | NonTail(z), IfFLT(x, y, e1, e2) ->  (* ok   x <= y then e1 else e2 ----> x > y then e2 else e1  ----> y < x then e2 else e1    *)
      (* Printf.fprintf oc "\tc.lt.s\t$s0, %s, %s\n" (reg x) (reg y);       
      g'_non_tail_if oc (NonTail(z)) e1 e2 "bne" "beq" *)
      let dest = NonTail(z) in
      let b = "beq" in
      let b_else = Id.genid (b ^ "_else") in
      let b_cont = Id.genid (b ^ "_cont") in
      Printf.fprintf oc "\tbflt\t%s, %s, %s\n" (reg x) (reg y) (if e1 = Ans(Nop) then b_cont else b_else);
      let stackset_back = !stackset in
      g oc (dest, e2);
      let stackset1 = !stackset in
      if e1 = Ans(Nop) then () else (
      Printf.fprintf oc "\tj\t%s\n" b_cont;
      Printf.fprintf oc "%s:\n" b_else);
      stackset := stackset_back;
      g oc (dest, e1);
      Printf.fprintf oc "%s:\n" b_cont;
      let stackset2 = !stackset in
      stackset := S.inter stackset1 stackset2
  | NonTail(z), IfFLTz(x, e1, e2) ->  (* ok   x <= y then e1 else e2 ----> x > y then e2 else e1  ----> y < x then e2 else e1    *)
      (* Printf.fprintf oc "\tc.lt.s\t$s0, %s, %s\n" (reg x) (reg reg_fzero);       
      g'_non_tail_if oc (NonTail(z)) e1 e2 "bne" "beq" *)
      let dest = NonTail(z) in
      let b = "beq" in
      let b_else = Id.genid (b ^ "_else") in
      let b_cont = Id.genid (b ^ "_cont") in
      Printf.fprintf oc "\tbflt\t%s, $fzero, %s\n" (reg x) (if e1 = Ans(Nop) then b_cont else b_else);
      let stackset_back = !stackset in
      g oc (dest, e2);
      let stackset1 = !stackset in
      if e1 = Ans(Nop) then () else (
      Printf.fprintf oc "\tj\t%s\n" b_cont;
      Printf.fprintf oc "%s:\n" b_else);
      stackset := stackset_back;
      g oc (dest, e1);
      Printf.fprintf oc "%s:\n" b_cont;
      let stackset2 = !stackset in
      stackset := S.inter stackset1 stackset2
  | NonTail(z), IfFGTz(x, e1, e2) ->  (* ok   x <= y then e1 else e2 ----> x > y then e2 else e1  ----> y < x then e2 else e1    *)
      (* Printf.fprintf oc "\tc.lt.s\t$s0, %s, %s\n" (reg reg_fzero) (reg x);       
      g'_non_tail_if oc (NonTail(z)) e1 e2 "bne" "beq" *)
      let dest = NonTail(z) in
      let b = "beq" in
      let b_else = Id.genid (b ^ "_else") in
      let b_cont = Id.genid (b ^ "_cont") in
      Printf.fprintf oc "\tbflt\t$fzero, %s, %s\n" (reg x) (if e1 = Ans(Nop) then b_cont else b_else);
      let stackset_back = !stackset in
      g oc (dest, e2);
      let stackset1 = !stackset in
      if e1 = Ans(Nop) then () else (
        Printf.fprintf oc "\tj\t%s\n" b_cont;
        Printf.fprintf oc "%s:\n" b_else);
      stackset := stackset_back;
      g oc (dest, e1);
      Printf.fprintf oc "%s:\n" b_cont;
      let stackset2 = !stackset in
      stackset := S.inter stackset1 stackset2
  | Tail, CallDir(Id.L(x), ys, zs) -> (* 末尾呼び出し 多分 ok *)
      g'_args oc [] ys zs;
      if x = "min_caml_sqrt" then Printf.fprintf oc "\tsqrt\t$f0, $f0\n\tjr\t$ra\n" else
      if x = "min_caml_floor" then Printf.fprintf oc "\tfloor\t$f0, $f0\n\tjr\t$ra\n" else
      if x = "min_caml_int_of_float" then Printf.fprintf oc "\tftoi\t$a0, $f0\n\tjr\t$ra\n" else
      if x = "min_caml_float_of_int" then Printf.fprintf oc "\titof\t$f0, $a0\n\tjr\t$ra\n" else
      if x = "min_caml_print_char" then Printf.fprintf oc "\toutc\t$a0\n\tjr\t$ra\n" else
      if x = "min_caml_print_int" then Printf.fprintf oc "\touti\t$a0\n\tjr\t$ra\n" else
      if x = "min_caml_read_int" then Printf.fprintf oc "\treadi\t$a0\n\tjr\t$ra\n" else
      if x = "min_caml_read_float" then Printf.fprintf oc "\treadf\t$f0\n\tjr\t$ra\n" else
      Printf.fprintf oc "\tj\t%s\n" x
  | (NonTail(a), CallDir(Id.L(x), ys, zs)) ->
      g'_args oc [] ys zs;
  ( 
      if x = "min_caml_sqrt" then Printf.fprintf oc "\tsqrt\t$f0, $f0\n" else
      if x = "min_caml_floor" then Printf.fprintf oc "\tfloor\t$f0, $f0\n" else
      if x = "min_caml_int_of_float" then Printf.fprintf oc "\tftoi\t$a0, $f0\n" else
      if x = "min_caml_float_of_int" then Printf.fprintf oc "\titof\t$f0, $a0\n" else
      if x = "min_caml_print_char" then Printf.fprintf oc "\toutc\t$a0\n" else
      if x = "min_caml_print_int" then Printf.fprintf oc "\touti\t$a0\n" else
      if x = "min_caml_read_int" then Printf.fprintf oc "\treadi\t$a0\n" else
      if x = "min_caml_read_float" then Printf.fprintf oc "\treadf\t$f0\n" else
      if x = "min_caml_create_array" then (
      let ss = stacksize () in
      Printf.fprintf oc "\tsw\t%s, %d(%s)\n" (reg reg_ra) (ss - 1) (reg reg_sp);
      Printf.fprintf oc "\tjal\t%s\n" x;
      Printf.fprintf oc "\tlw\t%s, %d(%s)\n" (reg reg_ra) (ss - 1) (reg reg_sp) )
      else if x = "min_caml_create_float_array" then 
      (
      let ss = stacksize () in
      Printf.fprintf oc "\tsw\t%s, %d(%s)\n" (reg reg_ra) (ss - 1) (reg reg_sp);
      Printf.fprintf oc "\tjal\t%s\n" x;
      Printf.fprintf oc "\tlw\t%s, %d(%s)\n" (reg reg_ra) (ss - 1) (reg reg_sp)
      )
       else
       ( 
      let ss = stacksize () in
      Printf.fprintf oc "\tsw\t%s, %d(%s)\n" (reg reg_ra) (ss - 1) (reg reg_sp);
      (* Printf.fprintf oc "\tsw\t$a0, %d(%s)\n"  (ss - 2) (reg reg_sp); *)
      Printf.fprintf oc "\taddi\t%s, %s, %d\n" (reg reg_sp) (reg reg_sp) ss;
      Printf.fprintf oc "\tjal\t%s\n" x;
      Printf.fprintf oc "\taddi\t%s, %s, %d\n" (reg reg_sp) (reg reg_sp) (-1 * ss);
      (* Printf.fprintf oc "\tlw\t$a0, %d(%s)\n"  (ss - 2) (reg reg_sp); *)
      Printf.fprintf oc "\tlw\t%s, %d(%s)\n" (reg reg_ra) (ss - 1) (reg reg_sp);  ) );
      if List.mem a allregs && a <> regs.(0) then
        Printf.fprintf oc "\tadd\t%s, %s, %s\n" (reg a) (reg regs.(0)) (reg reg_zero)
      else if List.mem a allfregs && a <> fregs.(0) then
        Printf.fprintf oc "\tadd.s\t%s, $fzero, %s\n" (reg a) (reg fregs.(0)); 
      (* Printf.fprintf oc "\tmtlr\t%s\n" (reg reg_tmp) *)
and g'_tail_if oc e1 e2 b bn =   (*本質的に命令に関係するのはbnのみ*)
  let b_else = Id.genid (b ^ "_else") in
  Printf.fprintf oc "\t%s\t$s0, $zero, %s\n" bn b_else;
  let stackset_back = !stackset in
  g oc (Tail, e1);
  Printf.fprintf oc "%s:\n" b_else;
  stackset := stackset_back;
  g oc (Tail, e2)
and g'_non_tail_if oc dest e1 e2 b bn =
  let b_else = Id.genid (b ^ "_else") in
  let b_cont = Id.genid (b ^ "_cont") in
  Printf.fprintf oc "\t%s\t$s0, $zero, %s\n" bn b_else;
  let stackset_back = !stackset in
  g oc (dest, e1);
  let stackset1 = !stackset in
  Printf.fprintf oc "\tj\t%s\n" b_cont;
  Printf.fprintf oc "%s:\n" b_else;
  stackset := stackset_back;
  g oc (dest, e2);
  Printf.fprintf oc "%s:\n" b_cont;
  let stackset2 = !stackset in
  stackset := S.inter stackset1 stackset2
and g'_args oc x_reg_cl ys zs = (* まだあまり見ていないが、恐らく関数呼び出しで飛ぶときに引数にセット(必要な値を保存した後) *)
  let (i, yrs) =
    List.fold_left
      (fun (i, yrs) y -> (i + 1, (y, regs.(i)) :: yrs))
      (0, x_reg_cl)
      ys in
  List.iter
    (fun (y, r) -> Printf.fprintf oc "\tadd\t%s, %s, %s\n" (reg r) (reg reg_zero) (reg y))
    (shuffle reg_sw yrs);
  let (d, zfrs) =
    List.fold_left
      (fun (d, zfrs) z -> (d + 1, (z, fregs.(d)) :: zfrs))
      (0, [])
      zs in
  List.iter
    (fun (z, fr) -> Printf.fprintf oc "\tadd.s\t%s, $fzero, %s\n" (reg fr) (reg z))
    (shuffle reg_fsw zfrs)

let h oc { name = Id.L(x); args = _; fargs = _; body = e; ret = _ } =
  Printf.fprintf oc "%s:\n" x;
  stackset := S.empty;
  stackmap := [];
  g oc (Tail, e)


let rec float_save oc data = match data with
    | [] -> ()
    | (f1, addr)::rest -> 
    (* if f1 = 0. then () else *)
      let i = Int32.bits_of_float f1 in
      let a = Int32.shift_right i 16 in
      let b = Int32.logand i (Int32.of_int 65535) in
      Printf.fprintf oc "\tflui\t$fi%d, %d\n" addr (Int32.to_int a);
      Printf.fprintf oc "\tfori\t$fi%d, $fi%d, %d\n" addr addr (Int32.to_int b);
      (* Printf.fprintf oc "\tswc1\t$f0, %d($zero)\n" addr; *)
      float_save oc rest

let f oc (Prog(data, fundefs, e, _)) =
  Format.eprintf "generating assembly...@.";
  float_save oc data;
  Printf.fprintf oc "\tj\t_min_caml_start\n";
  (* ライブラリ関数〜*)
  (* min_caml_create_array *)
  Printf.fprintf oc "min_caml_create_array:\n";
  Printf.fprintf oc "\taddi\t$s0, $a0, 0\n";
  Printf.fprintf oc "\taddi\t$a0, $gp, 0\n";
  Printf.fprintf oc "create_array_loop:\n";
  Printf.fprintf oc "\tbne\t$s0, $zero, create_array_cont\n";
  Printf.fprintf oc "\tjr\t$ra\n";
  Printf.fprintf oc "create_array_cont:\n";
  Printf.fprintf oc "\tsw\t$a1, 0($gp)\n";
  Printf.fprintf oc "\taddi\t$s0, $s0, -1\n";
  Printf.fprintf oc "\taddi\t$gp, $gp, 1\n";
  Printf.fprintf oc "\tj\tcreate_array_loop\n";
  (* min_caml_create_float_array *)
  Printf.fprintf oc "min_caml_create_float_array:\n";
  Printf.fprintf oc "\taddi\t$s0, $a0, 0\n";
  Printf.fprintf oc "\taddi\t$a0, $gp, 0\n";
  Printf.fprintf oc "create_float_array_loop:\n";
  Printf.fprintf oc "\tbne\t$s0, $zero, create_float_array_cont\n";
  Printf.fprintf oc "\tjr\t$ra\n";
  Printf.fprintf oc "create_float_array_cont:\n";
  Printf.fprintf oc "\tswc1\t$f0, 0($gp)\n";
  Printf.fprintf oc "\taddi\t$s0, $s0, -1\n";
  Printf.fprintf oc "\taddi\t$gp, $gp, 1\n";
  Printf.fprintf oc "\tj\tcreate_float_array_loop\n";
  float_data := data;
  List.iter (fun fundef -> h oc fundef) fundefs;
  Printf.fprintf oc "_min_caml_start:\n";
  (* Printf.fprintf oc "\tlui\t$sp, 1\n";
  Printf.fprintf oc "\tlui\t$gp, 3\n"; *)
  Printf.fprintf oc "\taddi\t$sp, $sp, 600\n";
  Printf.fprintf oc "\taddi\t$gp, $gp, 3000\n";

  stackset := S.empty;
  stackmap := [];
  g oc (NonTail("$zero"), e);
  Printf.fprintf oc "last:\n";
  Printf.fprintf oc "\tj\tlast"

