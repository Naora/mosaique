type t

type format = JPEG of jpeg | Auto | WEBP of webp
and jpeg = int
and webp = int
and direction = Horizontal | Vertical

module Transformations = struct
  type t = op list

  and op =
    | Resize of int * int
    | Rotate of float
    | Grayscale
    | Flip of direction

  let grayscale t = t @ [ Grayscale ]
  let flip direction t = t @ [ Flip direction ]
  let rotate angle t = t @ [ Rotate angle ]
  let resize ~width ~height t = t @ [ Resize (width, height) ]
end

external init : string -> unit = "mosaique_init"

let () = init Sys.argv.(0)

exception Vips_error of string

external shutdown : unit -> unit = "mosaique_shutdown"
external load : string -> t = "mosaique_load"
external save_stub : t -> string -> unit = "mosaique_save_stub"
external save_webp : t -> webp -> string -> unit = "mosaique_save_webp"
external save_jpeg : t -> jpeg -> string -> unit = "mosaique_save_jpeg"
external width : t -> int = "mosaique_width"
external height : t -> int = "mosaique_height"
external bands : t -> int = "mosaique_bands"
external resize : t -> width:int -> height:int -> t = "mosaique_resize"
external rotate : t -> float -> t = "mosaique_rotate"
external grayscale : t -> t = "mosaique_grayscale"
external flip : t -> direction -> t = "mosaique_flip"
external run : t -> Transformations.t -> t = "mosaique_run"

let save img format filename =
  match format with
  | Auto -> save_stub img filename
  | JPEG jpeg -> save_jpeg img jpeg filename
  | WEBP webp -> save_webp img webp filename
