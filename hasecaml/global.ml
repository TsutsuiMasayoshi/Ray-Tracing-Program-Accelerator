(* iterの前にやったほうがいいっぽい
根拠はない
*)
open KNormal

let memi x env = match M.find x env with Int(_) -> true | _ -> false
let findi x env = match M.find x env with Int(i) -> i | _ -> raise Not_found

let rec g env e = match e with
  | Let((x, t), Tuple(ys), e1) -> Let((x, t), GlobalTuple(ys), g env e1)
  | Let((x, t), ExtFunApp("create_array", [a; b]), e1) when memi a env -> 
    Let((x, t), GlobalArray(findi a env, b), g env e1)
  | Let((x, t), ExtFunApp("create_float_array", [a; b]), e1) when memi a env -> 
    Let((x, t), GlobalArray(findi a env, b), g env e1)
  | Let((x, t), e1, e2) -> 
    let e1' = g env e1 in
    Let((x, t), e1', g (M.add x e1' env) e2)
  | LetTuple(xs, y, e1) -> LetTuple(xs, y, g env e1)
  | IfEq(x, y, e1, e2) -> IfEq(x, y, g env e1, g env e2)
  | IfLE(x, y, e1, e2) -> IfLE(x, y, g env e1, g env e2)
  | _ -> e

(* 関数が出てくる前に *)

let f e = g M.empty e
