
type 'a t

type 'a comparison = 'a -> 'a -> int

val create : 'a comparison -> 'a t


val comp : 'a t -> 'a comparison

type (_,_) eq_test =
  | Eq : ('a,'a) eq_test
  | Diseq : ('a,'b) eq_test

val eq : 'a t -> 'b t -> ('a,'b) eq_test


type (_,_) cmp_test =
  | Lt : ('a,'b) cmp_test
  | Eq : ('a,'a) cmp_test
  | Gt : ('a,'b) cmp_test

val compare : 'a t -> 'b t -> ('a,'b) cmp_test
