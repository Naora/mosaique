#include <vips/vips.h>
#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/custom.h>
#include <caml/fail.h>
#include <caml/callback.h>
#include <string.h>

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

value mosaique_init(value argv0) {
    CAMLparam1(argv0);

    const char *argv0_cstr = String_val(argv0);

    if (VIPS_INIT(argv0_cstr)) {
        vips_error_exit(NULL);
    }
    CAMLreturn(Val_unit);
}

value mosaique_shutdown(value unit) {
    CAMLparam1(unit);
    vips_shutdown();
    CAMLreturn(Val_unit);
}

void mosaique_error() {
    char* buffer = vips_error_buffer_copy();
    size_t len = strlen(buffer)+1;
    char message[len];
    memcpy(message, buffer, len);
    free(buffer);
    caml_failwith(message);
}

value mosaique_load(value filename) {
    CAMLparam1(filename);
    CAMLlocal1(result);
    
    VipsImage *img;
    const char *fname = String_val(filename);
    
    if (!(img = vips_image_new_from_file(fname, NULL))) {
        mosaique_error();
    }
    
    result = alloc_vips_image(img);
    CAMLreturn(result);
}

value mosaique_width(value img_val) {
    CAMLparam1(img_val);
    VipsImage *img = VipsImage_val(img_val);
    CAMLreturn(Val_int(vips_image_get_width(img)));
}

value mosaique_height(value img_val) {
    CAMLparam1(img_val);
    VipsImage *img = VipsImage_val(img_val);
    CAMLreturn(Val_int(vips_image_get_height(img)));
}

value mosaique_bands(value img_val) {
    CAMLparam1(img_val);
    VipsImage *img = VipsImage_val(img_val);
    CAMLreturn(Val_int(vips_image_get_bands(img)));
}

value mosaique_save_stub(value img_val, value filename) {
    CAMLparam2(img_val, filename);
    
    VipsImage *img = VipsImage_val(img_val);
    const char *fname = String_val(filename);
    
    if (vips_image_write_to_file(img, fname, NULL)) {
        mosaique_error();
    }
    
    CAMLreturn(Val_unit);
}

value mosaique_save_webp(value img_val, value webp, value filename) {
    CAMLparam3(img_val, webp, filename);
    
    VipsImage *img = VipsImage_val(img_val);
    const char *fname = String_val(filename);
    int quality = Int_val(webp);
    
    if (vips_webpsave(img, fname, "Q", quality, NULL)) {
        mosaique_error();
    }
    
    CAMLreturn(Val_unit);
}


value mosaique_save_jpeg(value img_val, value jpeg, value filename) {
    CAMLparam3(img_val, jpeg, filename);
    
    VipsImage *img = VipsImage_val(img_val);
    const char *fname = String_val(filename);
    int quality = Int_val(jpeg);
    
    if (vips_jpegsave(img, fname, "Q", quality, NULL)) {
        mosaique_error();
    }
    
    CAMLreturn(Val_unit);
}

VipsImage* resize(VipsImage* img, int width, int height) {
    double hscale = (double)width / vips_image_get_width(img);
    double vscale = (double)height / vips_image_get_height(img);
    VipsImage* out;
    
    if (vips_resize(img, &out, hscale, "vscale", vscale, NULL)) {
        mosaique_error();
    }
    return out;
}

value mosaique_resize(value img_val, value width_val, value height_val) {
    CAMLparam3(img_val, width_val, height_val);
    CAMLlocal1(result);
    
    VipsImage *img = VipsImage_val(img_val);
    VipsImage *out;
    int width = Int_val(width_val);
    int height = Int_val(height_val);

    out = resize(img, width, height);
    
    result = alloc_vips_image(out);
    CAMLreturn(result);
}

VipsImage* rotate(VipsImage* img, double angle) {
    VipsImage* out;
    
    if (vips_rotate(img, &out, angle, NULL)) {
        mosaique_error();
    }
    return out;
}

value mosaique_rotate(value img_val, value angle_val) {
    CAMLparam2(img_val, angle_val);
    CAMLlocal1(result);
    
    VipsImage *img = VipsImage_val(img_val);
    VipsImage *out;
    double angle = Double_val(angle_val);
    
    out = rotate(img, angle);
    
    result = alloc_vips_image(out);
    CAMLreturn(result);
}

VipsImage* grayscale(VipsImage* img) {
    VipsImage* out;
    
    if (vips_colourspace(img, &out, VIPS_INTERPRETATION_B_W, NULL)) {
        mosaique_error();
    }
    return out;
}

value mosaique_grayscale(value img_val) {
    CAMLparam1(img_val);
    CAMLlocal1(result);
    
    VipsImage *img = VipsImage_val(img_val);
    VipsImage *out;
    
    out = grayscale(img);
    
    result = alloc_vips_image(out);
    CAMLreturn(result);
}

int get_direction(value dir) {
    if (!Is_long(dir)) {
        caml_failwith("Direction must be an variant");
    }
    if (dir == Val_int(0)) {
        return VIPS_DIRECTION_HORIZONTAL;
    }
    if (dir == Val_int(1)) {
        return VIPS_DIRECTION_VERTICAL;
    }
    caml_failwith("Invalid direction");
}

VipsImage* flip(VipsImage* img, int direction) {
    VipsImage* out;
    
    if (vips_flip(img, &out, direction, NULL)) {
        mosaique_error();
    }
    return out;
}

value mosaique_flip(value img_val, value direction_val) {
    CAMLparam2(img_val, direction_val);
    CAMLlocal1(result);
    
    VipsImage *img = VipsImage_val(img_val);
    VipsImage *out;

    int direction = get_direction(direction_val);
    out = flip(img, direction);
    
    result = alloc_vips_image(out);
    CAMLreturn(result);
}

value mosaique_run(value img_val, value pipeline) {
    CAMLparam2(img_val, pipeline);
    CAMLlocal2(current_list, result);

    current_list = pipeline;
    VipsImage *img = VipsImage_val(img_val);

    while(current_list != Val_emptylist) {
        value head = Field(current_list, 0);
        if (Is_block(head)) {
            int tag = Tag_val(head);
            switch(tag) {
                case 0: // Resize of int * int
                    int width = Int_val(Field(head, 0));
                    int height = Int_val(Field(head, 1));
                    img = resize(img, width, height);
                break;
                case 1: // Rotate of float
                    double angle = Double_val(Field(head, 0));
                    img = rotate(img, angle);
                break;
                case 2: // Flip of direction
                    value direction_val = Field(head, 0);
                    int direction = get_direction(direction_val);
                    img = flip(img, direction);
                break;
            }
        } else {
            if (head == Val_int(0)) { // Grayscale
                img = grayscale(img);
            }
        }

        current_list = Field(current_list, 1);
    } 
    result = alloc_vips_image(img);
    CAMLreturn(result);
}
