open Asm

let rec pow x y = 
  if y = 0 then 1 else x * (pow x (y - 1))

let rec g env env2 = function
  | Ans(exp) -> g' env env2 exp
  | Let((x, t), Li(i), e) when -32768 <= i && i < 32768 ->
      let e' = g (M.add x i env) env2 e in
      if List.mem x (fv e') && not (M.mem x env && M.find x env = i) then Let((x, t), Li(i), e') else e'
  | Let((x, t), FLi(f), e) ->
      let e' = g env (M.add x f env2) e in
      if List.mem x (fv e') then Let((x, t), FLi(f), e') else e'
  | Let(xt, Slw(y, C(i)), e) when M.mem y env -> 
      g env env2 (Let(xt, Li((M.find y env) lsl i), g env env2 e))
  | Let(xt, exp, e) -> Let(xt, g2 env env2 exp, g env env2 e)
and g' env env2 = function
  | Mr(x) when M.mem x env -> Ans(Li(M.find x env))
  | Add(x, V(y)) when M.mem x env && M.mem y env -> Ans(Li((M.find x env) + (M.find y env)))
  | Add(x, V(y)) when M.mem x env -> Ans(Add(y, C(M.find x env)))
  | Add(x, C(i)) when M.mem x env -> Ans(Li((M.find x env) + i))
  | FMr(x) when M.mem x env2 -> Ans(FLi(M.find x env2))
  | FNeg(x) when M.mem x env2 -> Ans(FLi(-.M.find x env2))
  | FAdd(x, Vf(y)) when M.mem x env2 && M.mem y env2 -> Ans(FLi((M.find x env2) +. (M.find y env2)))
  | FAdd(x, Vf(y)) when M.mem y env2 -> Ans(FAdd(x, Cf(M.find y env2)))
  | FAdd(x, Vf(y)) when M.mem x env2 -> Ans(FAdd(y, Cf(M.find x env2)))
  | FSub(x, Vf(y)) when M.mem x env2 && M.mem y env2 -> Ans(FLi((M.find x env2) -. (M.find y env2)))
  | FSub(x, Vf(y)) when M.mem x env2 && M.find x env2 = 0. -> Ans(FNeg(y))
  | FSub(x, Vf(y)) when M.mem y env2 -> Ans(FSub(x, Cf(M.find y env2)))
  | FSub(x, Vf(y)) when M.mem x env2 -> Ans(FSub2(M.find x env2, y))
  | FMul(x, Vf(y)) when M.mem x env2 && M.mem y env2 -> Ans(FLi((M.find x env2) *. (M.find y env2)))
  | FMul(x, Vf(y)) when M.mem y env2 -> Ans(FMul(x, Cf(M.find y env2)))
  | FMul(x, Vf(y)) when M.mem x env2 -> Ans(FMul(y, Cf(M.find x env2)))
  | FDiv(x, Vf(y)) when M.mem x env2 && M.mem y env2 -> Ans(FLi((M.find x env2) /. (M.find y env2)))
  | FDiv(x, Vf(y)) when M.mem x env2 && M.find x env2 = 0. -> Ans(FLi(0.))
  | FDiv(x, Vf(y)) when M.mem y env2 -> Ans(FDiv(x, Cf(M.find y env2)))
  | FDiv(x, Vf(y)) when M.mem x env2 -> Ans(FDiv2(M.find x env2, y))
  | Sub(x, V(y)) when M.mem x env && M.mem y env -> Ans(Li((M.find x env) - (M.find y env)))
  | Sub(x, V(y)) when M.mem y env -> Ans(Sub(x, C(M.find y env)))
  | Sub(x, C(i)) when M.mem x env -> Ans(Li((M.find x env) - i))
  | Slw(x, V(y)) when M.mem x env && M.mem y env -> Ans(Li(((M.find x env) * (pow 2 (M.find y env)))))
  | Slw(x, C(i)) when M.mem x env -> Ans(Li(((M.find x env) * pow 2 i)))
  | Lwz(x, V(y)) when M.mem x env && M.mem y env -> Ans(Lwc((M.find x env) + (M.find y env)))
  | Lwz(x, C(i)) when M.mem x env -> Ans(Lwc((M.find x env) + i))
  | Stw(x, y, V(z)) when M.mem y env && M.mem z env -> Ans(Swc(x, (M.find y env) + (M.find z env)))
  | Stw(x, y, C(i)) when (M.mem y env) -> Ans(Swc(x, (M.find y env) + i))
  | Lfd(x, V(y)) when M.mem x env && M.mem y env -> Ans(Lwfc((M.find y env) + (M.find y env)))
  | Lfd(x, C(i)) when M.mem x env -> Ans(Lwfc((M.find x env) + i))
  | Stfd(x, y, V(z)) when M.mem y env && M.mem z env -> Ans(Swfc(x, (M.find y env) + (M.find z env)))
  | Stfd(x, y, C(i)) when (M.mem y env) -> Ans(Swfc(x, (M.find y env) + i))
  | Stfd(x, y, C(i)) when M.mem x env2 && M.find x env2 = 0. -> Ans(Stfdz(y, C(i)))
  | Stfd(x, y, V(z)) when M.mem x env2 && M.find x env2 = 0. -> Ans(Stfdz(y, V(z)))
  | Swfc(x, i) when M.mem x env2 && M.find x env2 = 0. -> Ans(Swfcz(i))
  | IfEq(x, V(y), e1, e2) when M.mem x env && M.mem y env -> if M.find x env = M.find y env then g env env2 e1 else g env env2 e2
  | IfEq(x, V(y), e1, e2) when M.mem x env -> Ans(IfEq(y, C(M.find x env), g env env2 e1, g env env2 e2))
  | IfEq(x, C(i), e1, e2) when M.mem x env -> if M.find x env = i then g (M.add x i env) env2 e1 else g env env2 e2
  | IfEq(x, C(i), e1, e2)  -> Ans(IfEq(x, C(i), g (M.add x i env) env2 e1, g env env2 e2))
  | IfLT(x, V(y), e1, e2) when M.mem x env && M.mem y env -> if M.find x env < M.find y env then g env env2 e1 else g env env2 e2
  | IfLT(x, V(y), e1, e2) when M.mem x env && M.mem y env -> if M.find x env < M.find y env then g env env2 e1 else g env env2 e2
  | IfFEq(x, y, e1, e2) when M.mem x env2 && M.mem y env2 -> if M.find x env2 = M.find y env2 then g env env2 e1 else g env env2 e2
  | IfFLT(x, y, e1, e2) when M.mem x env2 && M.mem y env2 -> if M.find x env2 < M.find y env2 then g env env2 e1 else g env env2 e2
  | IfFEq(x, y, e1, e2) when M.mem y env2 && M.find y env2 = 0. -> Ans(IfFEqz(x, g env env2 e1, g env env2 e2))
  | IfFLT(x, y, e1, e2) when M.mem y env2 && M.find y env2 = 0. -> Ans(IfFLTz(x, g env env2 e1, g env env2 e2))
  | IfFLT(x, y, e1, e2) when M.mem x env2 && M.find x env2 = 0. -> Ans(IfFGTz(y, g env env2 e1, g env env2 e2))
  | IfFLT(x, y, e1, e2) when M.mem x env2  -> Ans(IfFLTi1(M.find x env2, y, g env env2 e1, g env env2 e2))
  | IfFLT(x, y, e1, e2) when M.mem y env2  -> Ans(IfFLTi2(x, M.find y env2, g env env2 e1, g env env2 e2)) 
  | IfEq(x, y', e1, e2) -> Ans(IfEq(x, y', g env env2 e1, g env env2 e2))
  | IfLT(x, y', e1, e2) -> Ans(IfLT(x, y', g env env2 e1, g env env2 e2)) 
  | IfFEq(x, y, e1, e2) -> Ans(IfFEq(x, y, g env env2 e1, g env env2 e2))
  | IfFLT(x, y, e1, e2) -> Ans(IfFLT(x, y, g env env2 e1, g env env2 e2))
  | IfLT2(i, y, e1, e2) -> Ans(IfLT2(i, y, g env env2 e1, g env env2 e2))
  | e -> Ans(e)
and g2 env env2 = function
  | Mr(x) when M.mem x env -> (Li(M.find x env))
  | Add(x, V(y)) when M.mem x env && M.mem y env -> (Li((M.find x env) + (M.find y env)))
  | Add(x, V(y)) when M.mem x env -> (Add(y, C(M.find x env)))
  | Add(x, C(i)) when M.mem x env -> (Li((M.find x env) + i))
  | FMr(x) when M.mem x env2 -> (FLi(M.find x env2))
  | FNeg(x) when M.mem x env2 -> (FLi(-.M.find x env2))
  | FAdd(x, Vf(y)) when M.mem x env2 && M.mem y env2 -> (FLi((M.find x env2) +. (M.find y env2)))
  | FAdd(x, Vf(y)) when M.mem y env2 -> (FAdd(x, Cf(M.find y env2)))
  | FAdd(x, Vf(y)) when M.mem x env2 -> (FAdd(y, Cf(M.find x env2)))
  | FSub(x, Vf(y)) when M.mem x env2 && M.mem y env2 -> (FLi((M.find x env2) -. (M.find y env2)))
  | FSub(x, Vf(y)) when M.mem x env2 && M.find x env2 = 0. -> (FNeg(y))
  | FSub(x, Vf(y)) when M.mem y env2 -> (FSub(x, Cf(M.find y env2)))
  | FSub(x, Vf(y)) when M.mem x env2 -> (FSub2(M.find x env2, y))
  | FMul(x, Vf(y)) when M.mem x env2 && M.mem y env2 -> (FLi((M.find x env2) *. (M.find y env2)))
  | FMul(x, Vf(y)) when M.mem y env2 -> (FMul(x, Cf(M.find y env2)))
  | FMul(x, Vf(y)) when M.mem x env2 -> (FMul(y, Cf(M.find x env2)))
  | FDiv(x, Vf(y)) when M.mem x env2 && M.mem y env2 -> (FLi((M.find x env2) /. (M.find y env2)))
  | FDiv(x, Vf(y)) when M.mem x env2 && M.find x env2 = 0. -> (FLi(0.))
  | FDiv(x, Vf(y)) when M.mem y env2 -> (FDiv(x, Cf(M.find y env2)))
  | FDiv(x, Vf(y)) when M.mem x env2 -> (FDiv2(M.find x env2, y))
  | Sub(x, V(y)) when M.mem x env && M.mem y env -> (Li((M.find x env) - (M.find y env)))
  | Sub(x, V(y)) when M.mem y env -> (Sub(x, C(M.find y env)))
  | Sub(x, C(i)) when M.mem x env -> (Li((M.find x env) - i))
  | Slw(x, V(y)) when M.mem x env && M.mem y env -> (Li(((M.find x env) * (pow 2 (M.find y env)))))
  | Slw(x, C(i)) when M.mem x env -> (Li(((M.find x env) * pow 2 i)))
  | Lwz(x, V(y)) when M.mem x env && M.mem y env -> (Lwc((M.find x env) + (M.find y env)))
  | Lwz(x, C(i)) when M.mem x env -> (Lwc((M.find x env) + i))
  | Stw(x, y, V(z)) when M.mem y env && M.mem z env -> (Swc(x, (M.find y env) + (M.find z env)))
  | Stw(x, y, C(i)) when (M.mem y env) -> (Swc(x, (M.find y env) + i))
  | Lfd(x, V(y)) when M.mem x env && M.mem y env -> (Lwfc((M.find y env) + (M.find y env)))
  | Lfd(x, C(i)) when M.mem x env -> (Lwfc((M.find x env) + i))
  | Stfd(x, y, V(z)) when M.mem y env && M.mem z env -> (Swfc(x, (M.find y env) + (M.find z env)))
  | Stfd(x, y, C(i)) when (M.mem y env) -> (Swfc(x, (M.find y env) + i))
  | Stfd(x, y, V(z)) when M.mem x env2 && M.find x env2 = 0. -> (Stfdz(y, V(z)))
  | Stfd(x, y, C(i)) when M.mem x env2 && M.find x env2 = 0. -> (Stfdz(y, C(i)))
  | Swfc(x, i) when M.mem x env2 && M.find x env2 = 0. -> (Swfcz(i))
  | IfFEq(x, y, e1, e2) when M.mem y env2 && M.find y env2 = 0. -> (IfFEqz(x, g env env2 e1, g env env2 e2))
  | IfFLT(x, y, e1, e2) when M.mem y env2 && M.find y env2 = 0. -> (IfFLTz(x, g env env2 e1, g env env2 e2))
  | IfFLT(x, y, e1, e2) when M.mem x env2 && M.find x env2 = 0. -> (IfFGTz(y, g env env2 e1, g env env2 e2))
  | IfFLT(x, y, e1, e2) when M.mem x env2  -> (IfFLTi1(M.find x env2, y, g env env2 e1, g env env2 e2))
  | IfFLT(x, y, e1, e2) when M.mem y env2  -> (IfFLTi2(x, M.find y env2, g env env2 e1, g env env2 e2))
  | IfEq(x, C(i), e1, e2) when M.mem x env -> if M.find x env = i then IfEq(x, V(x), g (M.add x i env) env2 e1, Ans(Nop)) else IfEq(x, V(x), g env env2 e2, Ans(Nop))
  | IfEq(x, C(i), e1, e2) ->  IfEq(x, C(i), g (M.add x i env) env2 e1, g env env2 e2)
  | IfLT(x, C(i), e1, e2) when M.mem x env -> if M.find x env < i then IfEq(x, V(x), g env env2 e1, Ans(Nop)) else IfEq(x, V(x), g env env2 e2, Ans(Nop))
  | IfFEq(x, y, e1, e2) when M.mem x env2 && M.mem y env2 -> if M.find x env2 = M.find y env2 then IfEq(x, V(x), g env env2 e1, Ans(Nop)) else IfEq(x, V(x), g env env2 e2, Ans(Nop))
  | IfFLT(x, y, e1, e2) when M.mem x env2 && M.mem y env2 -> if M.find x env2 < M.find y env2 then IfEq(x, V(x), g env env2 e1, Ans(Nop)) else IfEq(x, V(x), g env env2 e2, Ans(Nop))
  | IfEq(x, y', e1, e2) -> (IfEq(x, y', g env env2 e1, g env env2 e2))
  | IfLT(x, y', e1, e2) -> (IfLT(x, y', g env env2 e1, g env env2 e2)) 
  | IfFEq(x, y, e1, e2) -> (IfFEq(x, y, g env env2 e1, g env env2 e2))
  | IfFLT(x, y, e1, e2) -> (IfFLT(x, y, g env env2 e1, g env env2 e2))
  | IfLT2(i, y, e1, e2) -> (IfLT2(i, y, g env env2 e1, g env env2 e2))
  | e -> (e) 

let h { name = l; args = xs; fargs = ys; body = e; ret = t } =
  { name = l; args = xs; fargs = ys; body = g M.empty M.empty e; ret = t }

let f (Prog(data, fundefs, e, _)) = 
  Prog(data, List.map h fundefs, g M.empty M.empty e, M.empty)

(* let env = ref M.empty
let env2 = ref M.empty

let rec g = function
  | Ans(exp) -> g' exp
  | Let((x, t), Li(i), e) when -32768 <= i && i < 32768 ->
      env := (M.add x i !env);
      let e' = g e in
      if List.mem x (fv e') then Let((x, t), Li(i), e') else e'
  | Let((x, t), FLi(f), e) ->
      env2 := (M.add x f !env2);
      let e' = g e in
      if List.mem x (fv e') then Let((x, t), FLi(f), e') else e'
  | Let(xt, Slw(y, C(i)), e) when M.mem y !env -> 
      g (Let(xt, Li((M.find y !env) lsl i), e))
  | Let(xt, exp, e) -> let exp' = g2 exp in Let(xt, exp', g e)
and g' = function
  | Mr(x) when M.mem x !env -> Ans(Li(M.find x !env))
  | Add(x, V(y)) when M.mem x !env && M.mem y !env -> Ans(Li((M.find x !env) + (M.find y !env)))
  | Add(x, V(y)) when M.mem x !env -> Ans(Add(y, C(M.find x !env)))
  | Add(x, C(i)) when M.mem x !env -> Ans(Li((M.find x !env) + i))
  | FMr(x) when M.mem x !env2 -> Ans(FLi(M.find x !env2))
  | FNeg(x) when M.mem x !env2 -> Ans(FLi(-.M.find x !env2))
  | FAdd(x, Vf(y)) when M.mem x !env2 && M.mem y !env2 -> Ans(FLi((M.find x !env2) +. (M.find y !env2)))
  | FAdd(x, Vf(y)) when M.mem y !env2 -> Ans(FAdd(x, Cf(M.find y !env2)))
  | FAdd(x, Vf(y)) when M.mem x !env2 -> Ans(FAdd(y, Cf(M.find x !env2)))
  | FSub(x, Vf(y)) when M.mem x !env2 && M.mem y !env2 -> Ans(FLi((M.find x !env2) -. (M.find y !env2)))
  | FSub(x, Vf(y)) when M.mem x !env2 && M.find x !env2 = 0. -> Ans(FNeg(y))
  | FSub(x, Vf(y)) when M.mem y !env2 -> Ans(FSub(x, Cf(M.find y !env2)))
  | FSub(x, Vf(y)) when M.mem x !env2 -> Ans(FSub2(M.find x !env2, y))
  | FMul(x, Vf(y)) when M.mem x !env2 && M.mem y !env2 -> Ans(FLi((M.find x !env2) *. (M.find y !env2)))
  | FMul(x, Vf(y)) when M.mem y !env2 -> Ans(FMul(x, Cf(M.find y !env2)))
  | FMul(x, Vf(y)) when M.mem x !env2 -> Ans(FMul(y, Cf(M.find x !env2)))
  | FDiv(x, Vf(y)) when M.mem x !env2 && M.mem y !env2 -> Ans(FLi((M.find x !env2) /. (M.find y !env2)))
  | FDiv(x, Vf(y)) when M.mem x !env2 && M.find x !env2 = 0. -> Ans(FLi(0.))
  | FDiv(x, Vf(y)) when M.mem y !env2 -> Ans(FDiv(x, Cf(M.find y !env2)))
  | FDiv(x, Vf(y)) when M.mem x !env2 -> Ans(FDiv2(M.find x !env2, y))
  | Sub(x, V(y)) when M.mem x !env && M.mem y !env -> Ans(Li((M.find x !env) - (M.find y !env)))
  | Sub(x, V(y)) when M.mem y !env -> Ans(Sub(x, C(M.find y !env)))
  | Sub(x, C(i)) when M.mem x !env -> Ans(Li((M.find x !env) - i))
  | Slw(x, V(y)) when M.mem x !env && M.mem y !env -> Ans(Li(((M.find x !env) * (pow 2 (M.find y !env)))))
  | Slw(x, C(i)) when M.mem x !env -> Ans(Li(((M.find x !env) * pow 2 i)))
  | Lwz(x, V(y)) when M.mem x !env && M.mem y !env -> Ans(Lwc((M.find x !env) + (M.find y !env)))
  | Lwz(x, C(i)) when M.mem x !env -> Ans(Lwc((M.find x !env) + i))
  | Stw(x, y, V(z)) when M.mem y !env && M.mem z !env -> Ans(Swc(x, (M.find y !env) + (M.find z !env)))
  | Stw(x, y, C(i)) when (M.mem y !env) -> Ans(Swc(x, (M.find y !env) + i))
  | Lfd(x, V(y)) when M.mem x !env && M.mem y !env -> Ans(Lwfc((M.find y !env) + (M.find y !env)))
  | Lfd(x, C(i)) when M.mem x !env -> Ans(Lwfc((M.find x !env) + i))
  | Stfd(x, y, V(z)) when M.mem y !env && M.mem z !env -> Ans(Swfc(x, (M.find y !env) + (M.find z !env)))
  | Stfd(x, y, C(i)) when (M.mem y !env) -> Ans(Swfc(x, (M.find y !env) + i))
  | Stfd(x, y, C(i)) when M.mem x !env2 && M.find x !env2 = 0. -> Ans(Stfdz(y, C(i)))
  | Stfd(x, y, V(z)) when M.mem x !env2 && M.find x !env2 = 0. -> Ans(Stfdz(y, V(z)))
  | Swfc(x, i) when M.mem x !env2 && M.find x !env2 = 0. -> Ans(Swfcz(i))
  | IfEq(x, V(y), e1, e2) when M.mem x !env && M.mem y !env -> if M.find x !env = M.find y !env then g e1 else g e2
  | IfEq(x, C(i), e1, e2) when M.mem x !env -> if M.find x !env = i then g e1 else g e2
  | IfLT(x, V(y), e1, e2) when M.mem x !env && M.mem y !env -> if M.find x !env < M.find y !env then g e1 else g e2
  | IfLT(x, V(y), e1, e2) when M.mem x !env && M.mem y !env -> if M.find x !env < M.find y !env then g e1 else g e2
  | IfFEq(x, y, e1, e2) when M.mem x !env2 && M.mem y !env2 -> if M.find x !env2 = M.find y !env2 then g e1 else g e2
  | IfFLT(x, y, e1, e2) when M.mem x !env2 && M.mem y !env2 -> if M.find x !env2 < M.find y !env2 then g e1 else g e2
  | IfFEq(x, y, e1, e2) when M.mem y !env2 && M.find y !env2 = 0. -> Ans(IfFEqz(x, g e1, g e2))
  | IfFLT(x, y, e1, e2) when M.mem y !env2 && M.find y !env2 = 0. -> Ans(IfFLTz(x, g e1, g e2))
  | IfFLT(x, y, e1, e2) when M.mem x !env2 && M.find x !env2 = 0. -> Ans(IfFGTz(y, g e1, g e2))
  | IfFLT(x, y, e1, e2) when M.mem x !env2  -> Ans(IfFLTi1(M.find x !env2, y, g e1, g e2))
  | IfFLT(x, y, e1, e2) when M.mem y !env2  -> Ans(IfFLTi2(x, M.find y !env2, g e1, g e2)) 
  | IfEq(x, y', e1, e2) -> Ans(IfEq(x, y', g e1, g e2))
  | IfLT(x, y', e1, e2) -> Ans(IfLT(x, y', g e1, g e2)) 
  | IfFEq(x, y, e1, e2) -> Ans(IfFEq(x, y, g e1, g e2))
  | IfFLT(x, y, e1, e2) -> Ans(IfFLT(x, y, g e1, g e2))
  | e -> Ans(e)
and g2 = function
  | Mr(x) when M.mem x !env -> (Li(M.find x !env))
  | Add(x, V(y)) when M.mem x !env && M.mem y !env -> (Li((M.find x !env) + (M.find y !env)))
  | Add(x, V(y)) when M.mem x !env -> (Add(y, C(M.find x !env)))
  | Add(x, C(i)) when M.mem x !env -> (Li((M.find x !env) + i))
  | FMr(x) when M.mem x !env2 -> (FLi(M.find x !env2))
  | FNeg(x) when M.mem x !env2 -> (FLi(-.M.find x !env2))
  | FAdd(x, Vf(y)) when M.mem x !env2 && M.mem y !env2 -> (FLi((M.find x !env2) +. (M.find y !env2)))
  | FAdd(x, Vf(y)) when M.mem y !env2 -> (FAdd(x, Cf(M.find y !env2)))
  | FAdd(x, Vf(y)) when M.mem x !env2 -> (FAdd(y, Cf(M.find x !env2)))
  | FSub(x, Vf(y)) when M.mem x !env2 && M.mem y !env2 -> (FLi((M.find x !env2) -. (M.find y !env2)))
  | FSub(x, Vf(y)) when M.mem x !env2 && M.find x !env2 = 0. -> (FNeg(y))
  | FSub(x, Vf(y)) when M.mem y !env2 -> (FSub(x, Cf(M.find y !env2)))
  | FSub(x, Vf(y)) when M.mem x !env2 -> (FSub2(M.find x !env2, y))
  | FMul(x, Vf(y)) when M.mem x !env2 && M.mem y !env2 -> (FLi((M.find x !env2) *. (M.find y !env2)))
  | FMul(x, Vf(y)) when M.mem y !env2 -> (FMul(x, Cf(M.find y !env2)))
  | FMul(x, Vf(y)) when M.mem x !env2 -> (FMul(y, Cf(M.find x !env2)))
  | FDiv(x, Vf(y)) when M.mem x !env2 && M.mem y !env2 -> (FLi((M.find x !env2) /. (M.find y !env2)))
  | FDiv(x, Vf(y)) when M.mem x !env2 && M.find x !env2 = 0. -> (FLi(0.))
  | FDiv(x, Vf(y)) when M.mem y !env2 -> (FDiv(x, Cf(M.find y !env2)))
  | FDiv(x, Vf(y)) when M.mem x !env2 -> (FDiv2(M.find x !env2, y))
  | Sub(x, V(y)) when M.mem x !env && M.mem y !env -> (Li((M.find x !env) - (M.find y !env)))
  | Sub(x, V(y)) when M.mem y !env -> (Sub(x, C(M.find y !env)))
  | Sub(x, C(i)) when M.mem x !env -> (Li((M.find x !env) - i))
  | Slw(x, V(y)) when M.mem x !env && M.mem y !env -> (Li(((M.find x !env) * (pow 2 (M.find y !env)))))
  | Slw(x, C(i)) when M.mem x !env -> (Li(((M.find x !env) * pow 2 i)))
  | Lwz(x, V(y)) when M.mem x !env && M.mem y !env -> (Lwc((M.find x !env) + (M.find y !env)))
  | Lwz(x, C(i)) when M.mem x !env -> (Lwc((M.find x !env) + i))
  | Stw(x, y, V(z)) when M.mem y !env && M.mem z !env -> (Swc(x, (M.find y !env) + (M.find z !env)))
  | Stw(x, y, C(i)) when (M.mem y !env) -> (Swc(x, (M.find y !env) + i))
  | Lfd(x, V(y)) when M.mem x !env && M.mem y !env -> (Lwfc((M.find y !env) + (M.find y !env)))
  | Lfd(x, C(i)) when M.mem x !env -> (Lwfc((M.find x !env) + i))
  | Stfd(x, y, V(z)) when M.mem y !env && M.mem z !env -> (Swfc(x, (M.find y !env) + (M.find z !env)))
  | Stfd(x, y, C(i)) when (M.mem y !env) -> (Swfc(x, (M.find y !env) + i))
  | Stfd(x, y, V(z)) when M.mem x !env2 && M.find x !env2 = 0. -> (Stfdz(y, V(z)))
  | Stfd(x, y, C(i)) when M.mem x !env2 && M.find x !env2 = 0. -> (Stfdz(y, C(i)))
  | Swfc(x, i) when M.mem x !env2 && M.find x !env2 = 0. -> (Swfcz(i))
  | IfFEq(x, y, e1, e2) when M.mem y !env2 && M.find y !env2 = 0. -> (IfFEqz(x, g e1, g e2))
  | IfFLT(x, y, e1, e2) when M.mem y !env2 && M.find y !env2 = 0. -> (IfFLTz(x, g e1, g e2))
  | IfFLT(x, y, e1, e2) when M.mem x !env2 && M.find x !env2 = 0. -> (IfFGTz(y, g e1, g e2))
  | IfFLT(x, y, e1, e2) when M.mem x !env2  -> (IfFLTi1(M.find x !env2, y, g e1, g e2))
  | IfFLT(x, y, e1, e2) when M.mem y !env2  -> (IfFLTi2(x, M.find y !env2, g e1, g e2))
  | IfEq(x, C(i), e1, e2) when M.mem x !env -> if M.find x !env = i then IfEq(x, V(x), g e1, Ans(Nop)) else IfEq(x, V(x), g e2, Ans(Nop))
  | IfLT(x, C(i), e1, e2) when M.mem x !env -> if M.find x !env < i then IfEq(x, V(x), g e1, Ans(Nop)) else IfEq(x, V(x), g e2, Ans(Nop))
  | IfFEq(x, y, e1, e2) when M.mem x !env2 && M.mem y !env2 -> if M.find x !env2 = M.find y! env2 then IfEq(x, V(x), g e1, Ans(Nop)) else IfEq(x, V(x), g e2, Ans(Nop))
  | IfFLT(x, y, e1, e2) when M.mem x !env2 && M.mem y !env2 -> if M.find x !env2 < M.find y !env2 then IfEq(x, V(x), g e1, Ans(Nop)) else IfEq(x, V(x), g e2, Ans(Nop))
  | IfEq(x, y', e1, e2) -> (IfEq(x, y', g e1, g e2))
  | IfLT(x, y', e1, e2) -> (IfLT(x, y', g e1, g e2)) 
  | IfFEq(x, y, e1, e2) -> (IfFEq(x, y, g e1, g e2))
  | IfFLT(x, y, e1, e2) -> (IfFLT(x, y, g e1, g e2))
  | e -> (e)

let h { name = l; args = xs; fargs = ys; body = e; ret = t } =
  { name = l; args = xs; fargs = ys; body = g e; ret = t }

let f (Prog(data, fundefs, e, _)) = 
  Prog(data, List.map h fundefs, g e, M.empty) *)