(lang dune 3.14)

(name mosaique)

(authors "Naora")

(maintainers "Naora")

(license "MIT")

(package
 (name mosaique)
 (synopsis "OCaml bindings for libvips")
 (description "OCaml bindings for libvips using ctypes")
 (depends
  ocaml
  dune
  ctypes
  ctypes-foreign)
 (tags
  ("image processing" "libvips" "ctypes")))