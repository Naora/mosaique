#include <vips/vips.h>
#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/fail.h>
#include <caml/callback.h>
#include <caml/custom.h>

/* Custom block for VipsImage */
#define VipsImage_val(v) (*((VipsImage **) Data_custom_val(v)))

static void finalize_vips_image(value v) {
    VipsImage *image = VipsImage_val(v);
    if (image != NULL) {
        g_object_unref(image);
    }
}

static struct custom_operations vips_image_ops = {
    "vips_image",
    finalize_vips_image,
    custom_compare_default,
    custom_hash_default,
    custom_serialize_default,
    custom_deserialize_default,
    custom_compare_ext_default,
    custom_fixed_length_default
};

/* Convert VipsImage to OCaml value */
static value alloc_vips_image(VipsImage *image) {
    value v = caml_alloc_custom(&vips_image_ops, sizeof(VipsImage *), 0, 1);
    VipsImage_val(v) = image;
    return v;
}

/* Library initialization */
value ocaml_vips_init(value prog_name) {
    CAMLparam1(prog_name);
    int result = VIPS_INIT(String_val(prog_name));
    CAMLreturn(Val_int(result));
}

value ocaml_vips_shutdown(value unit) {
    CAMLparam1(unit);
    vips_shutdown();
    CAMLreturn(Val_unit);
}

/* Version information */
value ocaml_vips_version_string(value unit) {
    CAMLparam1(unit);
    CAMLreturn(caml_copy_string(vips_version_string()));
}

value ocaml_vips_version(value n) {
    CAMLparam1(n);
    CAMLreturn(Val_int(vips_version(Int_val(n))));
}

/* Error handling */
value ocaml_vips_error_buffer(value unit) {
    CAMLparam1(unit);
    const char *error = vips_error_buffer();
    CAMLreturn(caml_copy_string(error ? error : ""));
}

value ocaml_vips_error_clear(value unit) {
    CAMLparam1(unit);
    vips_error_clear();
    CAMLreturn(Val_unit);
}

/* Image creation */
value ocaml_vips_image_new(value unit) {
    CAMLparam1(unit);
    VipsImage *image = vips_image_new();
    if (!image) {
        caml_failwith("Failed to create new image");
    }
    CAMLreturn(alloc_vips_image(image));
}

value ocaml_vips_image_new_memory(value unit) {
    CAMLparam1(unit);
    VipsImage *image = vips_image_new_memory();
    if (!image) {
        caml_failwith("Failed to create new memory image");
    }
    CAMLreturn(alloc_vips_image(image));
}

value vips_image_new_from_file_stub(value filename) {
    CAMLparam1(filename);
    VipsImage *image = vips_image_new_from_file(String_val(filename), NULL);
    if (!image) {
        caml_failwith("Failed to load image from file");
    }
    CAMLreturn(alloc_vips_image(image));
}

/* Image properties */
value ocaml_vips_image_get_width(value image) {
    CAMLparam1(image);
    VipsImage *img = VipsImage_val(image);
    CAMLreturn(Val_int(vips_image_get_width(img)));
}

value ocaml_vips_image_get_height(value image) {
    CAMLparam1(image);
    VipsImage *img = VipsImage_val(image);
    CAMLreturn(Val_int(vips_image_get_height(img)));
}

value ocaml_vips_image_get_bands(value image) {
    CAMLparam1(image);
    VipsImage *img = VipsImage_val(image);
    CAMLreturn(Val_int(vips_image_get_bands(img)));
}

/* Image I/O */
value vips_image_write_to_file_stub(value image, value filename) {
    CAMLparam2(image, filename);
    VipsImage *img = VipsImage_val(image);
    int result = vips_image_write_to_file(img, String_val(filename), NULL);
    CAMLreturn(Val_int(result));
}

/* Object reference counting */
value ocaml_g_object_unref(value image) {
    CAMLparam1(image);
    VipsImage *img = VipsImage_val(image);
    g_object_unref(img);
    CAMLreturn(Val_unit);
}