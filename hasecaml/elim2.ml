open Asm

(* type id_or_imm = V of Id.t | C of int
type t = (* 命令の列 (caml2html: sparcasm_t) *)
  | Ans of exp
  | Let of (Id.t * Type.t) * exp * t
and exp = (* 一つ一つの命令に対応する式 (caml2html: sparcasm_exp) *)
  | Nop
  | Li of int
  | FLi of (* Id.t *) float
  | SetL of Id.l
  | Mr of Id.t
  | Neg of Id.t
  | Add of Id.t * id_or_imm
  | Sub of Id.t * id_or_imm
  | Slw of Id.t * id_or_imm
  | Slr of Id.t * id_or_imm
  | Lwz of Id.t * id_or_imm
  | Lwc of int
  | Stw of Id.t * Id.t * id_or_imm
  | Swc of Id.t * int
  | FMr of Id.t
  | FNeg of Id.t
  | FAdd of Id.t * Id.t
  | FSub of Id.t * Id.t
  | FMul of Id.t * Id.t
  | FDiv of Id.t * Id.t
  | Lfd of Id.t * id_or_imm
  | Stfd of Id.t * Id.t * id_or_imm
  | Stfdz of Id.t * id_or_imm
  | Lwfc of int
  | Swfc of Id.t * int
  | Swfcz of int
  | Comment of string
  | IfEq of Id.t * id_or_imm * t * t
  | IfLT of Id.t * id_or_imm * t * t
  | IfFEq of Id.t * Id.t * t * t
  | IfFEqz of Id.t * t * t
  | IfFLT of Id.t * Id.t * t * t
  | IfFLTz of Id.t * t * t
  | IfFGTz of Id.t * t * t
  | CallDir of Id.l * Id.t list * Id.t list
  | Save of Id.t * Id.t (* レジスタ変数の値をスタック変数へ保存 (caml2html: sparcasm_save) *)
  | Restore of Id.t スタック変数から値を復元 (caml2html: sparcasm_restore) *)

let rec effect = function (* 副作用の有無 (caml2html: elim_effect) *)
  | Ans(exp) -> effect2 exp
  | Let(_, exp, t) -> effect2 exp || effect t
and effect2 = function
  | IfEq(_, _, e1, e2) | IfLT(_, _, e1, e2) | IfFEq(_, _, e1, e2) | IfFLT(_, _, e1, e2) | IfFEqz(_, e1, e2) | IfFLTz(_, e1, e2)| IfFGTz(_, e1, e2) -> effect e1 || effect e2
  | Stw _ | Swc _ | Stfd _ | Stfdz _ | Swfc _ | Swfcz _ | CallDir _ | Save _   -> true
  | _ -> false

let rec g = function
  | Ans(exp) -> Ans(g2 exp)
  | Let((x, ty), exp, t) -> 
      let exp' = g2 exp in
      let t' = g t in
      if effect2 exp' || List.mem x (fv t') || is_reg x then Let((x, ty), exp', t') else
      (Format.eprintf "eliminating variable (elim2.ml) %s@." x;
       t')
and g2 = function 
  | IfEq(x, y, e1, e2) -> IfEq(x, y, g e1, g e2)
  | IfLT(x, y, e1, e2) -> IfLT(x, y, g e1, g e2)
  | IfFEq(x, y, e1, e2) -> IfFEq(x, y, g e1, g e2)
  | IfFLT(x, y, e1, e2) -> IfFLT(x, y, g e1, g e2)
  | IfFEqz(x, e1, e2) -> IfFEqz(x, g e1, g e2)
  | IfFLTz(x, e1, e2) -> IfFLTz(x, g e1, g e2)
  | IfFGTz(x, e1, e2) -> IfFGTz(x, g e1, g e2)
  | exp -> exp

let h { name = l; args = xs; fargs = ys; body = e; ret = t } =
  { name = l; args = xs; fargs = ys; body = g e; ret = t }

let f (Prog(data, fundefs, e, _)) = 
  Prog(data, List.map h fundefs, g e, M.empty)