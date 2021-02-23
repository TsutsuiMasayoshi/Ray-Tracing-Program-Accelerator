(*抽象構文をdebug.txtに出力する関数*)

open Syntax
open Id


let ok = Printf.printf("OK\n")

let rec out_parser_arg oc e =
  match e with
    |[] -> Printf.fprintf oc ("")
    |(i1, _)::rest -> Printf.fprintf oc ("%s ") i1; out_parser_arg oc rest

let rec out_parser_tuple oc t1 = match t1 with
  | [] -> Printf.fprintf oc ("");
  | e1::rest -> out_parser oc e1; out_parser_tuple oc rest;
  and
  out_parser oc exp = match exp with
  | Unit ->  Printf.fprintf oc ("(UNIT"); Printf.fprintf oc (")")
  | Bool x ->  Printf.fprintf oc ("(BOOL %B") x; Printf.fprintf oc (")")
  | Int x ->  Printf.fprintf oc ("(INT %d") x; Printf.fprintf oc (")")
  | Float x ->  Printf.fprintf oc ("(FLOAT %f") x; Printf.fprintf oc (")")
  | Not e1 ->  Printf.fprintf oc ("(NOT "); out_parser oc e1 ; Printf.fprintf oc (")")
  | Neg e1 ->  Printf.fprintf oc ("(NEG "); out_parser oc e1; Printf.fprintf oc (")")
  | Add (e1, e2) ->  Printf.fprintf oc ("(ADD "); out_parser oc e1; out_parser oc e2; Printf.fprintf oc (")")
  | Sub (e1, e2) ->  Printf.fprintf oc ("(SUB "); out_parser oc e1; out_parser oc e2; Printf.fprintf oc (")")
  | Mult (e1, e2) ->  Printf.fprintf oc ("(Mult "); out_parser oc e1; out_parser oc e2; Printf.fprintf oc (")")
  | Div (e1, e2) ->  Printf.fprintf oc ("(Div "); out_parser oc e1; out_parser oc e2; Printf.fprintf oc (")")
  | FNeg e1 ->  Printf.fprintf oc ("(FNEG "); out_parser oc e1; Printf.fprintf oc (")")
  | FAdd (e1, e2) ->  Printf.fprintf oc ("(FADD "); out_parser oc e1; out_parser oc e2; Printf.fprintf oc (")")
  | FSub (e1, e2) ->  Printf.fprintf oc ("(FSUB "); out_parser oc e1; out_parser oc e2; Printf.fprintf oc (")")
  | FMul (e1, e2) ->  Printf.fprintf oc ("(FMUL "); out_parser oc e1; out_parser oc e2; Printf.fprintf oc (")")
  | FDiv (e1, e2) ->  Printf.fprintf oc ("(FDIV "); out_parser oc e1; out_parser oc e2; Printf.fprintf oc (")")
  | Eq (e1, e2) ->  Printf.fprintf oc ("(EQ "); out_parser oc e1; out_parser oc e2; Printf.fprintf oc (")")
  | LE (e1, e2) ->  Printf.fprintf oc ("(LE "); out_parser oc e1; out_parser oc e2; Printf.fprintf oc (")")
  | If (e1, e2, e3) ->  Printf.fprintf oc ("(IF "); out_parser oc e1; out_parser oc e2; out_parser oc e3; Printf.fprintf oc (")")
  | Let ((i1, t1), e1, e2) ->  Printf.fprintf oc ("(LET "); Printf.fprintf oc ( "%s ") i1; out_parser oc e1; out_parser oc e2; Printf.fprintf oc (")")
  | Var e1 ->  Printf.fprintf oc ("(VAR %s") e1; Printf.fprintf oc (")")
  | LetRec (f1, e1) ->  Printf.fprintf oc ("(LETREC "); out_parser_fundef oc f1; out_parser oc e1;  Printf.fprintf oc (")")
  | App (e1, l1) ->  Printf.fprintf oc ("(APP "); out_parser oc e1; out_parser_tuple oc l1; Printf.fprintf oc (")")
  | Tuple l1 ->  Printf.fprintf oc ("(TUPLE "); out_parser_tuple oc l1; Printf.fprintf oc (")")
  | LetTuple (l1 , e1 , e2) -> Printf.fprintf oc ("(LETTUPLE TUPLE( "); out_parser_arg oc l1; Printf.fprintf oc (") "); out_parser oc e1; out_parser oc e2;
  | Array (e1, e2) ->  Printf.fprintf oc ("(ARRAY_MAKE "); out_parser oc e1; out_parser oc e2; Printf.fprintf oc (")")
  | Get (e1, e2) ->  Printf.fprintf oc ("(GET "); out_parser oc e1; out_parser oc e2; Printf.fprintf oc (")")
  | Put (e1, e2, e3) ->  Printf.fprintf oc ("(PUT "); out_parser oc e1; out_parser oc e2; out_parser oc e3 ; Printf.fprintf oc (")")
  and out_parser_fundef oc f1 = 
  let (i1, t1) = f1.name in
  let k = f1.args in
  let e = f1.body in
  Printf.fprintf oc ("%s ") i1; out_parser_arg oc k; out_parser oc e


(*Knormalをdebug.txtに出力する関数*)
open KNormal

let rec out_knormal_arg oc e =
  match e with
    |[] -> Printf.fprintf oc ("")
    |(i1, _)::rest -> Printf.fprintf oc ("%s ") i1; out_knormal_arg oc rest

let rec out_knormal oc exp = match exp with
  | Unit ->  Printf.fprintf oc ("(UNIT"); Printf.fprintf oc (")")
  | Int x ->  Printf.fprintf oc ("(INT %d") x; Printf.fprintf oc (")")
  | Float x ->  Printf.fprintf oc ("(FLOAT %f") x; Printf.fprintf oc (")")
  | Neg e1 ->  Printf.fprintf oc ("(NEG %s)") e1
  | Add (e1, e2) ->  Printf.fprintf oc ("(ADD %s %s)") e1 e2
  | Sub (e1, e2) ->  Printf.fprintf oc ("(SUB %s %s)") e1 e2
  | Mult (e1, e2) ->  Printf.fprintf oc ("(MULT %s %s)") e1 e2
  | Div (e1, e2) ->  Printf.fprintf oc ("(DIV %s %s)") e1 e2
  | FNeg e1 ->  Printf.fprintf oc ("(FNEG %s)") e1 
  | FAdd (e1, e2) ->  Printf.fprintf oc ("(FADD %s %s)") e1 e2
  | FSub (e1, e2) ->  Printf.fprintf oc ("(FSUB %s %s)") e1 e2
  | FMul (e1, e2) ->  Printf.fprintf oc ("(FMUL %s %s)") e1 e2;
  | FDiv (e1, e2) ->  Printf.fprintf oc ("(FDIV %s %s)") e1 e2;
  | IfEq (s1, s2, e1, e2) -> Printf.fprintf oc ("(IFEQ %s %s") s1 s2; out_knormal oc e1; out_knormal oc e2
  | IfLE (s1, s2, e1, e2) -> Printf.fprintf oc ("(IFLE %s %s") s1 s2; out_knormal oc e1; out_knormal oc e2
  | Let ((i1, t1), e1, e2) ->  Printf.fprintf oc ("(LET %s ") i1; out_knormal oc e1; out_knormal oc e2; Printf.fprintf oc (")")
  | Var e1 ->  Printf.fprintf oc ("(VAR %s)") e1;
  | LetRec (f1, e1) ->  Printf.fprintf oc ("(LETREC "); out_knormal_fundef oc f1; out_knormal oc e1;  Printf.fprintf oc (")") 
  | App (e1, l1) ->  Printf.fprintf oc ("(APP %s)") e1;  out_knormal_tuple oc l1; Printf.fprintf oc (")")
  | Tuple l1 ->  Printf.fprintf oc ("(TUPLE "); out_knormal_tuple oc l1; Printf.fprintf oc (")")
  | LetTuple (l1 , e1 , e2) -> Printf.fprintf oc ("(LETTUPLE TUPLE( "); out_knormal_arg oc l1; Printf.fprintf oc (") %s ") e1; out_knormal oc e2;
  | Get (e1, e2) ->  Printf.fprintf oc ("(GET %s %s)") e1 e2
  | Put (e1, e2, e3) ->  Printf.fprintf oc ("(PUT %s %s)") e1 e2
  | ExtArray e1 -> Printf.fprintf oc ("(EXTARRAY %s)") e1
  | ExtFunApp (e1, l1) -> Printf.fprintf oc ("(EXTFUNAPP %s ") e1; out_knormal_tuple oc l1; Printf.fprintf oc (")")
  | GlobalTuple l1 ->  Printf.fprintf oc ("(GlobalTUPLE "); out_knormal_tuple oc l1; Printf.fprintf oc (")")
  | GlobalArray (a, b) ->  Printf.fprintf oc ("(GlobalArray %d %s") a b;
  and out_knormal_tuple oc t1 = match t1 with
  | [] -> Printf.fprintf oc ("");
  | e1::rest -> Printf.fprintf oc ("%s") e1; out_knormal_tuple oc rest;
  and  out_knormal_fundef oc f1 = 
  let (i1, t1) = f1.name in
  let k = f1.args in
  let e = f1.body in
  Printf.fprintf oc ("%s ") i1; out_knormal_arg oc k; out_knormal oc e

  (* クロージャー変換後も出力
  ちな、Letrec周りしか変わらないっすねー *)

  (* type closure = { entry : Id.l; actual_fv : Id.t list }
  type t = (* クロージャ変換後の式 (caml2html: closure_t) *)
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
    | ExtArray of Id.l *)
open Closure
let out_id_l oc l1 = 
  let (L (s)) = l1 in
  Printf.fprintf oc ("%s ") s

let rec out_closure_tuple oc t1 = match t1 with
| [] -> Printf.fprintf oc ("");
| e1::rest -> Printf.fprintf oc ("%s") e1; out_closure_tuple oc rest

let rec out_closure_arg oc e =
  match e with
    |[] -> Printf.fprintf oc ("")
    |(i1, _)::rest -> Printf.fprintf oc ("%s ") i1; out_closure_arg oc rest 

    (* type closure = { entry : Id.l; actual_fv : Id.t list } *)
let out_the_closure oc c1 =  (* まさにクロージャーを出力 *)
  let i1 = c1.entry in
  let afv = c1.actual_fv in
  Printf.fprintf oc ("{entry: "); out_id_l oc i1; Printf.fprintf oc (" actual_fv "); out_closure_tuple oc afv; Printf.fprintf oc ("} ")

let rec out_closure1 oc exp = match exp with
    | Unit ->  Printf.fprintf oc ("(UNIT)")
    | Int x ->  Printf.fprintf oc ("(INT %d)") x 
    | Float x ->  Printf.fprintf oc ("(FLOAT %f)") x
    | Neg e1 ->  Printf.fprintf oc ("(NEG %s)") e1 
    | Add (e1, e2) ->  Printf.fprintf oc ("(ADD %s %s)") e1 e2 
    | Sub (e1, e2) ->  Printf.fprintf oc ("(SUB %s %s)") e1 e2 
    | Mult (e1, e2) ->  Printf.fprintf oc ("(MULT %s %s)") e1 e2 
    | Div (e1, e2) ->  Printf.fprintf oc ("(DIV %s %s)") e1 e2 
    | FNeg e1 ->  Printf.fprintf oc ("(FNEG %s)") e1 
    | FAdd (e1, e2) ->  Printf.fprintf oc ("(FADD %s %s)") e1 e2 
    | FSub (e1, e2) ->  Printf.fprintf oc ("(FSUB %s %s)") e1 e2 
    | FMul (e1, e2) ->  Printf.fprintf oc ("(FMUL %s %s)") e1 e2 
    | FDiv (e1, e2) ->  Printf.fprintf oc ("(FDIV %s %s)") e1 e2 
    | IfEq (s1, s2, e1, e2) -> Printf.fprintf oc ("(IFEQ %s %s") s1 s2; out_closure1 oc e1; out_closure1 oc e2 
    | IfLT (s1, s2, e1, e2) -> Printf.fprintf oc ("(IFLT %s %s") s1 s2; out_closure1 oc e1; out_closure1 oc e2 
    | Let ((i1, t1), e1, e2) ->  Printf.fprintf oc ("(LET %s ") i1; out_closure1 oc e1; Printf.fprintf oc ("\n"); out_closure1 oc e2
    | Var e1 ->  Printf.fprintf oc ("(VAR %s)") e1
    | MakeCls ((i1, t1), c1, e1) -> Printf.fprintf oc ("(MakeCls %s ") i1; out_the_closure oc c1; out_closure1 oc e1
    | AppCls (i1, l1) -> Printf.fprintf oc ("(AppCls %s ") i1; out_closure_tuple oc l1; Printf.fprintf oc (")")
    | AppDir (i1, l1) -> Printf.fprintf oc ("(AppDir "); out_id_l oc i1; out_closure_tuple oc l1; Printf.fprintf oc (")")
    | Tuple l1 ->  Printf.fprintf oc ("(TUPLE "); out_closure_tuple oc l1;  Printf.fprintf oc (")")
    | LetTuple (l1 , e1 , e2) -> Printf.fprintf oc ("(LETTUPLE TUPLE( "); out_closure_arg oc l1; Printf.fprintf oc (") %s)\n") e1; out_closure1 oc e2
    | Get (e1, e2) ->  Printf.fprintf oc ("(GET %s %s)") e1 e2
    | Put (e1, e2, e3) ->  Printf.fprintf oc ("(PUT %s %s)") e1 e2
    | ExtArray i1 -> Printf.fprintf oc ("(EXTARRAY "); out_id_l oc i1
    | GlobalTuple l1 ->  Printf.fprintf oc ("(GlobalTUPLE "); out_closure_tuple oc l1; Printf.fprintf oc (")")
    | GlobalArray (a, b) ->  Printf.fprintf oc ("(GlobalArray %d %s") a b
    

let out_closure_fundef oc f1 = 
  let (i1, t1) = f1.name in
  let k = f1.args in
  let fv1 = f1.formal_fv in
  let e = f1.body in
  out_id_l oc i1; Printf.fprintf oc (" args: "); out_closure_arg oc k; Printf.fprintf oc (" fv: "); out_closure_arg oc fv1; Printf.fprintf oc (" body: ");  out_closure1 oc e
    (* type fundef = { name : Id.l * Type.t;
    args : (Id.t * Type.t) list;
    formal_fv : (Id.t * Type.t) list;
    body : t } *)

let rec out_closure_fundef_lis oc = function
    | [] -> ()
    | f1::rest -> out_closure_fundef oc f1; Printf.fprintf oc ("\n"); out_closure_fundef_lis oc rest

let out_closure oc  = function
  | Prog (fl, e, _) -> out_closure_fundef_lis oc fl; Printf.fprintf oc ("\n"); out_closure1 oc e

(* 
let rec out_asm oc = function
  Prog (_, fl, e, _) -> out_asm_fundef_lis oc fl; print_string ("\n"); oct_asm oc e *)