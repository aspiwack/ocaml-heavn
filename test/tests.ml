
let () =
  let _ = Parsing.of_file "test/edn/test1.edn" in
  Format.printf "SUCCESS@."
