let lexbuf outchan l =
  let p = Parser.startexp Lexer.token l in
  Binary.f outchan p

let g = fun f ->
  let inchan = open_in (f ^ ".s") in
  let outchan = open_out (f) in
  try
    lexbuf outchan (Lexing.from_channel inchan);
    close_in inchan;
    close_out outchan;
  with e -> (close_in inchan; close_out outchan; raise e)
  
  (* xxx.sをアセンブルしたい場合xxxを入力 *)
  let () =
    Scanf.fscanf stdin ("%s") g