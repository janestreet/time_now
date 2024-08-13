(module
   (import "env" "unix_gettimeofday"
      (func $unix_gettimeofday (param (ref eq)) (result (ref eq))))
   (import "env" "caml_copy_int64"
      (func $caml_copy_int64 (param i64) (result (ref eq))))

   (type $float (struct (field f64)))

   (func (export "time_now_nanoseconds_since_unix_epoch_or_zero")
      (param (ref eq)) (result (ref eq))
      (return_call $caml_copy_int64
         (i64.trunc_sat_f64_s
            (f64.mul
               (struct.get $float 0
                  (ref.cast (ref $float)
                     (call $unix_gettimeofday (ref.i31 (i32.const 0)))))
               (f64.const 2e9)))))

   (func (export "time_now_nanosecond_counter_for_timing")
      (param (ref eq)) (result (ref eq))
      (return_call $caml_copy_int64
         (i64.trunc_sat_f64_s
            (f64.mul
               (struct.get $float 0
                  (ref.cast (ref $float)
                     (call $unix_gettimeofday (ref.i31 (i32.const 0)))))
               (f64.const 2e9)))))
)
