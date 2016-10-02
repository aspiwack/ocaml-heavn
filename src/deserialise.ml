
(* type Lexing.position { pos_fname : string; pos_lnum : int; pos_bol : int; pos_cnum : int; }
- file name
- line number
- number of chars until the beginning of the line
- number of character (from the beginning of the file) to the current position*)

(** [zero_pos f] returns the {!Lexing.position} [0] at file
    [f]. Menhir uses Ocamllex position regardless of whether the lexer is
    Ocamllex or something else. *)
let zero_pos f =
  Lexing.{ pos_fname = f ; pos_lnum = 0 ; pos_bol = 0 ; pos_cnum = 0 }

(** [loc_of_lexeme f lexbuf] returns the position of the start and end
    of the last recognised lexeme. Wrapper around [Sedlexing.loc]. *)
let loc_of_lexeme f lexbuf =
  (* TODO: line numbers and positions. *)
  let (start_pos,end_pos) = Sedlexing.loc lexbuf in
  Lexing.{ pos_fname = f ; pos_lnum = 0 ; pos_bol = 0 ; pos_cnum = start_pos } ,
  Lexing.{ pos_fname = f ; pos_lnum = 0 ; pos_bol = 0 ; pos_cnum = end_pos }

let of_file f =
  let chan = open_in f in
  let lexbuf = Sedlexing.Utf8.from_channel chan in
  let supplier () =
    let t = Lexer.tokenise lexbuf in
    let (s,e) = loc_of_lexeme f lexbuf in
    (t,s,e)
  in
  let result =
    Parser.MenhirInterpreter.loop
      supplier
      (Parser.Incremental.element (zero_pos f))
  in
  let () = close_in chan in
  result
