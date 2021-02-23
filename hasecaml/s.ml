(* customized version of Set *)

module S =
  Set.Make
    (struct
      type t = Id.t
      let compare = compare
    end)
include S

let of_list l = List.fold_left (fun s e -> add e s) empty l



(* tutorial for me *)
(* 
# let l = of_list  ["a"; "b"];;
val l : t = <abstr>

# S.elements l;;
- : S.elt list = ["a"; "b"]

# let l2 = S.add "x" l;;
val l2 : S.t = <abstr>

# S.elements l2;;
- : S.elt list = ["a"; "b"; "x"]

# let l3 = S.diff l l2;;
val l3 : S.t = <abstr>

# S.elements l3;;
- : S.elt list = []

# let l4 = S.diff l2 l;;
val l4 : S.t = <abstr>

# S.elements l4;;
- : S.elt list = ["x"]

# S.mem "x" l4;;
- : bool = true

# S.mem "y" l4;;
- : bool = false *)