(* Vips OCaml bindings - Main interface *)

module Types = Vips_types
module Bindings = Vips_bindings

(* Re-export key types *)
type vips_image = Types.vips_image

(* Exception for VIPS errors *)
exception Vips_error of string

(* Main library initialization *)
let init () = Bindings.vips_init (Sys.argv.(0))

(* Library shutdown *)
let shutdown () = Bindings.vips_shutdown ()

(* Error handling *)
let error_buffer () = Bindings.vips_error_buffer ()
let error_clear () = Bindings.vips_error_clear ()

(* Version information *)
let version () = Bindings.vips_version_string ()

(* Helper function to check for errors and raise exceptions *)
let check_error msg =
  let error = error_buffer () in
  if String.length error > 0 then (
    error_clear ();
    raise (Vips_error (msg ^ ": " ^ error))
  )

(* High-level image operations *)
module Image = struct
  type t = vips_image

  (* Create new image *)
  let new_memory () = 
    let img = Bindings.vips_image_new_memory () in
    check_error "Failed to create memory image";
    img

  (* Load image from file *)
  let new_from_file filename =
    try
      let img = Bindings.vips_image_new_from_file filename in
      check_error ("Failed to load image from " ^ filename);
      img
    with
    | Failure msg -> raise (Vips_error msg)

  (* Get image properties *)
  let width img = Bindings.vips_image_get_width img
  let height img = Bindings.vips_image_get_height img
  let bands img = Bindings.vips_image_get_bands img
  
  (* Get image dimensions as tuple *)
  let dimensions img = (width img, height img)
  
  (* Save image to file *)
  let write_to_file img filename =
    let result = Bindings.vips_image_write_to_file img filename in
    if result <> Types.vips_success then (
      check_error ("Failed to save image to " ^ filename)
    )

  (* Release image reference *)
  let unref img = Bindings.g_object_unref img
  
  (* Safe wrapper that automatically unrefs the image *)
  let with_image img f =
    try
      let result = f img in
      unref img;
      result
    with e ->
      unref img;
      raise e
end