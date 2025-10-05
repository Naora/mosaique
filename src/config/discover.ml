module C = Configurator.V1

let libs = [ "-lvips"; "-lgio-2.0"; "-lgobject-2.0"; "-lglib-2.0" ]
let cflags = [ "-fPIC" ]

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
