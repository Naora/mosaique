let () =
  print_endline "=== Mosaique OCaml libvips Example ===";
  let base = "examples" in
  let assets_dir = Filename.concat base "assets" in
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
    Mosaique.save resized Mosaique.Auto
    @@ Filename.concat output_dir "resized_image.png";
    print_endline "Saved resized image to resized_image.png";

    (* Convert to grayscale *)
    let gray = Mosaique.grayscale img in
    Mosaique.save gray Mosaique.Auto
    @@ Filename.concat output_dir "grayscale_image.png";
    print_endline "Saved grayscale image to grayscale_image.png";

    (* Flip horizontally *)
    let flipped = Mosaique.flip Horizontal img in
    Mosaique.save flipped Mosaique.Auto
    @@ Filename.concat output_dir "flipped_image.png";
    print_endline "Saved horizontally flipped image to flipped_image.png";

    (* FLIP vertically *)
    let vflipped = Mosaique.flip Vertical img in
    Mosaique.save vflipped Mosaique.Auto
    @@ Filename.concat output_dir "vflipped_image.png";
    print_endline "Saved vertically flipped image to vflipped_image.png";

    (* Rotate image *)
    let rotated = Mosaique.rotate img 45.0 in
    Mosaique.save rotated Mosaique.Auto
    @@ Filename.concat output_dir "rotated_image.png";
    print_endline "Saved 45° rotated image to rotated_image.png";

    Mosaique.save img (Mosaique.WEBP 100)
    @@ Filename.concat output_dir "lena.webp";
    print_endline "Saved original image as WebP to lena.webp";

    Mosaique.save img (Mosaique.WEBP 30)
    @@ Filename.concat output_dir "lena-low.webp";
    print_endline "Saved original image as a low quality WebP to lena-low.webp";

    (* Combine multiple transformations *)
    let ops =
      let open Mosaique.Transformations in
      []
      |> resize ~width:200 ~height:200
      |> rotate 30.0 |> grayscale |> flip Horizontal
    in
    let transformed = Mosaique.run img ops in
    Mosaique.save transformed Mosaique.Auto
    @@ Filename.concat output_dir "transformed_image.png";
    print_endline "Saved transformed image to transformed_image.png";

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
