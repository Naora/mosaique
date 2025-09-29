let () =
  print_endline "=== Mosaique OCaml libvips Example ===";
  let base = "examples" in
  let assets_dir = "assets" in
  let output_dir = Filename.concat base "output" in

  try
    (* Load test image *)
    let img = Mosaique.load @@ Filename.concat assets_dir "lena.jpg" in
    Printf.printf "Loaded image: %dx%d pixels, %d bands\n" (Mosaique.width img)
      (Mosaique.height img) (Mosaique.bands img);

    (* Resize the image *)
    let resized = Mosaique.resize img ~width:100 ~height:100 in
    Printf.printf "Resized to: %dx%d pixels\n" (Mosaique.width resized)
      (Mosaique.height resized);

    (* Save the resized image *)
    Mosaique.save resized Mosaique.PNG
    @@ Filename.concat output_dir "resized_image.png";
    print_endline "Saved resized image to resized_image.png";

    (* Convert to grayscale *)
    let gray = Mosaique.grayscale img in
    Mosaique.save gray Mosaique.PNG
    @@ Filename.concat output_dir "grayscale_image.png";
    print_endline "Saved grayscale image to grayscale_image.png";

    (* Flip horizontally *)
    let flipped = Mosaique.flip_horizontal img in
    Mosaique.save flipped Mosaique.PNG
    @@ Filename.concat output_dir "flipped_image.png";
    print_endline "Saved horizontally flipped image to flipped_image.png";

    (* Rotate image *)
    let rotated = Mosaique.rotate img 45.0 in
    Mosaique.save rotated Mosaique.PNG
    @@ Filename.concat output_dir "rotated_image.png";
    print_endline "Saved 45° rotated image to rotated_image.png";

    Mosaique.save img (Mosaique.WEBP 100)
    @@ Filename.concat output_dir "lena.webp";
    print_endline "Saved original image as WebP to lena.webp";

    Mosaique.save img (Mosaique.WEBP 30)
    @@ Filename.concat output_dir "lena-low.webp";
    print_endline "Saved original image as a low quality WebP to lena-low.webp";

    (* Shutdown vips *)
    Mosaique.shutdown ();
    print_endline "\n=== All operations completed successfully! ==="
  with
  | Mosaique.Vips_error msg ->
      Printf.printf "Vips error: %s\n" msg;
      exit 1
  | exn ->
      Printf.printf "Unexpected error: %s\n" (Printexc.to_string exn);
      exit 1
