(* VIPS types *)

(* Main image type - abstract *)
type vips_image = Vips_bindings.vips_image

(* Basic result handling *)
type vips_result = int
let vips_success = 0

(* Band format constants *)
type vips_band_format = int
let vips_format_notset = -1
let vips_format_uchar = 0
let vips_format_char = 1
let vips_format_ushort = 2
let vips_format_short = 3
let vips_format_uint = 4
let vips_format_int = 5
let vips_format_float = 6
let vips_format_complex = 7
let vips_format_double = 8
let vips_format_dpcomplex = 9

(* Interpretation constants *)
type vips_interpretation = int
let vips_interpretation_error = -1
let vips_interpretation_multiband = 0
let vips_interpretation_b_w = 1
let vips_interpretation_histogram = 2
let vips_interpretation_xyz = 3
let vips_interpretation_lab = 4
let vips_interpretation_cmyk = 5
let vips_interpretation_labq = 6
let vips_interpretation_rgb = 7
let vips_interpretation_cmc = 8
let vips_interpretation_lch = 9
let vips_interpretation_labs = 10
let vips_interpretation_srgb = 11
let vips_interpretation_yuv = 12
let vips_interpretation_rgb16 = 13
let vips_interpretation_grey16 = 14
let vips_interpretation_matrix = 15
let vips_interpretation_scrgb = 16
let vips_interpretation_hsv = 17