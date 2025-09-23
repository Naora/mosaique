# Mosaique - OCaml bindings for libvips

Mosaique provides OCaml bindings for [libvips](https://libvips.github.io/libvips/), a fast image processing library. It allows you to load, manipulate, and save images using OCaml in a memory-efficient way.

## Features

- Load and save images in various formats (PNG, JPEG, WebP, etc.)
- Basic image operations: resize, rotate, flip, grayscale conversion
- Memory-efficient processing using libvips streaming
- Clean OCaml API with proper error handling

## Prerequisites

You need to have libvips development headers installed on your system:

### Ubuntu/Debian
```bash
sudo apt install libvips-dev pkg-config
```

### macOS
```bash
brew install vips pkg-config
```

## Building

The project uses [Dune](https://dune.build/) for building:

```bash
# Install OCaml and Dune if needed
sudo apt install ocaml ocaml-dune

# Build the library
dune build

# Run tests
dune exec test/test_mosaique.exe

# Run examples
dune exec examples/example_image_processing.exe
```

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

## API Reference

### Core Functions

- `Mosaique.init : unit -> unit` - Initialize libvips (required)
- `Mosaique.shutdown : unit -> unit` - Shutdown libvips (recommended)

### Image Loading/Saving

- `Mosaique.load : string -> image` - Load image from file
- `Mosaique.save : image -> format -> string -> unit` - Save image to file

### Image Information

- `Mosaique.width : image -> int` - Get image width
- `Mosaique.height : image -> int` - Get image height  
- `Mosaique.bands : image -> int` - Get number of bands (channels)

### Image Operations

- `Mosaique.resize : image -> int -> int -> image` - Resize to specified dimensions
- `Mosaique.rotate : image -> float -> image` - Rotate by degrees
- `Mosaique.grayscale : image -> image` - Convert to grayscale
- `Mosaique.flip_horizontal : image -> image` - Flip horizontally
- `Mosaique.flip_vertical : image -> image` - Flip vertically

### Image Formats

- `Mosaique.PNG` - PNG format
- `Mosaique.JPEG of int` - JPEG with quality (1-100)
- `Mosaique.WEBP of int` - WebP with quality (1-100)

## Error Handling

All functions may raise `Mosaique.Vips_error of string` on failure. It's recommended to wrap operations in try-catch blocks:

```ocaml
try
  let img = Mosaique.load "nonexistent.jpg" in
  (* ... *)
with
| Mosaique.Vips_error msg ->
    Printf.printf "Image processing error: %s\n" msg
```

## License

MIT License - see LICENSE file for details.

## Contributing

This is a minimal implementation focused on core image processing operations. Contributions are welcome to expand the API coverage.