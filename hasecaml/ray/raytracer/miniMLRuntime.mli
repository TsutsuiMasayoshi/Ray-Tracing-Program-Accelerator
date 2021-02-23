(* monomorphic runtime primitives *)

external (=) : int -> int -> bool = "%equal"      (* ok *)
external (<>) : int -> int -> bool = "%notequal"     (* ok *)
external (<) : int -> int -> bool = "%lessthan"     (* ok *)
external (>) : int -> int -> bool = "%greaterthan"    (* ok *)
external (<=) : int -> int -> bool = "%lessequal"     (* ok *)
external (>=) : int -> int -> bool = "%greaterequal"    (* ok *)

external (+) : int -> int -> int = "%addint"      (* ok *)
external (-) : int -> int -> int = "%subint"      (* ok *)
external ( * ) : int -> int -> int = "%mulint"     (* ok *)
external (/) : int -> int -> int = "%divint"         (* ok *)

external fequal : float -> float -> bool = "%equal"    (* ない？ *)
external fless : float -> float -> bool = "%lessthan"    (* ok *)

val fispos : float -> bool
val fisneg : float -> bool
val fiszero : float -> bool

external (+.) : float -> float -> float = "%addfloat"    (* ok *)
external (-.) : float -> float -> float = "%subfloat"      (* ok *)
external ( *. ) : float -> float -> float = "%mulfloat"      (* ok *)
external (/.) : float -> float -> float = "%divfloat"       (* ok *)

external xor : bool -> bool -> bool = "%notequal"   (* ok *)
external not : bool -> bool = "%boolnot"            (* ok *)

(* runtime routines which should be provided by user-written library *)
external fabs : float -> float = "%absfloat"         (* ok *)
external fneg : float -> float = "%negfloat"          (* ok *)
val fsqr : float -> float       (* ok *)
val fhalf : float -> float
external sqrt : float -> float = "sqrt_float" "sqrt" "float"        (* ok *)
external floor : float -> float = "floor_float" "floor" "float"      (* ok *)

external int_of_float : float -> int = "%intoffloat"        (* ok *)
external float_of_int : int -> float = "%floatofint"         (* ok *)

external cos : float -> float = "cos_float" "cos" "float"       (* ok *)
external sin : float -> float = "sin_float" "sin" "float"        (* ok *)
external atan : float -> float = "atan_float" "atan" "float"      (* ok *)

val read_float : unit -> float
val read_int : unit -> int

external create_array : int -> 'a -> 'a array = "caml_make_vect"         (* ok *)

val print_char : int -> unit
val print_int : int -> unit
