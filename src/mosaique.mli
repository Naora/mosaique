(** OCaml bindings for libvips image processing library *)

(** {1 Types} *)

type t
(** Opaque type representing a vips image *)

(** Image format for saving *)
type format =
  | JPEG of int  (** JPEG with quality 1-100 *)
  | Auto  (** format is deduced from the filename *)
  | WEBP of int  (** WebP with quality 1-100 *)

type direction = Horizontal | Vertical  (** Direction for flipping *)

(** {1 Transformations} *)

module Transformations : sig
  type t = op list
  (** Type representing a sequence of image transformations *)

  (** Image operation types *)
  and op =
    | Resize of int * int
    | Rotate of float
    | Grayscale
    | Flip of direction

  val grayscale : t -> t
  (** Functions to build a list of transformations *)

  val flip : direction -> t -> t
  (** Flip direction *)

  val rotate : float -> t -> t
  (** Rotate angle in degrees *)

  val resize : width:int -> height:int -> t -> t
  (** Resize to width and height *)
end

(** {1 Core Functions} *)

val shutdown : unit -> unit
(** Shutdown the vips library. Should be called at program exit. *)

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

val resize : t -> width:int -> height:int -> t
(** Resize image to specified width and height *)

val rotate : t -> float -> t
(** Rotate image by specified angle in degrees *)

val grayscale : t -> t
(** Convert image to grayscale *)

val flip : direction -> t -> t
(** Flip image in specified direction *)

val run : t -> Transformations.t -> t
(** Apply a sequence of transformations to an image *)

(** {1 Error Handling} *)

exception Vips_error of string
(** Exception raised by vips operations *)
