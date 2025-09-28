(lang dune 3.20)
(using ctypes 0.3)

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
  ctypes-foreign
  (conf-pkg-config :build)
  (conf-libvips :build)))
