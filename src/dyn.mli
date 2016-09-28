
type t = Dyn : 'a Key.t * 'a -> t

val compare : t -> t -> int

module Set : Set.S
module Map : Map.S
