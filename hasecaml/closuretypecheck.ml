open Closure

let env = ref []
let fundefs1 = ref []

(* type closure = { entry : Id.l; actual_fv : Id.t list }
type t = (* クロージャ変換後の式 (caml2html: closure_t) *)
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
  | IfEq of Id.t * Id.t * t * t
  | IfLT of Id.t * Id.t * t * t
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
  | GlobalTuple of Id.t list
  | GlobalArray of int * Id.t
type fundef = { name : Id.l * Type.t;
                args : (Id.t * Type.t) list;
                formal_fv : (Id.t * Type.t) list;
                body : t }
type prog = Prog of fundef list * t * Id.t list *)

let rec add_type_list l env1 = match l with
  | [] -> env1
  | (x, t)::rest -> (x, t)::(add_type_list rest env1)

(* ハードウェア実装、またはアセンブリベタ書きのやつは個別に教える必要あり*)

let rec find_fun l label = 
  if label = Id.L("min_caml_float_of_int") then Type.Fun([Type.Int], Type.Float)
  else if label = Id.L("min_caml_create_float_array") then Type.Fun([Type.Int; Type.Float], Type.Array(Type.Float))
  else if label = Id.L("min_caml_read_float") then Type.Fun([Type.Unit], Type.Float)
  else if label = Id.L("min_caml_read_int") then Type.Fun([Type.Unit], Type.Int) 
  else if label = Id.L("min_caml_print_char") then Type.Fun([Type.Int], Type.Unit)
  else if label = Id.L("min_caml_sqrt") then Type.Fun([Type.Float], Type.Float)
  else if label = Id.L("min_caml_floor") then Type.Fun([Type.Float], Type.Float)
  else if label = Id.L("min_caml_int_of_float") then Type.Fun([Type.Float], Type.Int)
  else
  match l with
  | [] -> let Id.L(s) = label in print_string s; assert false
  | x::rest -> let (a, b) = x.name in if a = label then b else find_fun rest label

let rec g e = match e with
  | Unit -> Type.Unit
  | Int(_) -> Type.Int
  | Float(_) -> Type.Float
  | Neg(x) -> assert (List.assoc x !env = Type.Int); Type.Int
  | Add(x, y) | Sub(x, y) | Mult(x, y) | Div(x, y) -> assert (List.assoc x !env = Type.Int); assert (List.assoc y !env = Type.Int); Type.Int
  | FNeg(x) -> assert (List.assoc x !env = Type.Float); Type.Float
  | FAdd(x, y) | FSub(x, y) | FMul(x, y) | FDiv(x, y) -> assert (List.assoc x !env = Type.Float); assert (List.assoc y !env = Type.Float); Type.Float
  | IfEq(x, y, e1, e2) | IfLT(x, y, e1, e2) -> let (tx, ty) = (List.assoc x !env, List.assoc y !env) in assert (tx = ty); let (t1, t2) = (g e1, g e2) in assert (t1 = t2); t1
  | Let((x, t1), e1, e2) -> if g e1 <> t1 then (print_string (Type.str t1); print_string (Type.str (g e1)); assert (g e1 = t1)) else assert (g e1 = t1); env := (x, t1)::!env; g e2
  | Var(x) -> List.assoc x !env
  | AppDir(label, ys) -> 
    if label = Id.L("min_caml_create_array") then let [num; nakami] = ys in
      assert (List.assoc num !env = Type.Int);
      assert (List.assoc nakami !env <> Type.Float);
      Type.Array(List.assoc nakami !env)
    else
    let a = find_fun !fundefs1 label in 
    (match a with
      | Type.Fun(ts, t) -> assert (List.map (fun y -> List.assoc y !env) ys = ts); t
      | _ -> assert false
    )
  | Tuple(xs) | GlobalTuple(xs) -> Type.Tuple(List.map (fun x -> List.assoc x !env) xs)
  | LetTuple(xts, y, e1) -> 
    assert (List.assoc y !env = Type.Tuple(List.map (fun (x, t) -> t) xts));
    env := add_type_list xts !env;
    g e1
  | Get(x, y) -> 
    (match List.assoc x !env with 
      | Type.Array(t) -> assert (List.assoc y !env = Type.Int); t
      | _ -> assert false)
  | Put(x, y, z) -> 
    (match List.assoc x !env with 
      | Type.Array(t) -> assert (List.assoc y !env = Type.Int); assert (List.assoc z !env = t); Type.Unit
      | _ -> assert false)
  | GlobalArray(i, x) -> Type.Array(List.assoc x !env)
  | ExtArray(_) ->  assert false
  | MakeCls _ -> assert false
  | AppCls _ -> assert false

(* let print_label l1 = let Id.L(s) = l1 in print_string s *)

let rec h fs = match fs with
  | [] -> () 
  | f1::rest ->
   (
    env:= f1.args@(!env);
    let (a, b) = f1.name in let Type.Fun(c, d) = b in assert (g f1.body = d); h rest
   )


let f (Prog(fundefs, e, global_lis)) =
  fundefs1 := fundefs;
  g e;
  h fundefs;
  Prog(fundefs, e, global_lis)