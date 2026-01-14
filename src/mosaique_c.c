#include "mosaique_c.h"
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

/* For exception handling */
#define CAML_NAME_SPACE
#include <caml/mlvalues.h>
#include <caml/fail.h>

/* Helper to raise OCaml exception from vips error */
static void raise_vips_error(void) {
    char *vips_err = vips_error_buffer_copy();
    if (vips_err) {
        /* Use a stack buffer to avoid the memory leak.
         * VIPS error messages are typically short. */
        char msg[1024];
        snprintf(msg, sizeof(msg), "%s", vips_err);
        free(vips_err);
        caml_failwith(msg);
    } else {
        caml_failwith("Unknown VIPS error");
    }
}

/* Initialization */
void mosaique_c_init(const char *argv0) {
    if (VIPS_INIT(argv0)) {
        raise_vips_error();
    }
}

void mosaique_c_shutdown(void) {
    vips_shutdown();
}

/* Finalization for custom type */
void vips_image_finalize(VipsImage **img) {
    if (img && *img) {
        g_object_unref(*img);
        *img = NULL;
    }
}

/* Loading */
VipsImage *mosaique_c_load(const char *filename) {
    VipsImage *img = vips_image_new_from_file(filename, NULL);
    if (!img) {
        raise_vips_error();
    }
    return img;
}

/* Saving */
void mosaique_c_save(VipsImage *img, const char *filename) {
    if (vips_image_write_to_file(img, filename, NULL)) {
        raise_vips_error();
    }
}

void mosaique_c_save_webp(VipsImage *img, int quality, const char *filename) {
    if (vips_webpsave(img, filename, "Q", quality, NULL)) {
        raise_vips_error();
    }
}

void mosaique_c_save_jpeg(VipsImage *img, int quality, const char *filename) {
    if (vips_jpegsave(img, filename, "Q", quality, NULL)) {
        raise_vips_error();
    }
}

/* Image properties */
int mosaique_c_width(VipsImage *img) {
    return vips_image_get_width(img);
}

int mosaique_c_height(VipsImage *img) {
    return vips_image_get_height(img);
}

int mosaique_c_bands(VipsImage *img) {
    return vips_image_get_bands(img);
}

/* Transformations */
VipsImage *mosaique_c_resize(VipsImage *img, int width, int height) {
    int img_width = vips_image_get_width(img);
    int img_height = vips_image_get_height(img);
    
    /* Validate dimensions to avoid division by zero */
    if (img_width <= 0 || img_height <= 0) {
        caml_failwith("Invalid image dimensions for resize");
    }
    if (width <= 0 || height <= 0) {
        caml_failwith("Invalid target dimensions for resize");
    }
    
    double hscale = (double)width / img_width;
    double vscale = (double)height / img_height;
    VipsImage *out = NULL;
    
    if (vips_resize(img, &out, hscale, "vscale", vscale, NULL)) {
        raise_vips_error();
    }
    return out;
}

VipsImage *mosaique_c_rotate(VipsImage *img, double angle) {
    VipsImage *out = NULL;
    
    if (vips_rotate(img, &out, angle, NULL)) {
        raise_vips_error();
    }
    return out;
}

VipsImage *mosaique_c_grayscale(VipsImage *img) {
    VipsImage *out = NULL;
    
    if (vips_colourspace(img, &out, VIPS_INTERPRETATION_B_W, NULL)) {
        raise_vips_error();
    }
    return out;
}

VipsImage *mosaique_c_flip(VipsImage *img, int direction) {
    VipsImage *out = NULL;
    
    if (vips_flip(img, &out, direction, NULL)) {
        raise_vips_error();
    }
    return out;
}
