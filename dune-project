(lang dune 3.20)

(name mosaique)

(source (github Naora/mosaique))

(authors "Joris Gundermann")
(maintainers "Joris Gundermann")

(homepage "github.com/Naora/mosaique")
(bug_reports "github.com/Naora/mosaique/issues")

(license MIT)

(generate_opam_files)

(package
 (name mosaique)
 (synopsis "OCaml bindings for libvips image processing library")
 (description "OCaml bindings for libvips providing image loading, saving, and transformation operations")
 (depends
  (ocaml (>= "5.0"))
  dune-configurator
  conf-vips
  dune))
