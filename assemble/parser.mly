%{
  open Instruction
%}

%token <int> INT
%token <string> ID
%token <int> REG

%token ADD ADDI AND SLL SRL J JR JAL OR SLT SLTI SUB SW LW SW2 LW2 LUI ORI BNE BEQ BLT BLTI BLTI2 BNEI BFLT BFLTI1 BFLTI2 BFEQ FADD FSUB FMUL FDIV FADDI FSUBI FMULI FDIVI FSUBI2 FDIVI2 FEQ FLT SWC LWC SQRT FLOOR FTOI ITOF FLUI FORI
%token OUTC OUTI READI READF COLON X L R EOF


%start startexp
%type <Instruction.t> startexp

%%

startexp:
  | exp {E ($1)}
  | startexp exp {Elis ($1, $2)} 
  | error
    { failwith
        (Printf.sprintf "parse error near line:%d characters %d-%d"
           ((Parsing.symbol_start_pos ()).pos_lnum)
           ((Parsing.symbol_start_pos ()).Lexing.pos_cnum-(Parsing.symbol_start_pos ()).Lexing.pos_bol)
           ((Parsing.symbol_end_pos ()).Lexing.pos_cnum-(Parsing.symbol_start_pos ()).Lexing.pos_bol))}

exp:
  | labellis ins { Labelandins ($1, (Parsing.symbol_start_pos ()).pos_lnum, $2) }
  | ins        { Exp ($1)}
;

labellis:
  | ID COLON { Label ($1)}
  | ID COLON labellis { Labellis ($1, $3)};

ins:
  | rdRsRt REG X REG X REG  { RdRsRt ($1, $2, $4, $6) }
  | rdRsRti REG X REG X REG  { RdRsRti ($1, $2, $4, $6) }
  | rdRs REG X REG { RdRs ($1, $2, $4) }
  | rdRtshamt REG X REG X INT { RdRtshamt ($1, $2, $4, $6) }
  | rtRsImm REG X REG X INT { RtRsImm ($1, $2, $4, $6) }
  | rtImm REG X INT { RtImm ($1, $2, $4) }
  | rsRtOffset REG X REG X ID { RsRtOffset ($1, $2, $4, $6, (Parsing.symbol_start_pos ()).pos_lnum) }
  | rsimmOffset REG X INT X ID { RsImmOffset ($1, $2, $4, $6, (Parsing.symbol_start_pos ()).pos_lnum) }
  | immrtOffset INT X REG X ID { ImmRtOffset ($1, $2, $4, $6, (Parsing.symbol_start_pos ()).pos_lnum) }
  | rtOffsetBase REG X INT L REG R { RtOffsetBase ($1, $2, $4, $6) }
  | inout REG { InOut ($1, $2)}
  | imm26 ID { Imm26 ($1, $2) }
  | JR REG { Jr ($2)} 
  ;

rdRsRt:
  | ADD { `Add } | SUB { `Sub } | AND { `And } | OR { `Or } | SLT { `Slt } | LW2 { `Lw2 } | SW2 { `Sw2 } 
  | FADD { `Fadd } | FSUB { `Fsub } | FMUL { `Fmul } | FDIV { `Fdiv } | FEQ { `Feq } | FLT { `Flt };

rdRsRti:
  | FADDI { `FAddi } | FSUBI { `FSubi } | FMULI { `FMuli } | FDIVI { `FDivi } | FSUBI2 { `FSubi2 } | FDIVI2 { `FDivi2 }

rdRtshamt:
  | SLL { `Sll } | SRL { `Srl };

rdRs:
  | SQRT { `Sqrt } | FLOOR { `Floor } | FTOI { `Ftoi } | ITOF { `Itof };

rtRsImm:
  | ADDI { `Addi } | SLTI { `Slti } | ORI { `Ori } | FORI { `Fori };

rtImm: 
  | LUI { `Lui } | FLUI { `Flui };

/* loadLabel:
  | LAHI { `Lahi } | LALO { `Lalo } ; */

rsRtOffset: | BEQ { `Beq } | BNE { `Bne } | BLT { `Blt }  | BFLT { `Bflt } | BFEQ { `Bfeq } | BFLTI1 { `Bflti1 } | BFLTI2 { `Bflti2 };

rsimmOffset : | BLTI { `Blti } | BNEI { `Bnei };

immrtOffset : | BLTI2 { `Blti2 };

rtOffsetBase: | LW { `Lw } | SW { `Sw } | LWC { `Lwc } | SWC { `Swc } ; 

inout: | OUTC { `Outc } | OUTI { `Outi } | READI { `Readi } | READF { `Readf } ;

imm26: | J { `J } | JAL { `Jal } ;