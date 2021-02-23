{
  open Parser
  open String
}

let digit = ['0' - '9']
let alpha = ['a' - 'z' 'A' - 'Z']
let symbol = '.' | '_' | '-'
let init = alpha | '.' | '_'
let id = init (digit | alpha | symbol)*
let sp = [' ' '\t' ]

rule token = parse
  | ":\n"         { COLON }
  | '\n'          { Lexing.new_line lexbuf; token lexbuf}
  | sp+            {token lexbuf}
  | "add"           { ADD }
  | "and"           { AND }
  | "jr"             { JR }
  | "or"             { OR }
  | "slt"           { SLT }
  | "sub"           { SUB }
  | "addi"             { ADDI }
  | "sll"           { SLL }
  | "srl"           { SRL }
  | "beq"               { BEQ }
  | "bne"               { BNE }
  | "j"                   { J }
  | "jal"               { JAL }
  | "lw"                 { LW }
  | "lw2"               { LW2 }
  | "slti"             { SLTI }
  | "sw"                 { SW }
  | "sw2"                { SW2 }
  | "lui"             { LUI }
  | "ori"             { ORI }
  | "blt"             { BLT }
  | "blti"             { BLTI }
  | "blti2"            { BLTI2 }
  | "bflt"             { BFLT }
  | "bnei"             { BNEI }
  | "bflti1"            { BFLTI1 }
  | "bflti2"            { BFLTI2 }
  | "bfeq"             { BFEQ }
  (* | "lahi"            { LAHI } *)
  (* | "lalo"            { LALO } *)
  (* | "mtc1"            { MTC } *)
  | "add.s"           { FADD }
  | "sub.s"           { FSUB } 
  | "mul.s"           { FMUL }
  | "div.s"           { FDIV }
  | "faddi"           { FADDI }
  | "fsubi"           { FSUBI }
  | "fsubi2"          { FSUBI2 }
  | "fmuli"           { FMULI }
  | "fdivi"           { FDIVI }
  | "fdivi2"          { FDIVI2 }
  | "swc1"            { SWC }
  | "lwc1"            { LWC }
  | "c.eq.s"          { FEQ }
  | "c.lt.s"          { FLT }
  | "sqrt"            { SQRT }
  | "floor"           { FLOOR }
  | "ftoi"            { FTOI }
  | "itof"            { ITOF }
  | "flui"            { FLUI }
  | "fori"            { FORI }
  | "outc"            { OUTC }
  | "outi"            { OUTI }
  | "readi"           { READI }
  | "readf"           { READF }
  |  ","                { X }
  |  "("                { L }
  |  ")"                { R }
  | id as s                   { ID s }
  | digit+ as d               { INT (int_of_string d) }
  | '-' digit+ as d         { INT (int_of_string d) }
  | "$zero"               { REG 0 }
  | "$at"                 { REG 1 }
  | "$v0"                 { REG 2 }
  | "$v1"                 { REG 3 }
  | "$a0"                 { REG 4 }
  | "$a1"                 { REG 5 }
  | "$a2"                 { REG 6 }
  | "$a3"                 { REG 7 }
  | "$t0"                 { REG 8 }
  | "$t1"                 { REG 9 }
  | "$t2"                 { REG 10 }
  | "$t3"                 { REG 11 }
  | "$t4"                 { REG 12 }
  | "$t5"                 { REG 13 }
  | "$t6"                 { REG 14 }
  | "$t7"                 { REG 15 }
  | "$s0"                 { REG 16 }
  | "$s1"                 { REG 17 }
  | "$s2"                 { REG 18 }
  | "$s3"                 { REG 19 }
  | "$s4"                 { REG 20 }
  | "$s5"                 { REG 21 }
  | "$s6"                 { REG 22 }
  | "$s7"                 { REG 23 }
  | "$t8"                 { REG 24 }
  | "$t9"                 { REG 25 }
  | "$k0"                 { REG 26 }
  | "$k1"                 { REG 27 }
  | "$gp"                 { REG 28 }
  | "$sp"                 { REG 29 }
  | "$fp"                 { REG 30 }
  | "$ra"                 { REG 31 }
  | "$f0"                 { REG 1 }
  | "$f1"                 { REG 2 }
  | "$f2"                 { REG 3 }
  | "$f3"                 { REG 4 }
  | "$f4"                 { REG 5 }
  | "$f5"                 { REG 6 }
  | "$f6"                 { REG 7 }
  | "$f7"                 { REG 8 }
  | "$f8"                 { REG 9 }
  | "$f9"                 { REG 10 }
  | "$f10"                 { REG 11 }
  | "$f11"                 { REG 12 }
  | "$f12"                 { REG 13 }
  | "$f13"                 { REG 14 }
  | "$f14"                 { REG 15 }
  | "$f15"                 { REG 31 }
  | "$f16"                 { REG 16 }
  | "$f17"                 { REG 17 }
  | "$f18"                 { REG 18 }
  | "$f19"                 { REG 19 }
  | "$f20"                 { REG 20 }
  | "$f21"                 { REG 21 }
  | "$f22"                 { REG 22 }
  | "$f23"                 { REG 23 }
  | "$f24"                 { REG 24 }
  | "$f25"                 { REG 25 }
  | "$f26"                 { REG 26 }
  | "$f27"                 { REG 27 }
  | "$f28"                 { REG 28 }
  | "$f29"                 { REG 29 }
  | "$f30"                 { REG 30 }
  | "$fi0"                 { REG 0 }
  | "$fi1"                 { REG 1 }
  | "$fi2"                 { REG 2 }
  | "$fi3"                 { REG 3 }
  | "$fi4"                 { REG 4 }
  | "$fi5"                 { REG 5 }
  | "$fi6"                 { REG 6 }
  | "$fi7"                 { REG 7 }
  | "$fi8"                 { REG 8 }
  | "$fi9"                 { REG 9 }
  | "$fi10"                 { REG 10 }
  | "$fi11"                 { REG 11 }
  | "$fi12"                 { REG 12 }
  | "$fi13"                 { REG 13 }
  | "$fi14"                 { REG 14 }
  | "$fi15"                 { REG 15 }
  | "$fi16"                 { REG 16 }
  | "$fi17"                 { REG 17 }
  | "$fi18"                 { REG 18 }
  | "$fi19"                 { REG 19 }
  | "$fi20"                 { REG 20 }
  | "$fi21"                 { REG 21 }
  | "$fi22"                 { REG 22 }
  | "$fi23"                 { REG 23 }
  | "$fi24"                 { REG 24 }
  | "$fi25"                 { REG 25 }
  | "$fi26"                 { REG 26 }
  | "$fi27"                 { REG 27 }
  | "$fi28"                 { REG 28 }
  | "$fi29"                 { REG 29 }
  | "$fi30"                 { REG 30 }
  | "$fi31"                 { REG 31 }
  | "$fi32"                 { REG 32 }
  | "$fi33"                 { REG 33 }
  | "$fi34"                 { REG 34 }
  | "$fi35"                 { REG 35 }
  | "$fi36"                 { REG 36 }
  | "$fi37"                 { REG 37 }
  | "$fi38"                 { REG 38 }
  | "$fi39"                 { REG 39 }
  | "$fi40"                 { REG 40 }
  | "$fi41"                 { REG 41 }
  | "$fi42"                 { REG 42 }
  | "$fi43"                 { REG 43 }
  | "$fi44"                 { REG 44 }
  | "$fi45"                 { REG 45 }
  | "$fi46"                 { REG 46 }
  | "$fi47"                 { REG 47 }
  | "$fi48"                 { REG 48 }
  | "$fi49"                 { REG 49 }
  | "$fi50"                 { REG 50 }
  | "$fi51"                 { REG 51 }
  | "$fi52"                 { REG 52 }
  | "$fi53"                 { REG 53 }
  | "$fi54"                 { REG 54 }
  | "$fi55"                 { REG 55 }
  | "$fi56"                 { REG 56 }
  | "$fi57"                 { REG 57 }
  | "$fi58"                 { REG 58 }
  | "$fi59"                 { REG 59 }
  | "$fi60"                 { REG 60 }
  | "$fi61"                 { REG 61 }
  | "$fi62"                 { REG 62 }
  | "$fi63"                 { REG 63 } 
  | "$fzero"                 { REG 0 }
  |  eof               { EOF }
  | _
    { failwith
        (Printf.sprintf "unknown token %s near line: %d"
           (Lexing.lexeme lexbuf)
           lexbuf.lex_curr_p.pos_lnum)
          }
