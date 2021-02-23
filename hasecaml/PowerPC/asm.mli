type id_or_imm = V of Id.t | C of int
type id_or_fimm = Vf of Id.t | Cf of float
type t =
  | Ans of exp
  | Let of (Id.t * Type.t) * exp * t
and exp =
  | Nop
  | Li of int
  | FLi of (* Id.l *) float
  | SetL of Id.l
  | Mr of Id.t
  | Neg of Id.t
  | Add of Id.t * id_or_imm
  | Sub of Id.t * id_or_imm
  | Slw of Id.t * id_or_imm
  | Slr of Id.t * id_or_imm
  | Lwz of Id.t * id_or_imm
  | Lwc of int
  | Stw of Id.t * Id.t * id_or_imm
  | Swc of Id.t * int
  | FMr of Id.t 
  | FNeg of Id.t
  | FAdd of Id.t * id_or_fimm
  | FSub of Id.t * id_or_fimm
  | FSub2 of float * Id.t
  | FMul of Id.t * id_or_fimm
  | FDiv of Id.t * id_or_fimm
  | FDiv2 of float * Id.t
  | Lfd of Id.t * id_or_imm
  | Stfd of Id.t * Id.t * id_or_imm
  | Stfdz of Id.t * id_or_imm
  | Lwfc of int
  | Swfc of Id.t * int
  | Swfcz of int
  | Comment of string
  (* virtual instructions *)
  | IfEq of Id.t * id_or_imm * t * t
  | IfLT of Id.t * id_or_imm * t * t
  | IfLT2 of int * Id.t * t * t
  | IfFEq of Id.t * Id.t * t * t  
  | IfFEqz of Id.t * t * t
  | IfFLT of Id.t * Id.t * t * t
  | IfFLTi1 of float * Id.t * t * t
  | IfFLTi2 of Id.t * float * t * t
  | IfFLTz of Id.t * t * t
  | IfFGTz of Id.t * t * t
  (* closure address, integer arguments, and float arguments *)
  (* | CallCls of Id.t * Id.t list * Id.t list *)
  | CallDir of Id.l * Id.t list * Id.t list
  | Save of Id.t * Id.t (* �쥸�����ѿ����ͤ򥹥��å��ѿ�����¸ *)
  | Restore of Id.t (* �����å��ѿ������ͤ����� *)
type fundef = { name : Id.l; args : Id.t list; fargs : Id.t list; body : t; ret : Type.t }
type prog = Prog of (float * int) list * fundef list * t * (Type.t * int) M.t

val fletd : Id.t * exp * t -> t (* shorthand of Let for float *)
val seq : exp * t -> t (* shorthand of Let for unit *)

val regs : Id.t array
val fregs : Id.t array
val allregs : Id.t list
val allfregs : Id.t list
val reg_cl : Id.t
val reg_sw : Id.t
val reg_fsw : Id.t
val reg_hp : Id.t
val reg_sp : Id.t
val reg_ra : Id.t
val reg_zero: Id.t
val reg_fzero : Id.t
val reg_my_temp: Id.t
val is_reg : Id.t -> bool

val fv : t -> Id.t list
val fv_exp : exp -> Id.t list
val fv_id_or_imm : id_or_imm -> Id.t list
val concat : t -> Id.t * Type.t -> t -> t

val align : int -> int
