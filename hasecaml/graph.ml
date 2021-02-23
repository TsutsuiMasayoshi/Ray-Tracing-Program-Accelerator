(* 基本的にグラフは辺集合を扱っている。勿論点集合も用いる。*)

let rec sub1 x lis = match lis with (* x と lis の各頂点を結んだグラフを構築 *)
  | [] -> []
  | y::rest -> (x, y)::(sub1 x rest)

let rec complete vlis = match vlis with (* vlisの頂点からなる完全グラフを返す *)
  | [] -> []
  | x::rest -> (sub1 x rest)@(complete rest)

let rec print_graph oc elis = match elis with
  | [] -> ()
  | (e1, e2)::rest -> Printf.fprintf oc "(%s, %s)\n" e1 e2

let rec add_sub e elis = let (x, y) = e in
  if List.mem e elis || List.mem (y, x) elis then elis else e::elis

let rec add elis1 elis2 = match elis1 with
  | [] -> elis2
  | e::rest -> add_sub e (add rest elis2)

let rec deg v elis = match elis with 
  | [] -> 0
  | (x, y)::rest -> (if x = v || y = v then 1 else 0) + (deg v rest)

let rec delete v elis = match elis with
  | [] -> []
  | (x, y)::rest -> if x = v || y = v then delete v rest else (x, y)::(delete v rest)

let rec simplify reg_num vlis elis = match vlis with 
  | [] -> []
  | v1::rest -> if (deg v1 elis) < reg_num then (simplify reg_num rest (delete v1 elis))@[v1] else simplify reg_num (rest@[v1]) elis

exception Spill
exception Conflict (* 辺の両端が同じ色 *)

let is_reg x = (x.[0] = '%')||(x.[0] = 'r')   (* 後半はテストのため *)

let rec alloc_sub3 x reg elis = match elis with
  | [] -> []
  | (a, b)::rest when (a = x && b = reg)||(a = reg && b = x) -> raise Conflict
  | (a, b)::rest when a = x -> (reg, b)::(alloc_sub3 x reg rest)
  | (a, b)::rest when b = x -> (a, reg)::(alloc_sub3 x reg rest)
  | (a, b)::rest -> (a, b)::(alloc_sub3 x reg rest)

(* spillしないことを前提としている。 *)
let rec alloc_sub2 x reg_lis elis = match reg_lis with
  | [] -> raise Spill 
  | reg_first::rest -> (try (reg_first, alloc_sub3 x reg_first elis) with Conflict -> alloc_sub2 x rest elis)

(* resultに彩色の結果が返る。*)
let rec alloc_sub reg_lis reg_stuck elis result = match reg_stuck with
  | [] -> result
  | x::rest -> if is_reg x then alloc_sub reg_lis rest elis result else let (color, elis') = alloc_sub2 x reg_lis elis in alloc_sub reg_lis rest elis' ((x, color)::result)

let alloc reg_lis vlis elis =
  let reg_stuck = simplify (List.length reg_lis) vlis elis in
  alloc_sub reg_lis reg_stuck elis []

let rec substitute priority_list elis = match priority_list with
  | [] -> elis
  | (a, b)::rest -> substitute rest (alloc_sub3 a b elis)

let rec first l = match l with
  | [] -> []
  | (a, b)::rest -> a::(first rest)

let rec del x vlis = match vlis with
  | [] -> []
  | v::rest -> if v = x then rest else v::(del x rest)

let rec myf dellis vlis = match dellis with
  | [] -> vlis
  | x::rest -> myf rest (del x vlis)


(* priority_listは変数に優先的にレジスタを割当てから他を割り当てられる *)
let alloc_priority reg_lis vlis elis priority_list =
  let new_elis = substitute priority_list elis in
  let priority_v = first priority_list in
  let ret = alloc reg_lis (myf priority_v vlis) new_elis in
  priority_list@ret

let rec print_graph g = match g with
  | [] -> ()
  | (a, b)::rest ->  print_string "("; print_string a; print_string ", "; print_string b; print_string ")\n"; print_graph rest

(* test用 *)
let v = ["a"; "b"; "c"; "d"; "e"]
let v1 = ["a"; "b"; "c"; "d"]
let v2 = ["a"; "d"; "e"]
let g1 = complete v1
let g2 = complete v2
let g3 = add g1 g2
let v_sample = ["b"; "c"; "d"; "e"; "f"; "g"; "h"; "j"; "k"; "m"]
let e_sample = [("b", "c"); ("b", "d"); ("b", "e"); ("b", "k"); ("e", "j"); ("e", "m"); ("f", "j"); ("f", "m"); ("m", "d"); ("d", "k"); ("d", "h"); ("j", "k"); ("j", "g"); ("j", "h"); ("h", "g"); ("g", "k")]
let v_sample2 = ["a"; "b"; "c"; "d"; "e"]
let e_sample2 = [("a", "r2"); ("a", "c"); ("r2", "c"); ("a", "d")]
let reg = ["r1"; "r2"; "r3"; "r4"; "r5"]
