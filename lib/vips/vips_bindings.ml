(* VIPS C bindings using external declarations *)

type vips_image

(* Library initialization *)
external vips_init : string -> int = "ocaml_vips_init"
external vips_shutdown : unit -> unit = "ocaml_vips_shutdown"

(* Version information *)
external vips_version_string : unit -> string = "ocaml_vips_version_string"
external vips_version : int -> int = "ocaml_vips_version"

(* Error handling *)
external vips_error_buffer : unit -> string = "ocaml_vips_error_buffer"
external vips_error_clear : unit -> unit = "ocaml_vips_error_clear"

(* Image creation and destruction *)
external vips_image_new : unit -> vips_image = "ocaml_vips_image_new"
external vips_image_new_memory : unit -> vips_image = "ocaml_vips_image_new_memory"

external vips_image_new_from_file : string -> vips_image = "vips_image_new_from_file_stub"

(* Image properties *)
external vips_image_get_width : vips_image -> int = "ocaml_vips_image_get_width"
external vips_image_get_height : vips_image -> int = "ocaml_vips_image_get_height"
external vips_image_get_bands : vips_image -> int = "ocaml_vips_image_get_bands"

(* Image I/O *)
external vips_image_write_to_file : vips_image -> string -> int = "vips_image_write_to_file_stub"

(* Object reference counting *)
external g_object_unref : vips_image -> unit = "ocaml_g_object_unref"