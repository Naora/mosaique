type t
and format = JPEG of jpeg | PNG | WEBP of webp
and jpeg = int
and webp = int

exception Vips_error of string

(* External C function declarations *)
external shutdown : unit -> unit = "mosaique_shutdown"
external load : string -> t = "mosaique_load"
external save_stub : t -> string -> unit = "mosaique_save_stub"
external save_webp : t -> webp -> string -> unit = "mosaique_save_webp"
external save_jpeg : t -> jpeg -> string -> unit = "mosaique_save_jpeg"
external width : t -> int = "mosaique_width"
external height : t -> int = "mosaique_height"
external bands : t -> int = "mosaique_bands"
external resize : t -> int -> int -> t = "mosaique_resize"
external rotate : t -> float -> t = "mosaique_rotate"
external grayscale : t -> t = "mosaique_grayscale"
external flip_horizontal : t -> t = "mosaique_flip_horizontal"
external flip_vertical : t -> t = "mosaique_flip_vertical"

(* For now, we'll ignore the format parameter in save and rely on file extension *)
let save img format filename =
  match format with
  | JPEG jpeg -> save_jpeg img jpeg filename
  | PNG -> save_stub img filename
  | WEBP webp -> save_webp img webp filename
