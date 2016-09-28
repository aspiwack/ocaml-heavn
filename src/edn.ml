
type 'a comparison = 'a Key.comparison


let rec list_compare : type a. a comparison -> a list comparison = fun cmp l1 l2 ->
  match l1 , l2 with
  | a1::l1 , a2::l2 ->
    begin match cmp a1 a2 with
      | 0 -> list_compare cmp l1 l2
      | c -> c
    end
  | [] , [] -> 0
  | [] , _ -> -1
  | _ , [] -> 1

let array_compare : type a. a comparison -> a array comparison = fun cmp v1 v2 ->
  list_compare cmp (Array.to_list v1) (Array.to_list v2)

let unit_compare : unit comparison = fun () () -> 0


let unit = Key.create unit_compare
let list = Key.create (fun l1 l2 -> list_compare Dyn.compare l1 l2)
let array = Key.create (fun v1 v2 -> array_compare Dyn.compare v1 v2)
let set = Key.create Dyn.Set.compare
let map = Key.create (fun m1 m2 -> Dyn.Map.compare Dyn.compare m1 m2)


type symbol = { prefix:string ; name:string }

(* Global state *)
let keyword_table : symbol Hashcons.t = Hashcons.create 42
type keyword = symbol Hashcons.hash_consed

let make_keyword sym = Hashcons.hashcons keyword_table sym

let symbol_compare : symbol comparison = fun sym1 sym2 ->
  match Pervasives.compare sym1.prefix sym2.prefix with
  | 0 -> Pervasives.compare sym1.name sym2.name
  | c -> c

let keyword_compare : keyword comparison = fun k1 k2 ->
  Pervasives.compare k1.Hashcons.tag k2.Hashcons.tag

let symbol = Key.create symbol_compare
let keyword = Key.create keyword_compare


let bool : bool Key.t = Key.create Pervasives.compare
let int : int Key.t = Key.create Pervasives.compare
let string : string Key.t = Key.create Pervasives.compare
