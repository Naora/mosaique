open Camlid
open Helper

(* Custom type for VipsImage pointer *)
let vips_image =
  custom_ptr
    ~finalize:"vips_image_finalize"
    ~ml:"t"
    ~c:"VipsImage *"
    ()

let () =
  Generate.to_file "mosaique_bindings"
    ~headers:["mosaique_c.h"]
    [
      (* Initialization and shutdown *)
      func "mosaique_c_init" [input (string_nt ())] ~ml:"init";
      func "mosaique_c_shutdown" [] ~ml:"shutdown";
      
      (* Loading and saving *)
      func "mosaique_c_load" [input (string_nt ())] ~result:vips_image ~ml:"load";
      func "mosaique_c_save" [input vips_image; input (string_nt ())] ~ml:"save_stub";
      func "mosaique_c_save_webp" [input vips_image; input int_trunc; input (string_nt ())] ~ml:"save_webp";
      func "mosaique_c_save_jpeg" [input vips_image; input int_trunc; input (string_nt ())] ~ml:"save_jpeg";
      
      (* Image properties *)
      func "mosaique_c_width" [input vips_image] ~result:int_trunc ~ml:"width";
      func "mosaique_c_height" [input vips_image] ~result:int_trunc ~ml:"height";
      func "mosaique_c_bands" [input vips_image] ~result:int_trunc ~ml:"bands";
      
      (* Transformations *)
      func "mosaique_c_resize" [input vips_image; input int_trunc; input int_trunc] ~result:vips_image ~ml:"resize";
      func "mosaique_c_rotate" [input vips_image; input double] ~result:vips_image ~ml:"rotate";
      func "mosaique_c_grayscale" [input vips_image] ~result:vips_image ~ml:"grayscale";
      func "mosaique_c_flip" [input vips_image; input int_trunc] ~result:vips_image ~ml:"flip";
    ]
