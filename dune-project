(lang dune 3.20)
(cram enable)

(name mosaique)

(generate_opam_files)

(package
 (name mosaique)
 (synopsis "OCaml bindings for libvips image processing library")
 (description "OCaml bindings for libvips providing image loading, saving, and transformation operations")
 (authors "Naora")
 (maintainers "Naora")
 (license MIT)
 (depends
  ocaml
  dune))
