type t = (* MinCaml�ι�ʸ��ɽ������ǡ����� (caml2html: syntax_t) *)
  | Unit
  | Bool of bool
  | Int of int
  | Float of float
  | Not of t
  | Neg of t
  | Add of t * t
  | Sub of t * t
  | Mult of t * t
  | Div of t * t
  | FNeg of t
  | FAdd of t * t
  | FSub of t * t
  | FMul of t * t
  | FDiv of t * t
  | Eq of t * t
  | LE of t * t
  | If of t * t * t
  | Let of (Id.t * Type.t) * t * t
  | Var of Id.t
  | LetRec of fundef * t
  | App of t * t list
  | Tuple of t list
  | LetTuple of (Id.t * Type.t) list * t * t    (* let (a1, a2) = (3, 5) in a1 + a2;; *)
  | Array of t * t     (* Array.make 3 4         [|4 ;4; 4|] *)
  | Get of t * t       (* l = [|4 ;4; 4|]     l.(1)    *)
  | Put of t * t * t   (* l.(2) <- 3      [|4; 4; 3] *)
and fundef = { name : Id.t * Type.t; args : (Id.t * Type.t) list; body : t }
