
module Self = struct
  type t = Dyn : 'a Key.t * 'a -> t

  let compare : t -> t -> int = fun (Dyn (k1,x1)) (Dyn (k2,x2)) ->
    let open Key in
    match Key.compare k1 k2 with
    | Comp.Eq -> Key.comp k1 x1 x2
    | Comp.Lt -> -1
    | Comp.Gt -> 1

end

include Self

module Set = Set.Make(Self)
module Map = Map.Make(Self)
