(* Vips OCaml bindings - Main interface *)

module Types = Vips_types
module Bindings = Vips_bindings

(* Re-export key types *)
type vips_image = Types.vips_image

(* Main library initialization *)
let init () = Bindings.vips_init (Sys.argv.(0))

(* Library shutdown *)
let shutdown () = Bindings.vips_shutdown ()

(* Error handling *)
let error_buffer () = Bindings.vips_error_buffer ()
let error_clear () = Bindings.vips_error_clear ()

(* Version information *)
let version () = Bindings.vips_version_string ()