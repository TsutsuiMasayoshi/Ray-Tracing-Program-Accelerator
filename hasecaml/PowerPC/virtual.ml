(* translation into PowerPC assembly with infinite number of virtual registers *)

open Asm

let data = ref [] (* 浮動小数点の定数テーブル (caml2html: virtual_data) *)

let global_lis = ref []
let globals : (Type.t * int) M.t ref = ref M.empty

let dp = ref 100
let float_data = ref 0

let classify xts ini addf addi =
  List.fold_left
    (fun acc (x, t) ->
      match t with
      | Type.Unit -> acc
      | Type.Float -> addf acc x
      | _ -> addi acc x t)
    ini
    xts

let separate xts =
  classify
    xts
    ([], [])
    (fun (int, float) x -> (int, float @ [x]))
    (fun (int, float) x _ -> (int @ [x], float))

let expand xts ini addf addi =
  classify
    xts
    ini
    (fun (offset, acc) x ->
      let offset = align offset in
      (offset + 1, addf x offset acc))
    (fun (offset, acc) x t ->
      (offset + 1, addi x t offset acc))

let rec g env = function (* 式の仮想マシンコード生成 (caml2html: virtual_g) *)
  | Closure.Unit -> Ans(Nop)
  | Closure.Int(i) -> Ans(Li(i))
  | Closure.Float(d) ->
      (* let l =
        try
          (* 既に定数テーブルにあったら再利用 *)
          let (l, _) = List.find (fun (_, d') -> d = d') !data in
          l
        with Not_found ->
          let l = Id.L(Id.genid "l") in
          data := (l, d) :: !data;
          l in
      Ans(FLi(l)) *)
      (* Ans(FLi(d)) *)
      (
      try
        let _ = List.assoc d !data in ()
      with _ -> 
        data := (d, !float_data)::!data;
        (* print_float d; *)
        float_data := !float_data + 1;
      );
      Ans(FLi(d))
  | Closure.Neg(x) -> Ans(Neg(x))
  | Closure.Add(x, y) -> Ans(Add(x, V(y)))
  | Closure.Sub(x, y) -> Ans(Sub(x, V(y)))
  | Closure.Mult(x, y) -> Ans(Slw(x, C(2)))
  | Closure.Div(x, y) -> Ans(Slr(x, C(1)))
  | Closure.FNeg(x) -> Ans(FNeg(x))
  | Closure.FAdd(x, y) -> Ans(FAdd(x, Vf(y)))
  | Closure.FSub(x, y) -> Ans(FSub(x, Vf(y)))
  | Closure.FMul(x, y) -> Ans(FMul(x, Vf(y)))
  | Closure.FDiv(x, y) -> Ans(FDiv(x, Vf(y)))
  | Closure.IfEq(x, y, e1, e2) ->
      (match M.find x env with
      | Type.Int -> Ans(IfEq(x, V(y), g env e1, g env e2))
      | Type.Float -> Ans(IfFEq(x, y, g env e1, g env e2))
      | _ -> failwith "equality supported only for bool, int, and float")
  | Closure.IfLT(x, y, e1, e2) ->
      (match M.find x env with
      | Type.Int -> Ans(IfLT(x, V(y), g env e1, g env e2))
      | Type.Float -> Ans(IfFLT(x, y, g env e1, g env e2))      (* x <= y then e1 else e2 ---> if x > y then e2 else e1 ---> if y < x then e2 else e1  *)
      | _ -> failwith "inequality supported only for bool, int, and float")
  | Closure.Let((x, t1), e1, e2) when List.mem x !global_lis ->
      let e1' = g env e1 in
      let rec get_addr = function
        | Ans(Li(i)) -> i
        | Ans(Nop) -> -100  (* 何でも大丈夫 *)
        | Let(yt, exp, e) -> get_addr e
        | _ -> assert false in
      globals := M.add x (t1, get_addr e1') !globals;
      let e2' = g (M.add x t1 env) e2 in
      concat e1' (x, t1) e2'
  | Closure.Let((x, t1), e1, e2) ->
      let e1' = g env e1 in
      let e2' = g (M.add x t1 env) e2 in
      concat e1' (x, t1) e2'
  | Closure.Var(x) ->
      (match M.find x env with
      | Type.Unit -> Ans(Nop)
      | Type.Float -> Ans(FMr(x))
      | _ -> Ans(Mr(x)))
  (* | Closure.MakeCls((x, t), { Closure.entry = l; Closure.actual_fv = ys }, e2) -> (* クロージャの生成 (caml2html: virtual_makecls) *)
      (* Closureのアドレスをセットしてから、自由変数の値をストア *)
      let e2' = g (M.add x t env) e2 in
      let offset, store_fv =
        expand
          (List.map (fun y -> (y, M.find y env)) ys)
          (4, e2')
          (fun y offset store_fv -> seq(Stfd(y, x, C(offset)), store_fv))
          (fun y _ offset store_fv -> seq(Stw(y, x, C(offset)), store_fv)) in
      Let((x, t), Mr(reg_hp),
          Let((reg_hp, Type.Int), Add(reg_hp, C(align offset)),
              let z = Id.genid "l" in
              Let((z, Type.Int), SetL(l),
                  seq(Stw(z, x, C(0)),
                      store_fv))))
  | Closure.AppCls(x, ys) ->
      let (int, float) = separate (List.map (fun y -> (y, M.find y env)) ys) in
      Ans(CallCls(x, int, float)) *)
  | Closure.AppDir(Id.L(x), ys) ->
      let (int, float) = separate (List.map (fun y -> (y, M.find y env)) ys) in
      Ans(CallDir(Id.L(x), int, float))
  | Closure.Tuple(xs) -> (* 組の生成 (caml2html: virtual_tuple) *)
      let y = Id.genid "t" in
      let (offset, store) =
        expand
          (List.map (fun x -> (x, M.find x env)) xs)
          (0, Ans(Mr(y)))
          (fun x offset store -> seq(Stfd(x, y, C(offset)), store))
          (fun x _ offset store -> seq(Stw(x, y, C(offset)), store))  in
      Let((y, Type.Tuple(List.map (fun x -> M.find x env) xs)), Mr(reg_hp),
          Let((reg_hp, Type.Int), Add(reg_hp, C(align offset)),
              store))
  | Closure.GlobalTuple(xs) ->
      let y = Id.genid "gt" in
      let (offset, store) =
        expand
          (List.map (fun x -> (x, M.find x env)) xs)
          (0, Ans(Li(!dp)))
          (fun x offset store -> seq(Stfd(x, y, C(offset)), store))
          (fun x _ offset store -> seq(Stw(x, y, C(offset)), store))  in
  Let((y, Type.Tuple(List.map (fun x -> M.find x env) xs)), Li(!dp),
          let () = dp := !dp + offset in
          store)
  | Closure.LetTuple(xts, y, e2) ->
      let s = Closure.fv e2 in
      let (offset, load) =
        expand
          xts
          (0, g (M.add_list xts env) e2)
          (fun x offset load ->
            if not (S.mem x s) then load else (* [XX] a little ad hoc optimization *)
            fletd(x, Lfd(y, C(offset)), load))
          (fun x t offset load ->
            if not (S.mem x s) then load else (* [XX] a little ad hoc optimization *)
            Let((x, t), Lwz(y, C(offset)), load)) in
      load
  | Closure.GlobalArray(i, y) ->
    let z = Id.genid "ga" in
    let addr = !dp in
    (match M.find y env with
    | Type.Unit -> Ans(Nop)
    | Type.Float ->
      (* dp := !dp + 4 * i; *)
      dp := !dp + i;
      let rec store j =
        if j = 0 then Ans(Li(addr)) else
        (* seq(Stfd(y, z, C(4 * (j - 1))), store (j - 1)) in *)
        seq(Stfd(y, z, C( (j - 1))), store (j - 1)) in
      Let((z, Type.Array(Type.Float)), Li(addr),
        store i)
    | t ->
      (* dp := !dp + 4 * i; *)
      dp := !dp + i;
      let rec store j =
        if j = 0 then Ans(Li(addr)) else
        (* seq(Stw(y, z, C(4 * (j - 1))), store (j - 1)) in *)
        seq(Stw(y, z, C( (j - 1))), store (j - 1)) in
      Let((z, Type.Array(t)), Li(addr),
        store i))
  | Closure.Get(x, y) -> (* ������ɤ߽Ф� (caml2html: virtual_get) *)
      (* let offset = Id.genid "o" in *)
      (match M.find x env with
      | Type.Array(Type.Unit) -> Ans(Nop)
      | Type.Array(Type.Float) ->
          (* Let((offset, Type.Int), Slw(y, C(2)), *)
              Ans(Lfd(x, V(y)))
      | Type.Array(_) ->
          (* Let((offset, Type.Int), Slw(y, C(2)), *)
              Ans(Lwz(x, V(y)))
      | _ -> assert false)
  | Closure.Put(x, y, z) ->
      (* let offset = Id.genid "o" in *)
      (match M.find x env with
      | Type.Array(Type.Unit) -> Ans(Nop)
      | Type.Array(Type.Float) ->
          (* Let((offset, Type.Int), Slw(y, C(2)), *)
              Ans(Stfd(z, x, V(y)))
      | Type.Array(_) ->
          (* Let((offset, Type.Int), Slw(y, C(2)), *)
              Ans(Stw(z, x, V(y)))
      | _ -> assert false)
  | Closure.ExtArray(Id.L(x)) -> Ans(SetL(Id.L("min_caml_" ^ x)))


(* 関数の仮想マシンコード生成 (caml2html: virtual_h) *)
let h { Closure.name = (Id.L(x), t); Closure.args = yts; Closure.formal_fv = zts; Closure.body = e } =
  let (int, float) = separate yts in
  let (offset, load) =
    expand
      zts
      (1, g (M.add x t (M.add_list yts (M.add_list zts (M.map fst !globals)))) e)
      (fun z offset load -> fletd(z, Lfd(x, C(offset)), load))
      (fun z t offset load -> Let((z, t), Lwz(x, C(offset)), load)) in
  match t with
  | Type.Fun(_, t2) ->
      { name = Id.L(x); args = int; fargs = float; body = M.fold (fun x (t, addr) e -> concat (Ans(Li(addr))) (x, t) e) !globals load; ret = t2 }
  | _ -> assert false

(*　プログラム全体の仮想マシンコード生成 (caml2html: virtual_f) *)
let f (Closure.Prog(fundefs, e, gl)) =
  data := [];
  global_lis := gl;  
  let e = g M.empty e in
  let fundefs = List.map h fundefs in
  Prog(!data, fundefs, e, !globals)
