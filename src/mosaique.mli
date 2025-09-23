(** OCaml bindings for libvips image processing library *)

(** {1 Types} *)

(** Opaque type representing a vips image *)
type image

(** Image format for saving *)
type format = 
  | JPEG of int (** JPEG with quality 1-100 *)
  | PNG        (** PNG format *)
  | WEBP of int (** WebP with quality 1-100 *)

(** {1 Core Functions} *)

(** Initialize the vips library. Must be called before any other functions. *)
val init : unit -> unit

(** Shutdown the vips library. Should be called at program exit. *)
val shutdown : unit -> unit

(** {1 Image Loading and Saving} *)

(** Load an image from file *)
val load : string -> image

(** Save an image to file with specified format *)
val save : image -> format -> string -> unit

(** {1 Image Information} *)

(** Get image width in pixels *)
val width : image -> int

(** Get image height in pixels *)
val height : image -> int

(** Get number of bands (channels) in the image *)
val bands : image -> int

(** {1 Image Operations} *)

(** Resize image to specified width and height *)
val resize : image -> int -> int -> image

(** Rotate image by specified angle in degrees *)
val rotate : image -> float -> image

(** Convert image to grayscale *)
val grayscale : image -> image

(** Flip image horizontally *)
val flip_horizontal : image -> image

(** Flip image vertically *)
val flip_vertical : image -> image

(** {1 Error Handling} *)

(** Exception raised by vips operations *)
exception Vips_error of string