(lang dune 3.0)

(name mosaique)

(package
 (name mosaique)
 (synopsis "OCaml bindings for libvips image processing library")
 (description "OCaml bindings for libvips providing image loading, saving, and transformation operations")
 (authors "Naora")
 (maintainers "Naora")
 (license MIT)
 (depends
  ocaml
  dune
  (conf-pkg-config :build)
  (conf-libvips :build)))