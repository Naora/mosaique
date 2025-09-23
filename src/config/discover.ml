module C = Configurator.V1

(* flags:
    -fPIC
    -I/usr/include/glib-2.0
    -I/usr/lib/x86_64-linux-gnu/glib-2.0/include
    -I/usr/include/libmount
    -I/usr/include/blkid
    -I/usr/include/webp
    -I/usr/include/pango-1.0
    -I/usr/include/harfbuzz
    -I/usr/include/freetype2
    -I/usr/include/libpng16
    -I/usr/include/fribidi
    -I/usr/include/cairo
    -I/usr/include/pixman-1
    -I/usr/include/x86_64-linux-gnu
    -I/usr/include/librsvg-2.0
    -I/usr/include/gdk-pixbuf-2.0
    -I/usr/include/hdf5/serial
    -I/usr/include/OpenEXR
    -pthread
    -I/usr/include/Imath
    -I/usr/include/openjpeg-2.5
    -DHWY_SHARED_DEFINE *)

(* c_library_flags: -lvips -lgio-2.0 -lgobject-2.0 -lglib-2.0 *)

let libs = [ "-lvips"; "-lgio-2.0"; "-lgobject-2.0"; "-lglib-2.0" ]
let cflags = [ "-fPIC"; "-DHWY_SHARED_DEFINE" ]

let () =
  C.main ~name:"vips" (fun c ->
      let default : C.Pkg_config.package_conf = { libs; cflags } in
      let conf =
        match C.Pkg_config.get c with
        | None -> default
        | Some pc -> (
            match C.Pkg_config.query pc ~package:"vips" with
            | None -> default
            | Some deps -> deps)
      in

      C.Flags.write_sexp "c_flags.sexp" conf.cflags;
      C.Flags.write_sexp "c_library_flags.sexp" conf.libs)
