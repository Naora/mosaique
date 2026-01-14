# Migration to Camlid Bindings

This document explains the migration from manual C stubs to camlid-generated bindings.

## Overview

The project has been successfully migrated from hand-written OCaml/C bindings to using camlid, a C binding generator for OCaml. This makes the bindings more maintainable and less error-prone.

## What Changed

### Before (Manual Approach)
- **src/mosaique_stubs.c** (281 lines): Hand-written C stubs with CAMLparam/CAMLreturn macros, custom memory management, and all type conversions done manually
- Direct use of OCaml C API throughout

### After (Camlid Approach)

1. **src/mosaique_c.h** (31 lines): Header file declaring clean C wrapper functions
2. **src/mosaique_c.c** (119 lines): Implementation of C wrappers that:
   - Call libvips functions
   - Handle errors via `caml_failwith`
   - Don't use CAMLparam/CAMLreturn (camlid handles that)

3. **src/generator/generator.ml** (36 lines): Camlid DSL description of bindings:
   - Declares custom_ptr type for VipsImage
   - Lists all C functions to bind
   - Specifies parameter types and return types

4. **Generated files** (by camlid at build time):
   - **mosaique_bindings.ml**: OCaml external declarations
   - **mosaique_bindings_stub.c**: C stub functions with all the CAMLparam/CAMLreturn boilerplate

5. **src/mosaique.ml**: Updated to wrap generated bindings and provide the high-level API

## Key Benefits

1. **Maintainability**: Bindings are described declaratively in generator.ml
2. **Less Boilerplate**: Camlid generates all the CAMLparam/CAMLreturn and type conversion code
3. **Type Safety**: Camlid ensures correct type conversions between OCaml and C
4. **Automatic Memory Management**: Custom type with finalizer is handled by camlid's `custom_ptr`
5. **Cleaner C Code**: C wrapper functions are simpler and don't mix OCaml API calls

## Architecture

```
┌─────────────────┐
│ generator.ml    │ (Camlid DSL)
│ describes       │
│ bindings        │
└────────┬────────┘
         │ (generates at build time)
         ├─────────────────┐
         ↓                 ↓
┌─────────────────┐ ┌──────────────────┐
│ mosaique_       │ │ mosaique_        │
│ bindings.ml     │ │ bindings_stub.c  │
│ (OCaml side)    │ │ (C stubs)        │
└────────┬────────┘ └────────┬─────────┘
         │                   │
         │  ┌────────────────┘
         │  │   calls
         ↓  ↓
┌─────────────────┐
│ mosaique_c.c    │ (C wrappers)
│ calls libvips   │
└─────────────────┘
         │
         ↓
┌─────────────────┐
│ libvips         │
└─────────────────┘
```

## Build Process

1. Dune runs `generator.exe` which uses camlid to generate:
   - `mosaique_bindings.ml`
   - `mosaique_bindings_stub.c`

2. These generated files are promoted to the source tree (until-clean mode)

3. The library is built with:
   - `mosaique_c.c` (our C wrappers)
   - `mosaique_bindings_stub.c` (generated stubs)
   - `mosaique.ml` (high-level API)

## Type Safety

Camlid's `custom_ptr` helper ensures that VipsImage pointers are:
- Wrapped in OCaml custom blocks
- Automatically finalized (calling `vips_image_finalize`) when GC'd
- Type-safe (can't be confused with other pointer types)

## Error Handling

C wrapper functions use `caml_failwith()` to raise exceptions when vips operations fail. The exception propagates through the camlid-generated stubs back to OCaml code.

## Testing

After building:
1. The generator will create the stub files
2. Build the library with the generated stubs
3. Run the example: `examples/example_image_processing.exe`

## Future Enhancements

With camlid, it's easier to:
- Add new libvips functions (just add one line in generator.ml)
- Maintain type safety across the FFI boundary
- Update bindings when libvips API changes
