


let digit = [%sedlex.regexp?  '0' .. '9']


(* Non-alphanumeric characters allowed in symbols, including first
   character with no requirement on enclosing characters. *)
let op_anywhere = [%sedlex.regexp?  Chars "*!_?$%&=<>"]
(* These characters can appear anywhere in a symbol, but the next
   character must be non-numerical if they appear first. *)
let op_first_with_restriction = [%sedlex.regexp?  Chars ".+-" ]
(* These characters can appear anywhere but the first position in a symbol. *)
let op_not_first = [%sedlex.regexp?  Chars ":#" ]
(* Non-alphanumeric characters allowed in symbols, with potential
   restriction in the first character. *)
let op_restricted =
  [%sedlex.regexp? op_not_first | op_first_with_restriction | op_anywhere ]


(* Non-numeric characters allowable in a symbol, except maybe the first character. *)
let non_numeric = [%sedlex.regexp?  alphabetic | op_restricted ]
(* Non-numeric characters allowable in a symbol, including the first
   character, with no restriction on enclosing characters. *)
let non_numeric_anywhere = [%sedlex.regexp?  alphabetic | op_anywhere ]
(* Characters allowable in a symbol, except maybe the first character. *)
let character = [%sedlex.regexp?  non_numeric | digit ]


(* Identifiers with their first-character restrictions. *)
let ident = [%sedlex.regexp?
    non_numeric_anywhere , Star character
  | op_first_with_restriction , Opt ( non_numeric_anywhere , Star character ) ]

(* Identifier started with an alphabetic character. *)
let alphaident = [%sedlex.regexp?  alphabetic , Star character ]

(* Identifiers preceded by a colon. *)
let colonident = [%sedlex.regexp?  ':' , ident ]

let parse_prefix s =
  let at = String.index s '/' in
  let prefix = String.sub s 0 at in
  let name = String.(sub s (at+1) (length s - at - 1)) in
  Edn.{prefix;name}

let tokenise lexbuf =
  let open Sedlexing in
  let open Parser in
  [%sedlex match lexbuf with
  (* Symbols *)
    | ident | '/' -> SYMBOL Edn.{prefix=""; name=Utf8.lexeme lexbuf}
    | ident , '/' , ident -> SYMBOL (Utf8.lexeme lexbuf |> parse_prefix)
    | colonident -> KEYWORD Edn.{prefix=""; name=Utf8.lexeme lexbuf}
    | colonident , '/' , ident -> KEYWORD (Utf8.lexeme lexbuf |> parse_prefix)
    | _ -> failwith "Unrecognised lexical sequence"
  ]
