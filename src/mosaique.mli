(** OCaml bindings for libvips image processing library *)

(** {1 Types} *)

type t
(** Opaque type representing a vips image *)

(** Image format for saving *)
type format =
  | JPEG of int  (** JPEG with quality 1-100 *)
  | PNG  (** PNG format *)
  | WEBP of int  (** WebP with quality 1-100 *)

(** {1 Core Functions} *)

val shutdown : unit -> unit
(** Shutdown the vips library. Should be called at program exit. Never load a
    image after
    [shutdown](https://www.libvips.org/API/current/func.shutdown.html). *)

(** {1 Image Loading and Saving} *)

val load : string -> t
(** Load an image from file *)

val save : t -> format -> string -> unit
(** Save an image to file with specified format *)

(** {1 Image Information} *)

val width : t -> int
(** Get image width in pixels *)

val height : t -> int
(** Get image height in pixels *)

val bands : t -> int
(** Get number of bands (channels) in the image *)

(** {1 Image Operations} *)

val resize : t -> int -> int -> t
(** Resize image to specified width and height *)

val rotate : t -> float -> t
(** Rotate image by specified angle in degrees *)

val grayscale : t -> t
(** Convert image to grayscale *)

val flip_horizontal : t -> t
(** Flip image horizontally *)

val flip_vertical : t -> t
(** Flip image vertically *)

(** {1 Error Handling} *)

exception Vips_error of string
(** Exception raised by vips operations *)
