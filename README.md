# Vips - OCaml bindings for libvips

Mosaique provides OCaml bindings for [libvips](https://libvips.github.io/libvips/), a fast image processing library. It allows you to load, manipulate, and save images using OCaml.

## Features

- Load and save images in various formats (PNG, JPEG, WebP, etc.)
- Basic image operations: resize, rotate, flip, grayscale conversion

## Usage

```ocaml
(* Initialize libvips *)
Mosaique.init ();

(* Load an image *)
let img = Mosaique.load "input.jpg" in

(* Get image information *)
Printf.printf "Image: %dx%d pixels, %d bands\n" 
  (Mosaique.width img) (Mosaique.height img) (Mosaique.bands img);

(* Resize the image *)
let resized = Mosaique.resize img 800 600 in

(* Convert to grayscale *)
let gray = Mosaique.grayscale resized in

(* Save the result *)
Mosaique.save gray Mosaique.PNG "output.png";

(* Clean shutdown *)
Mosaique.shutdown ()
```

## Contributing

This is a minimal implementation focused on core image processing operations. Contributions are welcome to expand the API coverage.
