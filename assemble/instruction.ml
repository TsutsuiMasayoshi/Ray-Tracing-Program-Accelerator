(* let lis = ref [] *)

type pc = int
type label = string
type reg = int

type labellis =
  | Label of label
  | Labellis of label * labellis

type rdRsRt = [ `Add | `Sub | `And | `Or | `Slt | `Fadd | `Fsub | `Fmul | `Fdiv | `Feq | `Flt | `Lw2 | `Sw2 ]
type rdRsRti = [ `FAddi | `FSubi | `FMuli | `FDivi | `FSubi2 | `FDivi2 ]
type rdRs = [ `Sqrt | `Floor | `Ftoi | `Itof ]
type rdRtshamt = [ `Sll | `Srl ]
type rtRsImm = [ `Addi | `Slti | `Ori | `Fori ]
type rtImm = [ `Lui | `Flui  ]
(* type loadLabel = [ `Lahi | `Lalo ] *)
type rsRtOffset = [ `Beq | `Bne | `Blt | `Bflt | `Bfeq | `Bflti1 | `Bflti2 ]
type rsimmOffset = [ `Blti | `Bnei ]
type immrtOffset = [ `Blti2 ]
type rtOffsetBase = [ `Lw | `Sw | `Lwc | `Swc ]
type inout = [ `Outc | `Outi | `Readi | `Readf ]
type imm26 = [ `J | `Jal ]

type ins = 
  | RdRsRt of rdRsRt * reg * reg * reg
  | RdRsRti of rdRsRti * reg * reg * reg
  | RdRs of rdRs * reg * reg
  | RdRtshamt of rdRtshamt * reg * reg * int
  | RtRsImm of rtRsImm * reg * reg * int
  | RtImm of rtImm * reg * int
  (* | LoadLabel of loadLabel * reg * label *  pc *)
  | RtOffsetBase of rtOffsetBase * reg * int * reg
  | RsRtOffset of rsRtOffset * reg * reg * label * pc
  | RsImmOffset of rsimmOffset * reg * int * label * pc
  | ImmRtOffset of immrtOffset * int * reg * label * pc
  | InOut of inout * reg
  | Imm26 of imm26 * label
  | Jr of reg

type exp = 
  (* | Label of label * pc * ins *)
  | Labelandins of labellis * pc * ins
  | Exp of ins
  | Eof of unit

type t = Elis of t * exp | E of exp

(* mainのprogram 以下編集用のタダのメモです*)
(* let rec f oc t = match t with
  | Elis (e1, t1) -> g oc e1; f oc t1
  | Elis (e1) -> g oc e1

let rec g oc e = match e with
  | Label (l1, pc1) -> Printf.fprintf oc ("label\n");(* メモしておく*)
  | Exp (ins1) -> h ins1


  
let h ins = match ins with
  | RdRsRt (Add, gp1, gp2, gp3) -> Printf.fprintf oc ("000000"); out_register oc gp1; out_register oc gp2; out_register oc gp3; Printf.fprintf oc ("0100000");
  | RdRsRt (Sub, gp1, gp2, gp3) -> Printf.fprintf oc ("000000"); out_register oc gp1; out_register oc gp2; out_register oc gp3; Printf.fprintf oc ("0100010");
  | _ -> () *)