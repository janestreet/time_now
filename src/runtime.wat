(module
   (import "env" "caml_js_global"
      (func $caml_js_global (param (ref eq)) (result (ref eq))))
   (import "env" "caml_js_get"
      (func $caml_js_get (param (ref eq)) (param (ref eq)) (result (ref eq))))
   (import "env" "caml_js_to_float"
      (func $caml_js_to_float (param (ref eq)) (result (ref eq))))
   (import "env" "caml_js_meth_call"
      (func $caml_js_meth_call
         (param (ref eq)) (param (ref eq)) (param (ref eq)) (result (ref eq))))
   (import "env" "unix_gettimeofday"
      (func $unix_gettimeofday (param (ref eq)) (result (ref eq))))
   (import "env" "caml_copy_int64"
      (func $caml_copy_int64 (param i64) (result (ref eq))))

   (type $block (array (mut (ref eq))))
   (type $string (array (mut i8)))
   (type $float (struct (field f64)))

   (func (export "time_now_nanoseconds_since_unix_epoch_or_zero")
      (param (ref eq)) (result (ref eq))
      (return_call $caml_copy_int64
         (i64.trunc_sat_f64_s
            (f64.mul
               (struct.get $float 0
                  (ref.cast (ref $float)
                     (call $unix_gettimeofday (ref.i31 (i32.const 0)))))
               ;; an int63 is implemented as an int64 with the least significant bit set
               ;; to zero. unix_gettimeofday is ms epoch artificially truncated to seconds.
               ;; 2 is for shift left and 9 is for s->ns.
               (f64.const 2e9)))))

   (data $performance "performance")
   (data $now "now")

   ;; consider sharing strategy with time_stamp_counter
   (func (export "time_now_nanosecond_counter_for_timing") (param (ref eq)) (result (ref eq))
      (call $caml_copy_int64
         (i64.trunc_sat_f64_s
            (f64.mul
               ;; an int63 is implemented as an int64 with the least significant bit set
               ;; to zero. 2 is for shift left and 6 is for ms->nano (performance.now
               ;; returns ms as a floating point number, which allows fidelity to be
               ;; higher).
               (f64.const 2e6)
               (struct.get $float 0
                  (ref.cast (ref $float)
                     (call $caml_js_to_float
                        (call $caml_js_meth_call
                           (call $caml_js_get
                              (call $caml_js_global (ref.i31 (i32.const 0)))
                              (array.new_data $string $performance
                                 (i32.const 0) (i32.const 11)))
                           (array.new_data $string $now
                              (i32.const 0) (i32.const 3))
                           (array.new_fixed $block 1
                              (ref.i31 (i32.const 0)))))))))))
)
