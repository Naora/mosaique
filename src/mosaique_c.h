#ifndef MOSAIQUE_C_H
#define MOSAIQUE_C_H

#include <vips/vips.h>
#include <stdint.h>

/* Initialization and cleanup */
void mosaique_c_init(const char *argv0);
void mosaique_c_shutdown(void);

/* VipsImage finalization for camlid custom type */
void vips_image_finalize(VipsImage **img);

/* Loading and saving */
VipsImage *mosaique_c_load(const char *filename);
void mosaique_c_save(VipsImage *img, const char *filename);
void mosaique_c_save_webp(VipsImage *img, int quality, const char *filename);
void mosaique_c_save_jpeg(VipsImage *img, int quality, const char *filename);

/* Image properties */
int mosaique_c_width(VipsImage *img);
int mosaique_c_height(VipsImage *img);
int mosaique_c_bands(VipsImage *img);

/* Transformations */
VipsImage *mosaique_c_resize(VipsImage *img, int width, int height);
VipsImage *mosaique_c_rotate(VipsImage *img, double angle);
VipsImage *mosaique_c_grayscale(VipsImage *img);
VipsImage *mosaique_c_flip(VipsImage *img, int direction);

#endif /* MOSAIQUE_C_H */
