val unit : unit Key.t
val list : Dyn.t list Key.t
val array : Dyn.t array Key.t
val set : Dyn.Set.t Key.t
val map : Dyn.t Dyn.Map.t Key.t


type symbol = { prefix:string ; name:string }
type keyword = symbol Hashcons.hash_consed

val make_keyword : symbol -> keyword

val symbol : symbol Key.t
val keyword : keyword Key.t


val bool : bool Key.t
val int : int Key.t
val string : string Key.t
