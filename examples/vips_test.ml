(* More comprehensive example with image operations *)

open Vips

let test_image_info filename =
  try
    Printf.printf "Loading image: %s\n" filename;
    let img = Bindings.vips_image_new_from_file filename in
    let width = Bindings.vips_image_get_width img in
    let height = Bindings.vips_image_get_height img in
    let bands = Bindings.vips_image_get_bands img in
    Printf.printf "  Dimensions: %dx%d, Bands: %d\n" width height bands;
    Bindings.g_object_unref img;
    true
  with
  | Failure msg -> 
    Printf.printf "  Failed: %s\n" msg;
    Printf.printf "  Error: %s\n" (error_buffer ());
    error_clear ();
    false

let () =
  (* Initialize VIPS *)
  let result = init () in
  if result <> 0 then (
    Printf.printf "Failed to initialize VIPS: %d\n" result;
    Printf.printf "Error: %s\n" (error_buffer ());
    exit 1
  );
  
  Printf.printf "VIPS initialized successfully. Version: %s\n" (version ());
  
  (* Create a small test image file for demonstration *)
  Printf.printf "\nTesting image creation...\n";
  let test_img = Bindings.vips_image_new_memory () in
  Printf.printf "Created memory image\n";
  Bindings.g_object_unref test_img;
  
  (* Test with common system paths that might have images *)
  let test_files = [
    "/usr/share/pixmaps/debian-logo.png";
    "/usr/share/pixmaps/accessibility.xpm";
  ] in
  
  Printf.printf "\nTesting image loading...\n";
  List.iter (fun filename ->
    if Sys.file_exists filename then
      ignore (test_image_info filename)
    else
      Printf.printf "File not found: %s\n" filename
  ) test_files;
  
  (* Clean up *)
  shutdown ();
  Printf.printf "\nVIPS comprehensive test completed successfully!\n"