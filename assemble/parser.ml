type token =
  | INT of (int)
  | ID of (string)
  | REG of (int)
  | ADD
  | ADDI
  | AND
  | SLL
  | SRL
  | J
  | JR
  | JAL
  | OR
  | SLT
  | SLTI
  | SUB
  | SW
  | LW
  | SW2
  | LW2
  | LUI
  | ORI
  | BNE
  | BEQ
  | BLT
  | BLTI
  | BLTI2
  | BNEI
  | BFLT
  | BFLTI1
  | BFLTI2
  | BFEQ
  | FADD
  | FSUB
  | FMUL
  | FDIV
  | FADDI
  | FSUBI
  | FMULI
  | FDIVI
  | FSUBI2
  | FDIVI2
  | FEQ
  | FLT
  | SWC
  | LWC
  | SQRT
  | FLOOR
  | FTOI
  | ITOF
  | FLUI
  | FORI
  | OUTC
  | OUTI
  | READI
  | READF
  | COLON
  | X
  | L
  | R
  | EOF

open Parsing;;
let _ = parse_error;;
# 2 "parser.mly"
  open Instruction
# 68 "parser.ml"
let yytransl_const = [|
  260 (* ADD *);
  261 (* ADDI *);
  262 (* AND *);
  263 (* SLL *);
  264 (* SRL *);
  265 (* J *);
  266 (* JR *);
  267 (* JAL *);
  268 (* OR *);
  269 (* SLT *);
  270 (* SLTI *);
  271 (* SUB *);
  272 (* SW *);
  273 (* LW *);
  274 (* SW2 *);
  275 (* LW2 *);
  276 (* LUI *);
  277 (* ORI *);
  278 (* BNE *);
  279 (* BEQ *);
  280 (* BLT *);
  281 (* BLTI *);
  282 (* BLTI2 *);
  283 (* BNEI *);
  284 (* BFLT *);
  285 (* BFLTI1 *);
  286 (* BFLTI2 *);
  287 (* BFEQ *);
  288 (* FADD *);
  289 (* FSUB *);
  290 (* FMUL *);
  291 (* FDIV *);
  292 (* FADDI *);
  293 (* FSUBI *);
  294 (* FMULI *);
  295 (* FDIVI *);
  296 (* FSUBI2 *);
  297 (* FDIVI2 *);
  298 (* FEQ *);
  299 (* FLT *);
  300 (* SWC *);
  301 (* LWC *);
  302 (* SQRT *);
  303 (* FLOOR *);
  304 (* FTOI *);
  305 (* ITOF *);
  306 (* FLUI *);
  307 (* FORI *);
  308 (* OUTC *);
  309 (* OUTI *);
  310 (* READI *);
  311 (* READF *);
  312 (* COLON *);
  313 (* X *);
  314 (* L *);
  315 (* R *);
    0 (* EOF *);
    0|]

let yytransl_block = [|
  257 (* INT *);
  258 (* ID *);
  259 (* REG *);
    0|]

let yylhs = "\255\255\
\001\000\001\000\001\000\002\000\002\000\003\000\003\000\004\000\
\004\000\004\000\004\000\004\000\004\000\004\000\004\000\004\000\
\004\000\004\000\004\000\004\000\005\000\005\000\005\000\005\000\
\005\000\005\000\005\000\005\000\005\000\005\000\005\000\005\000\
\005\000\006\000\006\000\006\000\006\000\006\000\006\000\008\000\
\008\000\007\000\007\000\007\000\007\000\009\000\009\000\009\000\
\009\000\010\000\010\000\011\000\011\000\011\000\011\000\011\000\
\011\000\011\000\012\000\012\000\013\000\014\000\014\000\014\000\
\014\000\015\000\015\000\015\000\015\000\016\000\016\000\000\000"

let yylen = "\002\000\
\001\000\002\000\001\000\002\000\001\000\002\000\003\000\006\000\
\006\000\004\000\006\000\006\000\004\000\006\000\006\000\006\000\
\007\000\002\000\002\000\002\000\001\000\001\000\001\000\001\000\
\001\000\001\000\001\000\001\000\001\000\001\000\001\000\001\000\
\001\000\001\000\001\000\001\000\001\000\001\000\001\000\001\000\
\001\000\001\000\001\000\001\000\001\000\001\000\001\000\001\000\
\001\000\001\000\001\000\001\000\001\000\001\000\001\000\001\000\
\001\000\001\000\001\000\001\000\001\000\001\000\001\000\001\000\
\001\000\001\000\001\000\001\000\001\000\001\000\001\000\002\000"

let yydefred = "\000\000\
\000\000\000\000\003\000\000\000\021\000\046\000\023\000\040\000\
\041\000\070\000\000\000\071\000\024\000\025\000\047\000\022\000\
\063\000\062\000\027\000\026\000\050\000\048\000\053\000\052\000\
\054\000\059\000\061\000\060\000\055\000\057\000\058\000\056\000\
\028\000\029\000\030\000\031\000\034\000\035\000\036\000\037\000\
\038\000\039\000\032\000\033\000\065\000\064\000\042\000\043\000\
\044\000\045\000\051\000\049\000\066\000\067\000\068\000\069\000\
\000\000\001\000\000\000\005\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\020\000\002\000\004\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\018\000\019\000\
\007\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\010\000\000\000\000\000\
\013\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\008\000\009\000\011\000\
\012\000\014\000\015\000\016\000\000\000\017\000"

let yydgoto = "\002\000\
\057\000\058\000\059\000\060\000\061\000\062\000\063\000\064\000\
\065\000\066\000\067\000\068\000\069\000\070\000\071\000\072\000"

let yysindex = "\002\000\
\000\255\000\000\000\000\201\254\000\000\000\000\000\000\000\000\
\000\000\000\000\211\255\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\054\255\000\000\106\255\000\000\212\255\213\255\214\255\215\255\
\216\255\217\255\218\255\219\255\056\255\220\255\221\255\223\255\
\224\255\000\000\000\000\000\000\170\255\171\255\172\255\173\255\
\174\255\175\255\176\255\177\255\178\255\179\255\000\000\000\000\
\000\000\234\255\235\255\236\255\237\255\238\255\241\255\240\255\
\243\255\242\255\245\255\190\255\191\255\000\000\192\255\193\255\
\000\000\194\255\195\255\196\255\197\255\251\255\253\255\001\000\
\003\000\255\255\004\000\005\000\006\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\200\255\000\000"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\005\001\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\158\255\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000"

let yygindex = "\000\000\
\000\000\207\000\193\000\208\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"

let yytablesize = 267
let yytable = "\003\000\
\073\000\004\000\001\000\005\000\006\000\007\000\008\000\009\000\
\010\000\011\000\012\000\013\000\014\000\015\000\016\000\017\000\
\018\000\019\000\020\000\021\000\022\000\023\000\024\000\025\000\
\026\000\027\000\028\000\029\000\030\000\031\000\032\000\033\000\
\034\000\035\000\036\000\037\000\038\000\039\000\040\000\041\000\
\042\000\043\000\044\000\045\000\046\000\047\000\048\000\049\000\
\050\000\051\000\052\000\053\000\054\000\055\000\056\000\004\000\
\085\000\005\000\006\000\007\000\008\000\009\000\010\000\011\000\
\012\000\013\000\014\000\015\000\016\000\017\000\018\000\019\000\
\020\000\021\000\022\000\023\000\024\000\025\000\026\000\027\000\
\028\000\029\000\030\000\031\000\032\000\033\000\034\000\035\000\
\036\000\037\000\038\000\039\000\040\000\041\000\042\000\043\000\
\044\000\045\000\046\000\047\000\048\000\049\000\050\000\051\000\
\052\000\053\000\054\000\055\000\056\000\005\000\006\000\007\000\
\008\000\009\000\010\000\011\000\012\000\013\000\014\000\015\000\
\016\000\017\000\018\000\019\000\020\000\021\000\022\000\023\000\
\024\000\025\000\026\000\027\000\028\000\029\000\030\000\031\000\
\032\000\033\000\034\000\035\000\036\000\037\000\038\000\039\000\
\040\000\041\000\042\000\043\000\044\000\045\000\046\000\047\000\
\048\000\049\000\050\000\051\000\052\000\053\000\054\000\055\000\
\056\000\006\000\006\000\006\000\006\000\006\000\006\000\006\000\
\006\000\006\000\006\000\006\000\006\000\006\000\006\000\006\000\
\006\000\006\000\006\000\006\000\006\000\006\000\006\000\006\000\
\006\000\006\000\006\000\006\000\006\000\006\000\006\000\006\000\
\006\000\006\000\006\000\006\000\006\000\006\000\006\000\006\000\
\006\000\006\000\006\000\006\000\006\000\006\000\006\000\006\000\
\006\000\006\000\006\000\006\000\006\000\074\000\077\000\078\000\
\079\000\080\000\081\000\082\000\083\000\084\000\086\000\087\000\
\088\000\004\000\090\000\091\000\092\000\093\000\094\000\095\000\
\096\000\097\000\098\000\099\000\100\000\101\000\102\000\103\000\
\104\000\105\000\106\000\107\000\108\000\109\000\110\000\111\000\
\112\000\113\000\114\000\115\000\116\000\118\000\117\000\119\000\
\122\000\120\000\126\000\121\000\072\000\123\000\124\000\075\000\
\125\000\089\000\076\000"

let yycheck = "\000\001\
\056\001\002\001\001\000\004\001\005\001\006\001\007\001\008\001\
\009\001\010\001\011\001\012\001\013\001\014\001\015\001\016\001\
\017\001\018\001\019\001\020\001\021\001\022\001\023\001\024\001\
\025\001\026\001\027\001\028\001\029\001\030\001\031\001\032\001\
\033\001\034\001\035\001\036\001\037\001\038\001\039\001\040\001\
\041\001\042\001\043\001\044\001\045\001\046\001\047\001\048\001\
\049\001\050\001\051\001\052\001\053\001\054\001\055\001\002\001\
\001\001\004\001\005\001\006\001\007\001\008\001\009\001\010\001\
\011\001\012\001\013\001\014\001\015\001\016\001\017\001\018\001\
\019\001\020\001\021\001\022\001\023\001\024\001\025\001\026\001\
\027\001\028\001\029\001\030\001\031\001\032\001\033\001\034\001\
\035\001\036\001\037\001\038\001\039\001\040\001\041\001\042\001\
\043\001\044\001\045\001\046\001\047\001\048\001\049\001\050\001\
\051\001\052\001\053\001\054\001\055\001\004\001\005\001\006\001\
\007\001\008\001\009\001\010\001\011\001\012\001\013\001\014\001\
\015\001\016\001\017\001\018\001\019\001\020\001\021\001\022\001\
\023\001\024\001\025\001\026\001\027\001\028\001\029\001\030\001\
\031\001\032\001\033\001\034\001\035\001\036\001\037\001\038\001\
\039\001\040\001\041\001\042\001\043\001\044\001\045\001\046\001\
\047\001\048\001\049\001\050\001\051\001\052\001\053\001\054\001\
\055\001\004\001\005\001\006\001\007\001\008\001\009\001\010\001\
\011\001\012\001\013\001\014\001\015\001\016\001\017\001\018\001\
\019\001\020\001\021\001\022\001\023\001\024\001\025\001\026\001\
\027\001\028\001\029\001\030\001\031\001\032\001\033\001\034\001\
\035\001\036\001\037\001\038\001\039\001\040\001\041\001\042\001\
\043\001\044\001\045\001\046\001\047\001\048\001\049\001\050\001\
\051\001\052\001\053\001\054\001\055\001\003\001\003\001\003\001\
\003\001\003\001\003\001\003\001\003\001\003\001\003\001\003\001\
\002\001\002\001\057\001\057\001\057\001\057\001\057\001\057\001\
\057\001\057\001\057\001\057\001\003\001\003\001\003\001\003\001\
\003\001\001\001\003\001\001\001\003\001\001\001\057\001\057\001\
\057\001\057\001\057\001\057\001\057\001\003\001\058\001\003\001\
\002\001\001\001\059\001\001\001\000\000\002\001\002\001\057\000\
\003\001\073\000\059\000"

let yynames_const = "\
  ADD\000\
  ADDI\000\
  AND\000\
  SLL\000\
  SRL\000\
  J\000\
  JR\000\
  JAL\000\
  OR\000\
  SLT\000\
  SLTI\000\
  SUB\000\
  SW\000\
  LW\000\
  SW2\000\
  LW2\000\
  LUI\000\
  ORI\000\
  BNE\000\
  BEQ\000\
  BLT\000\
  BLTI\000\
  BLTI2\000\
  BNEI\000\
  BFLT\000\
  BFLTI1\000\
  BFLTI2\000\
  BFEQ\000\
  FADD\000\
  FSUB\000\
  FMUL\000\
  FDIV\000\
  FADDI\000\
  FSUBI\000\
  FMULI\000\
  FDIVI\000\
  FSUBI2\000\
  FDIVI2\000\
  FEQ\000\
  FLT\000\
  SWC\000\
  LWC\000\
  SQRT\000\
  FLOOR\000\
  FTOI\000\
  ITOF\000\
  FLUI\000\
  FORI\000\
  OUTC\000\
  OUTI\000\
  READI\000\
  READF\000\
  COLON\000\
  X\000\
  L\000\
  R\000\
  EOF\000\
  "

let yynames_block = "\
  INT\000\
  ID\000\
  REG\000\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'exp) in
    Obj.repr(
# 19 "parser.mly"
        (E (_1))
# 365 "parser.ml"
               : Instruction.t))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Instruction.t) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'exp) in
    Obj.repr(
# 20 "parser.mly"
                 (Elis (_1, _2))
# 373 "parser.ml"
               : Instruction.t))
; (fun __caml_parser_env ->
    Obj.repr(
# 22 "parser.mly"
    ( failwith
        (Printf.sprintf "parse error near line:%d characters %d-%d"
           ((Parsing.symbol_start_pos ()).pos_lnum)
           ((Parsing.symbol_start_pos ()).Lexing.pos_cnum-(Parsing.symbol_start_pos ()).Lexing.pos_bol)
           ((Parsing.symbol_end_pos ()).Lexing.pos_cnum-(Parsing.symbol_start_pos ()).Lexing.pos_bol)))
# 383 "parser.ml"
               : Instruction.t))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'labellis) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'ins) in
    Obj.repr(
# 29 "parser.mly"
                 ( Labelandins (_1, (Parsing.symbol_start_pos ()).pos_lnum, _2) )
# 391 "parser.ml"
               : 'exp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'ins) in
    Obj.repr(
# 30 "parser.mly"
               ( Exp (_1))
# 398 "parser.ml"
               : 'exp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : string) in
    Obj.repr(
# 34 "parser.mly"
             ( Label (_1))
# 405 "parser.ml"
               : 'labellis))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'labellis) in
    Obj.repr(
# 35 "parser.mly"
                      ( Labellis (_1, _3))
# 413 "parser.ml"
               : 'labellis))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 5 : 'rdRsRt) in
    let _2 = (Parsing.peek_val __caml_parser_env 4 : int) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : int) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 38 "parser.mly"
                            ( RdRsRt (_1, _2, _4, _6) )
# 423 "parser.ml"
               : 'ins))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 5 : 'rdRsRti) in
    let _2 = (Parsing.peek_val __caml_parser_env 4 : int) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : int) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 39 "parser.mly"
                             ( RdRsRti (_1, _2, _4, _6) )
# 433 "parser.ml"
               : 'ins))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : 'rdRs) in
    let _2 = (Parsing.peek_val __caml_parser_env 2 : int) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 40 "parser.mly"
                   ( RdRs (_1, _2, _4) )
# 442 "parser.ml"
               : 'ins))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 5 : 'rdRtshamt) in
    let _2 = (Parsing.peek_val __caml_parser_env 4 : int) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : int) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 41 "parser.mly"
                              ( RdRtshamt (_1, _2, _4, _6) )
# 452 "parser.ml"
               : 'ins))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 5 : 'rtRsImm) in
    let _2 = (Parsing.peek_val __caml_parser_env 4 : int) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : int) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 42 "parser.mly"
                            ( RtRsImm (_1, _2, _4, _6) )
# 462 "parser.ml"
               : 'ins))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : 'rtImm) in
    let _2 = (Parsing.peek_val __caml_parser_env 2 : int) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 43 "parser.mly"
                    ( RtImm (_1, _2, _4) )
# 471 "parser.ml"
               : 'ins))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 5 : 'rsRtOffset) in
    let _2 = (Parsing.peek_val __caml_parser_env 4 : int) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : int) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 44 "parser.mly"
                              ( RsRtOffset (_1, _2, _4, _6, (Parsing.symbol_start_pos ()).pos_lnum) )
# 481 "parser.ml"
               : 'ins))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 5 : 'rsimmOffset) in
    let _2 = (Parsing.peek_val __caml_parser_env 4 : int) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : int) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 45 "parser.mly"
                               ( RsImmOffset (_1, _2, _4, _6, (Parsing.symbol_start_pos ()).pos_lnum) )
# 491 "parser.ml"
               : 'ins))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 5 : 'immrtOffset) in
    let _2 = (Parsing.peek_val __caml_parser_env 4 : int) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : int) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 46 "parser.mly"
                               ( ImmRtOffset (_1, _2, _4, _6, (Parsing.symbol_start_pos ()).pos_lnum) )
# 501 "parser.ml"
               : 'ins))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 6 : 'rtOffsetBase) in
    let _2 = (Parsing.peek_val __caml_parser_env 5 : int) in
    let _4 = (Parsing.peek_val __caml_parser_env 3 : int) in
    let _6 = (Parsing.peek_val __caml_parser_env 1 : int) in
    Obj.repr(
# 47 "parser.mly"
                                   ( RtOffsetBase (_1, _2, _4, _6) )
# 511 "parser.ml"
               : 'ins))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'inout) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 48 "parser.mly"
              ( InOut (_1, _2))
# 519 "parser.ml"
               : 'ins))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'imm26) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 49 "parser.mly"
             ( Imm26 (_1, _2) )
# 527 "parser.ml"
               : 'ins))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 50 "parser.mly"
           ( Jr (_2))
# 534 "parser.ml"
               : 'ins))
; (fun __caml_parser_env ->
    Obj.repr(
# 54 "parser.mly"
        ( `Add )
# 540 "parser.ml"
               : 'rdRsRt))
; (fun __caml_parser_env ->
    Obj.repr(
# 54 "parser.mly"
                       ( `Sub )
# 546 "parser.ml"
               : 'rdRsRt))
; (fun __caml_parser_env ->
    Obj.repr(
# 54 "parser.mly"
                                      ( `And )
# 552 "parser.ml"
               : 'rdRsRt))
; (fun __caml_parser_env ->
    Obj.repr(
# 54 "parser.mly"
                                                    ( `Or )
# 558 "parser.ml"
               : 'rdRsRt))
; (fun __caml_parser_env ->
    Obj.repr(
# 54 "parser.mly"
                                                                  ( `Slt )
# 564 "parser.ml"
               : 'rdRsRt))
; (fun __caml_parser_env ->
    Obj.repr(
# 54 "parser.mly"
                                                                                 ( `Lw2 )
# 570 "parser.ml"
               : 'rdRsRt))
; (fun __caml_parser_env ->
    Obj.repr(
# 54 "parser.mly"
                                                                                                ( `Sw2 )
# 576 "parser.ml"
               : 'rdRsRt))
; (fun __caml_parser_env ->
    Obj.repr(
# 55 "parser.mly"
         ( `Fadd )
# 582 "parser.ml"
               : 'rdRsRt))
; (fun __caml_parser_env ->
    Obj.repr(
# 55 "parser.mly"
                          ( `Fsub )
# 588 "parser.ml"
               : 'rdRsRt))
; (fun __caml_parser_env ->
    Obj.repr(
# 55 "parser.mly"
                                           ( `Fmul )
# 594 "parser.ml"
               : 'rdRsRt))
; (fun __caml_parser_env ->
    Obj.repr(
# 55 "parser.mly"
                                                            ( `Fdiv )
# 600 "parser.ml"
               : 'rdRsRt))
; (fun __caml_parser_env ->
    Obj.repr(
# 55 "parser.mly"
                                                                            ( `Feq )
# 606 "parser.ml"
               : 'rdRsRt))
; (fun __caml_parser_env ->
    Obj.repr(
# 55 "parser.mly"
                                                                                           ( `Flt )
# 612 "parser.ml"
               : 'rdRsRt))
; (fun __caml_parser_env ->
    Obj.repr(
# 58 "parser.mly"
          ( `FAddi )
# 618 "parser.ml"
               : 'rdRsRti))
; (fun __caml_parser_env ->
    Obj.repr(
# 58 "parser.mly"
                             ( `FSubi )
# 624 "parser.ml"
               : 'rdRsRti))
; (fun __caml_parser_env ->
    Obj.repr(
# 58 "parser.mly"
                                                ( `FMuli )
# 630 "parser.ml"
               : 'rdRsRti))
; (fun __caml_parser_env ->
    Obj.repr(
# 58 "parser.mly"
                                                                   ( `FDivi )
# 636 "parser.ml"
               : 'rdRsRti))
; (fun __caml_parser_env ->
    Obj.repr(
# 58 "parser.mly"
                                                                                       ( `FSubi2 )
# 642 "parser.ml"
               : 'rdRsRti))
; (fun __caml_parser_env ->
    Obj.repr(
# 58 "parser.mly"
                                                                                                            ( `FDivi2 )
# 648 "parser.ml"
               : 'rdRsRti))
; (fun __caml_parser_env ->
    Obj.repr(
# 61 "parser.mly"
        ( `Sll )
# 654 "parser.ml"
               : 'rdRtshamt))
; (fun __caml_parser_env ->
    Obj.repr(
# 61 "parser.mly"
                       ( `Srl )
# 660 "parser.ml"
               : 'rdRtshamt))
; (fun __caml_parser_env ->
    Obj.repr(
# 64 "parser.mly"
         ( `Sqrt )
# 666 "parser.ml"
               : 'rdRs))
; (fun __caml_parser_env ->
    Obj.repr(
# 64 "parser.mly"
                           ( `Floor )
# 672 "parser.ml"
               : 'rdRs))
; (fun __caml_parser_env ->
    Obj.repr(
# 64 "parser.mly"
                                             ( `Ftoi )
# 678 "parser.ml"
               : 'rdRs))
; (fun __caml_parser_env ->
    Obj.repr(
# 64 "parser.mly"
                                                              ( `Itof )
# 684 "parser.ml"
               : 'rdRs))
; (fun __caml_parser_env ->
    Obj.repr(
# 67 "parser.mly"
         ( `Addi )
# 690 "parser.ml"
               : 'rtRsImm))
; (fun __caml_parser_env ->
    Obj.repr(
# 67 "parser.mly"
                          ( `Slti )
# 696 "parser.ml"
               : 'rtRsImm))
; (fun __caml_parser_env ->
    Obj.repr(
# 67 "parser.mly"
                                          ( `Ori )
# 702 "parser.ml"
               : 'rtRsImm))
; (fun __caml_parser_env ->
    Obj.repr(
# 67 "parser.mly"
                                                          ( `Fori )
# 708 "parser.ml"
               : 'rtRsImm))
; (fun __caml_parser_env ->
    Obj.repr(
# 70 "parser.mly"
        ( `Lui )
# 714 "parser.ml"
               : 'rtImm))
; (fun __caml_parser_env ->
    Obj.repr(
# 70 "parser.mly"
                        ( `Flui )
# 720 "parser.ml"
               : 'rtImm))
; (fun __caml_parser_env ->
    Obj.repr(
# 75 "parser.mly"
                  ( `Beq )
# 726 "parser.ml"
               : 'rsRtOffset))
; (fun __caml_parser_env ->
    Obj.repr(
# 75 "parser.mly"
                                 ( `Bne )
# 732 "parser.ml"
               : 'rsRtOffset))
; (fun __caml_parser_env ->
    Obj.repr(
# 75 "parser.mly"
                                                ( `Blt )
# 738 "parser.ml"
               : 'rsRtOffset))
; (fun __caml_parser_env ->
    Obj.repr(
# 75 "parser.mly"
                                                                 ( `Bflt )
# 744 "parser.ml"
               : 'rsRtOffset))
; (fun __caml_parser_env ->
    Obj.repr(
# 75 "parser.mly"
                                                                                  ( `Bfeq )
# 750 "parser.ml"
               : 'rsRtOffset))
; (fun __caml_parser_env ->
    Obj.repr(
# 75 "parser.mly"
                                                                                                     ( `Bflti1 )
# 756 "parser.ml"
               : 'rsRtOffset))
; (fun __caml_parser_env ->
    Obj.repr(
# 75 "parser.mly"
                                                                                                                          ( `Bflti2 )
# 762 "parser.ml"
               : 'rsRtOffset))
; (fun __caml_parser_env ->
    Obj.repr(
# 77 "parser.mly"
                     ( `Blti )
# 768 "parser.ml"
               : 'rsimmOffset))
; (fun __caml_parser_env ->
    Obj.repr(
# 77 "parser.mly"
                                      ( `Bnei )
# 774 "parser.ml"
               : 'rsimmOffset))
; (fun __caml_parser_env ->
    Obj.repr(
# 79 "parser.mly"
                      ( `Blti2 )
# 780 "parser.ml"
               : 'immrtOffset))
; (fun __caml_parser_env ->
    Obj.repr(
# 81 "parser.mly"
                   ( `Lw )
# 786 "parser.ml"
               : 'rtOffsetBase))
; (fun __caml_parser_env ->
    Obj.repr(
# 81 "parser.mly"
                                ( `Sw )
# 792 "parser.ml"
               : 'rtOffsetBase))
; (fun __caml_parser_env ->
    Obj.repr(
# 81 "parser.mly"
                                              ( `Lwc )
# 798 "parser.ml"
               : 'rtOffsetBase))
; (fun __caml_parser_env ->
    Obj.repr(
# 81 "parser.mly"
                                                             ( `Swc )
# 804 "parser.ml"
               : 'rtOffsetBase))
; (fun __caml_parser_env ->
    Obj.repr(
# 83 "parser.mly"
              ( `Outc )
# 810 "parser.ml"
               : 'inout))
; (fun __caml_parser_env ->
    Obj.repr(
# 83 "parser.mly"
                               ( `Outi )
# 816 "parser.ml"
               : 'inout))
; (fun __caml_parser_env ->
    Obj.repr(
# 83 "parser.mly"
                                                 ( `Readi )
# 822 "parser.ml"
               : 'inout))
; (fun __caml_parser_env ->
    Obj.repr(
# 83 "parser.mly"
                                                                    ( `Readf )
# 828 "parser.ml"
               : 'inout))
; (fun __caml_parser_env ->
    Obj.repr(
# 85 "parser.mly"
           ( `J )
# 834 "parser.ml"
               : 'imm26))
; (fun __caml_parser_env ->
    Obj.repr(
# 85 "parser.mly"
                        ( `Jal )
# 840 "parser.ml"
               : 'imm26))
(* Entry startexp *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
|]
let yytables =
  { Parsing.actions=yyact;
    Parsing.transl_const=yytransl_const;
    Parsing.transl_block=yytransl_block;
    Parsing.lhs=yylhs;
    Parsing.len=yylen;
    Parsing.defred=yydefred;
    Parsing.dgoto=yydgoto;
    Parsing.sindex=yysindex;
    Parsing.rindex=yyrindex;
    Parsing.gindex=yygindex;
    Parsing.tablesize=yytablesize;
    Parsing.table=yytable;
    Parsing.check=yycheck;
    Parsing.error_function=parse_error;
    Parsing.names_const=yynames_const;
    Parsing.names_block=yynames_block }
let startexp (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 1 lexfun lexbuf : Instruction.t)
