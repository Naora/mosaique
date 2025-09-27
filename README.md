# Mosaique - OCaml bindings for libvips

This project provides OCaml bindings for [libvips](https://libvips.github.io/libvips/), a fast image processing library with low memory needs.

## Features

- Direct C bindings to libvips using OCaml's foreign function interface
- Memory-safe image handling with automatic reference counting
- Basic image operations (load, save, query properties)
- Low-level access to libvips functionality

## Requirements

- OCaml (tested with the version in Ubuntu 24.04)
- Dune build system (>= 3.14)
- libvips development libraries
- pkg-config

## Installation

### System Dependencies

On Ubuntu/Debian:
```bash
sudo apt update
sudo apt install libvips-dev pkg-config ocaml-dune
```

### Building

```bash
dune build
```

### Running Examples

```bash
# Simple version check
dune exec examples/vips_version.exe

# Comprehensive test with image loading
dune exec examples/vips_test.exe
```

## Basic Usage

```ocaml
open Vips

(* Initialize VIPS *)
let () = 
  let result = init () in
  if result <> 0 then failwith "Failed to initialize VIPS";

  (* Get version *)
  Printf.printf "VIPS version: %s\n" (version ());

  (* Load an image *)
  let img = Bindings.vips_image_new_from_file "image.jpg" in
  
  (* Query properties *)
  let width = Bindings.vips_image_get_width img in
  let height = Bindings.vips_image_get_height img in
  let bands = Bindings.vips_image_get_bands img in
  
  Printf.printf "Image: %dx%d, %d bands\n" width height bands;
  
  (* Clean up *)
  Bindings.g_object_unref img;
  shutdown ()
```

## API Overview

### Core Module: `Vips`

- `init () -> int` - Initialize libvips (returns 0 on success)
- `shutdown () -> unit` - Clean up libvips
- `version () -> string` - Get version string
- `error_buffer () -> string` - Get last error message
- `error_clear () -> unit` - Clear error buffer

### Bindings Module: `Vips.Bindings`

- `vips_image_new_from_file : string -> vips_image` - Load image from file
- `vips_image_new_memory : unit -> vips_image` - Create new memory image
- `vips_image_get_width : vips_image -> int` - Get image width
- `vips_image_get_height : vips_image -> int` - Get image height  
- `vips_image_get_bands : vips_image -> int` - Get number of bands
- `vips_image_write_to_file : vips_image -> string -> int` - Save image to file
- `g_object_unref : vips_image -> unit` - Release image reference

## Architecture

The bindings are implemented using:

1. **C Stubs** (`vips_stubs.c`) - Direct C interface to libvips
2. **OCaml Bindings** (`vips_bindings.ml`) - External declarations for C functions
3. **Type Definitions** (`vips_types.ml`) - OCaml type definitions
4. **High-level API** (`vips.ml`) - Main user interface

## Memory Management

Images are automatically managed through OCaml's garbage collector and libvips' reference counting system. The C stubs handle proper cleanup when OCaml values are collected.

## Contributing

This is a minimal implementation focusing on core functionality. Contributions are welcome to add:

- More image operations (resize, crop, rotate, etc.)
- Better error handling  
- More comprehensive type definitions
- Additional format support
- Documentation improvements

## License

MIT License - see LICENSE file for details.