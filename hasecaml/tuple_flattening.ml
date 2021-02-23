open Closure
open Id

exception Myerror1
exception Myerror2
exception Myerror3
exception Myerror4
(* type t = (* クロージャ変換後の式 (caml2html: closure_t) *)
  | Unit
  | Int of int
  | Float of float
  | Neg of Id.t
  | Add of Id.t * Id.t
  | Sub of Id.t * Id.t
  | FNeg of Id.t
  | FAdd of Id.t * Id.t
  | FSub of Id.t * Id.t
  | FMul of Id.t * Id.t
  | FDiv of Id.t * Id.t
  | IfEq of Id.t * Id.t * t * t
  | IfLE of Id.t * Id.t * t * t
  | Let of (Id.t * Type.t) * t * t
  | Var of Id.t
  | MakeCls of (Id.t * Type.t) * closure * t
  | AppCls of Id.t * Id.t list
  | AppDir of Id.l * Id.t list
  | Tuple of Id.t list
  | LetTuple of (Id.t * Type.t) list * Id.t * t
  | Get of Id.t * Id.t
  | Put of Id.t * Id.t * Id.t
  | ExtArray of Id.l
type fundef = { name : Id.l * Type.t;
                args : (Id.t * Type.t) list;
                formal_fv : (Id.t * Type.t) list;
                body : t }
type prog = Prog of fundef list * t *)

(* 注 tuple 同士が等しいという意味で＝を使えない*)
(* let tenv = [("x", ["x1"; "x2"]); ("y", ["y1"; "y2"; "y3"]); ("start", ["x"; "y"])] *)

let rec flatten_tuple tenv t1 = match t1 with
  | [] -> []
  | i1::rest -> (flatten_id tenv i1)@(flatten_tuple tenv rest)
and flatten_id tenv i1 =
  (try let t1 = List.assoc i1 tenv in
    flatten_tuple tenv t1
  with _ -> [i1])


(* Lettuple (l1, i1, e)　において　i1が平坦化されているとまずい。
  i1を定義するlet文においてi1を展開する前の形のタプルを覚えておく必要がある。
  なお、前に定義されているはずである　let i1 = e1 in e2 のところで　結果として　e1　が tupleになるパターンはClosure.t において　Tuple,IF文、Let文 , などしかない 
  上、　結局TupleとIf文,Let文しかない。

  つまり、e1が Tuple文 の時は l1 = [a1, a2, ...an], に対し e1 = [b1, b2,,,,bn]となっているはずなので
    Lettuple (l1, i1, e)は
    Let ((a1, ty_a1), (Var b1), (Let ((a2, ty_a2), (Var b2),,,,,,,,,,)というふうにすればよく
  e1がIf文の の場合は 再帰が終わるとき、
  l1 = [a1, a2, ...an], に対し e1 = if q then [b1, b2,,,,bn] else [c1, c2,,,,,cn]となっているはずなので　
    Lettuple (l1, i1, e)は
    If q then Let ((a1, ty_a1), (Var b1), (Let ((a2, ty_a2), (Var b2),,,,,,,,,,) else Let ((a1, ty_a1), (Var c1), (Let ((a2, ty_a2), (Var c2),,,,,,,,,,)
  とすれば良い
   *)

(* is_tuple　を満たすものは以下の　tuple_type　と表せる。 

type tuple_type = type1 | type2 | type2
and
type type1 = Tuple of Id.t list
and
type type2 = IfEq of (Id.t, Id.t, Main_type, Main_type) | IfLE of (Id.t, Id.t, Main_type, Main_type)
and type3 = Let ...., LetTuple... 
and type4 = Appd
*)

let rec is_tuple exp = match exp with
  | Tuple _ -> true
  | IfEq (_, _, e1, e2) -> is_tuple e1
  | IfLT (_, _, e1, e2) -> is_tuple e1
  | Let ((i1, ty1), e1, e2) -> is_tuple e2
  | LetTuple (l1, i1, e1) -> is_tuple e1                        (* if のなかでletがあることがある。*)
  | _ ->  false

let rec sub_open_tuple l1 t1 e = match l1 with
  | [] -> e
  | (a1, ty1)::resta -> let b1::restb = t1 in Let ((a1, ty1), Var b1, sub_open_tuple resta restb e) 
  | _ -> raise Myerror1


(* 展開しかしない.        元はLettuple (x1, x2,,,) = (y1, y2,,,) in e *)
let rec open_LetTuple l1 tu1 e = match tu1 with
  | Tuple t1 -> sub_open_tuple l1 t1 e
  | IfEq (i1, i2, e1, e2) -> IfEq (i1, i2, (open_LetTuple l1 e1 e), (open_LetTuple l1 e2 e))
  | IfLT (i1, i2, e1, e2) -> IfLT (i1, i2, (open_LetTuple l1 e1 e), (open_LetTuple l1 e2 e))
  | Let ((i1, ty1), e1, e2) -> Let ((i1, ty1), e1, open_LetTuple l1 e2 e)
  | _ -> tu1   (* 関数の返り値などに対してはやらない *)
  
(* type Closure.tに対してtuple平坦化 *)
(* tenv1 .... (Id.t, Id.t list) list      タプルの平坦化に使う
   tenv2 .... (Id.t, tuple_type) list  　　タプルの展開に使う
   *)
let rec assoc i tenv2 = match tenv2 with
  | (i,e)::_ -> e
  | _::rest -> assoc i rest
  | _ -> raise Myerror3
  
let rec g tenv1 tenv2 exp = match exp with
  | IfEq (i1, i2, e1, e2) -> IfEq (i1, i2, (g tenv1 tenv2 e1), (g tenv1 tenv2 e2))
  | IfLT (i1, i2, e1, e2) -> IfLT (i1, i2, (g tenv1 tenv2 e1), (g tenv1 tenv2 e2))
  | Let ((i1, ty1), e1, e2) ->
    (match e1 with
      | Tuple t1 ->
        let tenv1' = (i1, (flatten_tuple tenv1 t1))::tenv1 in
        let tenv2' = if (is_tuple e1) then (i1, e1)::tenv2 else tenv2 in
          Let ((i1, ty1), Tuple(flatten_tuple tenv1 t1), g tenv1' tenv2' e2)
      | _ ->
        let tenv2' = if (is_tuple e1) then (i1, e1)::tenv2 else tenv2 in
          Let ((i1, ty1), e1, (g tenv1 tenv2' e2)))
  | Tuple t1 -> Tuple (flatten_tuple tenv1 t1)
  | LetTuple (l1, i1, e1) -> open_LetTuple l1 (assoc i1 tenv2) e1
  | _ -> exp


(* let rec renewal_arg i1 argl = match argl with
  | (i1, ty1) :: rest -> (Id.ge) *)

(* let rec h fund = 
  let arglis = fund.args in
  let exp = fund.body in *)
  


let rec f prog = match prog with
  | Prog (fl, t) -> Prog (fl,  g [] [] t)
