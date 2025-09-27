(* Example using the high-level Image API *)

open Vips

let test_image_with_api filename =
  try
    Printf.printf "Loading image: %s\n" filename;
    Image.with_image (Image.new_from_file filename) (fun img ->
      let width, height = Image.dimensions img in
      let bands = Image.bands img in
      Printf.printf "  Dimensions: %dx%d, Bands: %d\n" width height bands;
    );
    true
  with
  | Vips_error msg -> 
    Printf.printf "  Error: %s\n" msg;
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
  
  (* Test with common system paths that might have images *)
  let test_files = [
    "/usr/share/pixmaps/debian-logo.png";
    "/usr/share/pixmaps/gtk-floppy.png";
  ] in
  
  Printf.printf "\nTesting high-level Image API...\n";
  List.iter (fun filename ->
    if Sys.file_exists filename then
      ignore (test_image_with_api filename)
    else
      Printf.printf "File not found: %s\n" filename
  ) test_files;
  
  (* Test memory image creation *)
  Printf.printf "\nTesting memory image creation...\n";
  (try
    Image.with_image (Image.new_memory ()) (fun _img ->
      Printf.printf "Created memory image successfully\n"
    )
  with
    | Vips_error msg -> Printf.printf "Failed to create memory image: %s\n" msg
  );
  
  (* Clean up *)
  shutdown ();
  Printf.printf "\nHigh-level API test completed successfully!\n"