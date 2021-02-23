(* customized version of Map *)

module M =
  Map.Make
    (struct
      type t = Id.t
      let compare = compare
    end)
include M

let add_list xys env = List.fold_left (fun env (x, y) -> add x y env) env xys
let add_list2 xs ys env = List.fold_left2 (fun env x y -> add x y env) env xs ys

(* tutorial for me *)

(* # let l1 = M.add "apple" "ringo" l;;
val l1 : string M.t = <abstr>

# M.find "apple" l1;;
- : string = "ringo"

# let l3 = add_list [("blue", "ao"); ("green", "midori")] M.empty;;
val l3 : string t = <abstr>

# M.find "blue" l3;;
- : string = "ao" *)