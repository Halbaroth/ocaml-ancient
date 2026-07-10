(* Mark objects as 'ancient' so they are taken out of the OCaml heap. *)

type 'a ancient
type info = { i_size : int }

external mark_info : 'a -> 'a ancient * info = "ancient_mark_info"

let mark obj = fst (mark_info obj)

external follow : 'a ancient -> 'a = "ancient_follow"
external delete : 'a ancient -> unit = "ancient_delete"
external is_ancient : 'a -> bool = "ancient_is_ancient"
external address_of : 'a -> nativeint = "ancient_address_of"

type md

external attach : Unix.file_descr -> nativeint -> md = "ancient_attach"
external detach : md -> unit = "ancient_detach"

external share_info : md -> int -> 'a -> 'a ancient * info
  = "ancient_share_info"

let share md key obj = fst (share_info md key obj)

external get : md -> int -> 'a ancient = "ancient_get"

let get x y =
  if Sys.win32 then invalid_arg "Ancient.get: not supported"
  else get x y

let attach =
  if Sys.win32 then invalid_arg "Ancient.attach: not supported"
  else attach

let detach =
  if Sys.win32 then invalid_arg "Ancient.detach: not supported"
  else detach

let share x y z =
  if Sys.win32 then invalid_arg "Ancient.share: not supported"
  else share x y z
