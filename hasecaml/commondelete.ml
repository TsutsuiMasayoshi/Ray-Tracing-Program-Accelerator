open KNormal

let l = ref []

let rec f e = match e with
  | Neg _ | Add (_, _) | Sub (_, _) | Mult (_, _) | Div (_, _) | FNeg _ | FAdd (_, _) | FSub (_, _) | FMul (_, _) | FDiv (_, _) | Var _ | Tuple _
    -> (try List.assoc e !l with Not_found -> e)
  | IfEq (i1, i2, e1, e2) -> IfEq (i1, i2, (f e1), (f e2))
  | IfLE (i1, i2, e1, e2) -> IfLE (i1, i2, (f e1), (f e2))
  | Let ((i1, t1), e1, e2) -> let f1 = f e1 in l := (f1, (Var i1))::(!l); Let ((i1, t1), f1, (f e2)) 
  | LetRec({ name = (x, t); args = yts; body = e1 }, e2) -> LetRec ({ name = (x, t); args = yts; body = (f e1) }, (f e2))
  | LetTuple (l1, i1, e1) -> LetTuple (l1, i1, (f e1))
  | _ -> e

  (* 2210299189 *)
  (* type t = (* K正規化後の式 (caml2html: knormal_t) *)
  | Unit
  | Int of int
  | Float of float
  | Neg of Id.t
  | Add of Id.t * Id.t
  | Sub of Id.t * Id.t
  | Mult of Id.t * Id.t
  | Div of Id.t * Id.t
  | FNeg of Id.t
  | FAdd of Id.t * Id.t
  | FSub of Id.t * Id.t
  | FMul of Id.t * Id.t
  | FDiv of Id.t * Id.t
  | IfEq of Id.t * Id.t * t * t (* 比較 + 分岐 (caml2html: knormal_branch) *)
  | IfLE of Id.t * Id.t * t * t (* 比較 + 分岐 *)
  | Let of (Id.t * Type.t) * t * t
  | Var of Id.t
  | LetRec of fundef * t
  | App of Id.t * Id.t list
  | Tuple of Id.t list
  | LetTuple of (Id.t * Type.t) list * Id.t * t
  | Get of Id.t * Id.t
  | Put of Id.t * Id.t * Id.t
  | ExtArray of Id.t
  | ExtFunApp of Id.t * Id.t list
  | GlobalTuple of Id.t list   (* knormalで特に仕事はないが、最適化しないでね程度　*)
  | GlobalArray of int * Id.t *)