module C = Configurator.V1

let () =
  C.main ~name:"vips" (fun c ->
      let conf =
        match C.Pkg_config.get c with
        | None -> failwith "pkg-config not found"
        | Some pc -> (
            match C.Pkg_config.query pc ~package:"vips" with
            | None -> failwith "vips not found"
            | Some deps -> deps)
      in
      C.Flags.write_sexp "c_flags.sexp" conf.cflags;
      C.Flags.write_sexp "c_library_flags.sexp" conf.libs)
