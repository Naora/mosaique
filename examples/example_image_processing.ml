let () =
  print_endline "=== Mosaique OCaml libvips Example ===";
  
  try
    (* Initialize vips *)
    Mosaique.init ();
    print_endline "Initialized libvips";
    
    (* Load test image *)
    let img = Mosaique.load "test/assets/test_image.png" in
    Printf.printf "Loaded image: %dx%d pixels, %d bands\n" 
      (Mosaique.width img) (Mosaique.height img) (Mosaique.bands img);
    
    (* Resize the image *)
    let resized = Mosaique.resize img 100 100 in
    Printf.printf "Resized to: %dx%d pixels\n" 
      (Mosaique.width resized) (Mosaique.height resized);
    
    (* Save the resized image *)
    Mosaique.save resized Mosaique.PNG "test/assets/resized_image.png";
    print_endline "Saved resized image to test/assets/resized_image.png";
    
    (* Convert to grayscale *)
    let gray = Mosaique.grayscale img in
    Mosaique.save gray Mosaique.PNG "test/assets/grayscale_image.png";
    print_endline "Saved grayscale image to test/assets/grayscale_image.png";
    
    (* Flip horizontally *)
    let flipped = Mosaique.flip_horizontal img in
    Mosaique.save flipped Mosaique.PNG "test/assets/flipped_image.png";
    print_endline "Saved horizontally flipped image to test/assets/flipped_image.png";
    
    (* Rotate image *)
    let rotated = Mosaique.rotate img 45.0 in
    Mosaique.save rotated Mosaique.PNG "test/assets/rotated_image.png";
    print_endline "Saved 45° rotated image to test/assets/rotated_image.png";
    
    (* Shutdown vips *)
    Mosaique.shutdown ();
    print_endline "\n=== All operations completed successfully! ===";
    
  with
  | Mosaique.Vips_error msg ->
      Printf.printf "Vips error: %s\n" msg;
      exit 1
  | exn ->
      Printf.printf "Unexpected error: %s\n" (Printexc.to_string exn);
      exit 1