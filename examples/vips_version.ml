(* Simple example to test VIPS bindings *)

open Vips

let () =
  (* Initialize VIPS *)
  let result = init () in
  if result <> 0 then (
    Printf.printf "Failed to initialize VIPS: %d\n" result;
    Printf.printf "Error: %s\n" (error_buffer ());
    exit 1
  );
  
  (* Print version information *)
  Printf.printf "VIPS version: %s\n" (version ());
  
  (* Clean up *)
  shutdown ();
  Printf.printf "VIPS bindings working correctly!\n"