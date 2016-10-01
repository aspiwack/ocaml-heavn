%{

(* TODO: precise error messages *)
(* TODO: these helper functions should probably be in Edn *)
let set_add_check x s =
  if Dyn.Set.mem x s then failwith "Duplicate set entry"
  else Dyn.Set.add x s

let map_add_check k v m =
  if Dyn.Map.mem k m then failwith "Duplicate key in map"
  else Dyn.Map.add k v m

let set_of_list l =
  List.fold_left (fun s x -> set_add_check x s) Dyn.Set.empty l

let map_of_list l =
  List.fold_left (fun s (k,v) -> map_add_check k v s) Dyn.Map.empty l

%}

(* scalars *)
%token <int64> INT
%token <string> STRING
%token <bool> BOOL

(* *)
%token <Edn.symbol> SYMBOL KEYWORD

(* *)
%token NIL

%token LPAREN RPAREN LBRACKET RBRACKET LBRACE HLBRACE RBRACE

%start <Dyn.t> element

%%

element:
| x=scalar { x }
| s=SYMBOL { Dyn.Dyn (Edn.symbol,s) }
| k=KEYWORD { Dyn.Dyn (Edn.keyword, Edn.make_keyword k) }
| NIL { Dyn.Dyn (Edn.unit,()) }
| l=delimited (LPAREN,list(element),RPAREN) { Dyn.Dyn (Edn.list,l) }
| v=delimited (LBRACKET,list(element),RBRACKET) { Dyn.Dyn (Edn.array,Array.of_list v) }
| m=delimited (LBRACE,list(pair(element,element)),RBRACE) { Dyn.Dyn (Edn.map, map_of_list m) }
| s=delimited (HLBRACE,list(element),RBRACE) { Dyn.Dyn (Edn.set, set_of_list s) }

scalar:
| b=BOOL { Dyn.Dyn (Edn.bool,b) }
| n=INT { Dyn.Dyn (Edn.int,n) }
| s=STRING { Dyn.Dyn (Edn.string,s) }