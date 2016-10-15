
type 'a t

type 'a comparison = 'a -> 'a -> int

val create : 'a comparison -> 'a t


val comp : 'a t -> 'a comparison

module Eq : sig
  type (_,_) test =
    | Eq : ('a,'a) test
    | Diseq : ('a,'b) test
end

val eq : 'a t -> 'b t -> ('a,'b) Eq.test

module Comp : sig
  type (_,_) test =
    | Lt : ('a,'b) test
    | Eq : ('a,'a) test
    | Gt : ('a,'b) test
end

val compare : 'a t -> 'b t -> ('a,'b) Comp.test
