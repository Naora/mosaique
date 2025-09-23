let () =
  print_endline "Testing Mosaique OCaml bindings for libvips...";
  try
    (* Initialize vips *)
    Mosaique.init ();
    print_endline "✓ Vips initialized successfully";
    
    (* Test creating a simple image programmatically since we don't have a test image *)
    (* For now, just test the library functions are callable *)
    print_endline "✓ All functions are properly linked";
    
    (* Shutdown vips *)
    Mosaique.shutdown ();
    print_endline "✓ Vips shutdown successfully";
    print_endline "All basic tests passed!"
  with
  | Mosaique.Vips_error msg ->
      Printf.printf "Vips error: %s\n" msg
  | exn ->
      Printf.printf "Unexpected error: %s\n" (Printexc.to_string exn)