open OUnit2

let suite =
  "Parser validation" >::: [
    "Mini-test" >:: (fun _ -> ignore @@ Parsing.of_file "test/edn/test1.edn")
  ]


let () =
  run_test_tt_main @@ test_list [
    suite;
  ]
