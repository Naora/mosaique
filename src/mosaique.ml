type t = Mosaique_bindings.t

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

(* Initialize on module load *)
let () = Mosaique_bindings.init Sys.argv.(0)

exception Vips_error of string

(* Re-export bindings *)
let shutdown = Mosaique_bindings.shutdown
let load = Mosaique_bindings.load
let save_stub = Mosaique_bindings.save_stub
let save_webp = Mosaique_bindings.save_webp
let save_jpeg = Mosaique_bindings.save_jpeg
let width = Mosaique_bindings.width
let height = Mosaique_bindings.height
let bands = Mosaique_bindings.bands

(* Labeled argument wrappers *)
let resize img ~width ~height = Mosaique_bindings.resize img width height
let rotate img angle = Mosaique_bindings.rotate img angle
let grayscale = Mosaique_bindings.grayscale

(* Direction conversion helper *)
let direction_to_int = function
  | Horizontal -> 1  (* VIPS_DIRECTION_HORIZONTAL *)
  | Vertical -> 2    (* VIPS_DIRECTION_VERTICAL *)

let flip img direction = 
  Mosaique_bindings.flip img (direction_to_int direction)

(* Pipeline runner - needs to be implemented *)
let run img pipeline =
  let rec apply_ops img = function
    | [] -> img
    | op :: rest ->
        let img' = match op with
          | Transformations.Resize (w, h) -> resize img ~width:w ~height:h
          | Transformations.Rotate angle -> rotate img angle
          | Transformations.Grayscale -> grayscale img
          | Transformations.Flip dir -> flip img dir
        in
        apply_ops img' rest
  in
  apply_ops img pipeline

let save img format filename =
  match format with
  | Auto -> save_stub img filename
  | JPEG jpeg -> save_jpeg img jpeg filename
  | WEBP webp -> save_webp img webp filename
