type image

type format = 
  | JPEG of int
  | PNG        
  | WEBP of int

exception Vips_error of string

(* External C function declarations *)
external init : unit -> unit = "mosaique_init"
external shutdown : unit -> unit = "mosaique_shutdown"
external load : string -> image = "mosaique_load"
external save_stub : image -> string -> unit = "mosaique_save_stub"
external width : image -> int = "mosaique_width"
external height : image -> int = "mosaique_height"
external bands : image -> int = "mosaique_bands"
external resize : image -> int -> int -> image = "mosaique_resize"
external rotate : image -> float -> image = "mosaique_rotate"
external grayscale : image -> image = "mosaique_grayscale"
external flip_horizontal : image -> image = "mosaique_flip_horizontal"
external flip_vertical : image -> image = "mosaique_flip_vertical"

(* For now, we'll ignore the format parameter in save and rely on file extension *)
let save img _format filename = save_stub img filename