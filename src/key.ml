
type 'a comparison = 'a -> 'a -> int

type _ key = ..

module type Key = sig

  type t

  type _ key += K : t key

  val compare : t comparison

end

module Make (T:sig type t val compare : t comparison end) : Key with type t = T.t = struct

  type t = T.t

  type _ key += K : t key

  let compare = T.compare

end

type 'a t = (module Key with type t = 'a)

let create (type a) (comp:a comparison) : a t =
  let module T = struct type t = a let compare = comp end in
  let module K = Make(T) in
  (module K)

let comp (type a) (k:a t) : a comparison =
  let module K = (val k) in
  K.compare

type (_,_) cmp_test =
  | Lt : ('a,'b) cmp_test
  | Eq : ('a,'a) cmp_test
  | Gt : ('a,'b) cmp_test

let compare (type a) (type b) (k1:a t) (k2:b t) : (a,b) cmp_test =
  let module K1 = (val k1) in
  let module K2 = (val k2) in
  match K2.K with
  | K1.K -> Eq
  | _ ->
    (* aspiwack: Unfortunately, I don't know a way to implement key
       comparison without resorting to the [Obj] module. This is still
       type-safe though, hence a very mild transgression (in fact, it
       can be argued that the most unsafe part of this code is the
       generic [Pervasives.compare]). *)
    if Pervasives.compare (Obj.repr k1) (Obj.repr k2) > 0 then Gt
    else Lt

type (_,_) eq_test =
  | Eq : ('a,'a) eq_test
  | Diseq : ('a,'b) eq_test

let eq (type a) (type b) (k1:a t) (k2:b t) : (a,b) eq_test =
  match compare k1 k2 with
  | Eq -> Eq
  | Gt | Lt -> Diseq
