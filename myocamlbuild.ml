
open Ocamlbuild_plugin
let () =
  dispatch @@ function
  | Before_options ->
    Options.use_ocamlfind := true
  | Before_rules ->
    flag [ "menhir"; "ocaml"; "incremental"] @@ A "--table"
  | _ -> ()
