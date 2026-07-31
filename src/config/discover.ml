module C = Configurator.V1

let () =
  C.main ~name:"c_flags" (fun c ->
      let flags =
        match C.ocaml_config_var c "ccomp_type" with
        | Some "msvc" -> ["-std:c11"; "-experimental:c11atomics"]
        | _ -> ["-std=c11"; "-fPIC"]
      in
      C.Flags.write_sexp "c_flags.sexp" flags)
