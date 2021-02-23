open Asm

let globals2 : (Type.t * int) M.t ref = ref M.empty

let rec g env = function (* ̿�����16bit¨�ͺ�Ŭ�� (caml2html: simm13_g) *)
  | Ans(exp) -> Ans(g' env exp)
  | Let((x, t), Li(i), e) when -32768 <= i && i < 32768 ->
      (* Format.eprintf "found simm16 %s = %d@." x i; *)
      let e' = g (M.add x i env) e in
      if List.mem x (fv e') then Let((x, t), Li(i), e') else
      ((* Format.eprintf "erased redundant Set to %s@." x; *)
       e')
  | Let(xt, Slw(y, C(i)), e) when M.mem y env -> (* for array access *)
      (* Format.eprintf "erased redundant Slw on %s@." x; *)
      g env (Let(xt, Li((M.find y env) lsl i), e))
  | Let(xt, exp, e) -> Let(xt, g' env exp, g env e)
and g' env = function (* ��̿���16bit¨�ͺ�Ŭ�� (caml2html: simm13_gprime) *)
  | Add(x, V(y)) when M.mem y env -> Add(x, C(M.find y env))
  | Add(x, V(y)) when M.mem x env -> Add(y, C(M.find x env))
  | Sub(x, V(y)) when M.mem y env -> Sub(x, C(M.find y env))
  | Slw(x, V(y)) when M.mem y env -> Slw(x, C(M.find y env))
  | Lwz(x, V(y)) when ((M.mem y env) && (M.mem x !globals2)) -> 
    let (_, addr) = M.find x !globals2 in Lwc(addr + (M.find y env))
  | Lwz(x, V(y)) when M.mem y env -> Lwz(x, C(M.find y env))
  | Stw(x, y, V(z)) when M.mem z env -> Stw(x, y, C(M.find z env))
  | Stw(x, y, V(z)) when ((M.mem z env) && (M.mem y !globals2)) -> 
    let (_, addr) = M.find y !globals2 in Swc(x, addr + (M.find z env))
  | Lfd(x, V(y)) when ((M.mem y env) && (M.mem x !globals2)) -> 
    let (_, addr) = M.find x !globals2 in Lwfc(addr + (M.find y env))
  | Lfd(x, V(y)) when M.mem y env -> Lfd(x, C(M.find y env))
  | Stfd(x, y, V(z)) when ((M.mem z env) && (M.mem y !globals2)) -> 
    let (_, addr) = M.find y !globals2 in Swfc(x, addr + (M.find z env))
  | Stfd(x, y, V(z)) when M.mem z env -> Stfd(x, y, C(M.find z env))
  | IfEq(x, V(y), e1, e2) when M.mem y env -> IfEq(x, C(M.find y env), g env e1, g env e2)
  | IfLT(x, V(y), e1, e2) when M.mem y env -> IfLT(x, C(M.find y env), g env e1, g env e2)
  (* | IfLT(x, V(y), e1, e2) when M.mem x env -> IfLT2(M.find x env, y, g env e1, g env e2) *)
  (* | IfGE(x, V(y), e1, e2) when M.mem y env -> IfGE(x, C(M.find y env), g env e1, g env e2) *)
  | IfEq(x, V(y), e1, e2) when M.mem x env -> IfEq(y, C(M.find x env), g env e1, g env e2)
  (* | IfLT(x, V(y), e1, e2) when M.mem x env -> IfLT(y, C(M.find x env), g env e1, g env e2) *)
  (* | IfGE(x, V(y), e1, e2) when M.mem x env -> IfLE(y, C(M.find x env), g env e1, g env e2) *)
  | IfEq(x, y', e1, e2) -> IfEq(x, y', g env e1, g env e2)
  | IfLT(x, y', e1, e2) -> IfLT(x, y', g env e1, g env e2)  
  (* | IfGE(x, y', e1, e2) -> IfLT(x, y', g env e2, g env e1)    *)
  | IfFEq(x, y, e1, e2) -> IfFEq(x, y, g env e1, g env e2)
  | IfFLT(x, y, e1, e2) -> IfFLT(x, y, g env e1, g env e2)
  | e -> e

let h { name = l; args = xs; fargs = ys; body = e; ret = t } = (* �ȥåץ�٥�ؿ���16bit¨�ͺ�Ŭ�� *)
  { name = l; args = xs; fargs = ys; body = g M.empty e; ret = t }

let f (Prog(data, fundefs, e, globals)) = (* �ץ���������Τ�16bit¨�ͺ�Ŭ�� *)
  globals2 := globals;
  Prog(data, List.map h fundefs, g M.empty e, M.empty)
