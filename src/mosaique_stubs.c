#include <vips/vips.h>
#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/custom.h>
#include <caml/fail.h>
#include <caml/callback.h>

/* Custom block for VipsImage */
#define VipsImage_val(v) (*((VipsImage **) Data_custom_val(v)))

static void vips_image_finalize(value v) {
    VipsImage *img = VipsImage_val(v);
    if (img != NULL) {
        g_object_unref(img);
    }
}

static struct custom_operations vips_image_ops = {
    "vips_image",
    vips_image_finalize,
    custom_compare_default,
    custom_hash_default,
    custom_serialize_default,
    custom_deserialize_default,
    custom_compare_ext_default,
    custom_fixed_length_default
};

static value alloc_vips_image(VipsImage *img) {
    value v = caml_alloc_custom(&vips_image_ops, sizeof(VipsImage *), 0, 1);
    VipsImage_val(v) = img;
    return v;
}

/* Shutdown vips */
value mosaique_shutdown(value unit) {
    CAMLparam1(unit);
    vips_shutdown();
    CAMLreturn(Val_unit);
}

/* Load image from file */
value mosaique_load(value filename) {
    if (VIPS_INIT("mosaique")) {
        vips_error_exit(NULL);
    }

    CAMLparam1(filename);
    CAMLlocal1(result);
    
    VipsImage *img;
    const char *fname = String_val(filename);
    
    if (!(img = vips_image_new_from_file(fname, NULL))) {
        caml_failwith(vips_error_buffer());
        vips_error_clear();
    }
    
    result = alloc_vips_image(img);
    CAMLreturn(result);
}

/* Get image width */
value mosaique_width(value img_val) {
    CAMLparam1(img_val);
    VipsImage *img = VipsImage_val(img_val);
    CAMLreturn(Val_int(vips_image_get_width(img)));
}

/* Get image height */
value mosaique_height(value img_val) {
    CAMLparam1(img_val);
    VipsImage *img = VipsImage_val(img_val);
    CAMLreturn(Val_int(vips_image_get_height(img)));
}

/* Get image bands */
value mosaique_bands(value img_val) {
    CAMLparam1(img_val);
    VipsImage *img = VipsImage_val(img_val);
    CAMLreturn(Val_int(vips_image_get_bands(img)));
}

/* Save image to file */
value mosaique_save_stub(value img_val, value filename) {
    CAMLparam2(img_val, filename);
    
    VipsImage *img = VipsImage_val(img_val);
    const char *fname = String_val(filename);
    
    /* Simple save - format determined by extension */
    if (vips_image_write_to_file(img, fname, NULL)) {
        caml_failwith(vips_error_buffer());
        vips_error_clear();
    }
    
    CAMLreturn(Val_unit);
}

/* Save webp to file */
value mosaique_save_webp(value img_val, value webp, value filename) {
    CAMLparam3(img_val, webp, filename);
    
    VipsImage *img = VipsImage_val(img_val);
    const char *fname = String_val(filename);
    int quality = Int_val(webp);
    
    /* Simple save - format determined by extension */
    if (vips_webpsave(img, fname, "Q", quality, NULL)) {
        caml_failwith(vips_error_buffer());
        vips_error_clear();
    }
    
    CAMLreturn(Val_unit);
}


/* Save jpeg to file */
value mosaique_save_jpeg(value img_val, value jpeg, value filename) {
    CAMLparam3(img_val, jpeg, filename);
    
    VipsImage *img = VipsImage_val(img_val);
    const char *fname = String_val(filename);
    int quality = Int_val(jpeg);
    
    /* Simple save - format determined by extension */
    if (vips_jpegsave(img, fname, "Q", quality, NULL)) {
        caml_failwith(vips_error_buffer());
        vips_error_clear();
    }
    
    CAMLreturn(Val_unit);
}

/* Resize image */
value mosaique_resize(value img_val, value width_val, value height_val) {
    CAMLparam3(img_val, width_val, height_val);
    CAMLlocal1(result);
    
    VipsImage *img = VipsImage_val(img_val);
    VipsImage *out;
    int width = Int_val(width_val);
    int height = Int_val(height_val);
    
    double hscale = (double)width / vips_image_get_width(img);
    double vscale = (double)height / vips_image_get_height(img);
    
    if (vips_resize(img, &out, hscale, "vscale", vscale, NULL)) {
        caml_failwith(vips_error_buffer());
        vips_error_clear();
    }
    
    result = alloc_vips_image(out);
    CAMLreturn(result);
}

/* Rotate image */
value mosaique_rotate(value img_val, value angle_val) {
    CAMLparam2(img_val, angle_val);
    CAMLlocal1(result);
    
    VipsImage *img = VipsImage_val(img_val);
    VipsImage *out;
    double angle = Double_val(angle_val);
    
    if (vips_rotate(img, &out, angle, NULL)) {
        caml_failwith(vips_error_buffer());
        vips_error_clear();
    }
    
    result = alloc_vips_image(out);
    CAMLreturn(result);
}

/* Convert to grayscale */
value mosaique_grayscale(value img_val) {
    CAMLparam1(img_val);
    CAMLlocal1(result);
    
    VipsImage *img = VipsImage_val(img_val);
    VipsImage *out;
    
    if (vips_colourspace(img, &out, VIPS_INTERPRETATION_B_W, NULL)) {
        caml_failwith(vips_error_buffer());
        vips_error_clear();
    }
    
    result = alloc_vips_image(out);
    CAMLreturn(result);
}

/* Flip horizontal */
value mosaique_flip_horizontal(value img_val) {
    CAMLparam1(img_val);
    CAMLlocal1(result);
    
    VipsImage *img = VipsImage_val(img_val);
    VipsImage *out;
    
    if (vips_flip(img, &out, VIPS_DIRECTION_HORIZONTAL, NULL)) {
        caml_failwith(vips_error_buffer());
        vips_error_clear();
    }
    
    result = alloc_vips_image(out);
    CAMLreturn(result);
}

/* Flip vertical */
value mosaique_flip_vertical(value img_val) {
    CAMLparam1(img_val);
    CAMLlocal1(result);
    
    VipsImage *img = VipsImage_val(img_val);
    VipsImage *out;
    
    if (vips_flip(img, &out, VIPS_DIRECTION_VERTICAL, NULL)) {
        caml_failwith(vips_error_buffer());
        vips_error_clear();
    }
    
    result = alloc_vips_image(out);
    CAMLreturn(result);
}
