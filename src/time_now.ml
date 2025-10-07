[%%import "config.h"]

open! Base

[%%ifdef JSC_ARCH_AMD64]

external nanoseconds_since_unix_epoch_or_zero
  :  unit
  -> Int63.t
  @@ portable
  = "time_now_nanoseconds_since_unix_epoch_or_zero"
[@@noalloc]

external nanosecond_counter_for_timing
  :  unit
  -> Int63.t
  @@ portable
  = "time_now_nanosecond_counter_for_timing"
[@@noalloc]

[%%else]

external nanoseconds_since_unix_epoch_or_zero
  :  unit
  -> Int63.t
  @@ portable
  = "time_now_nanoseconds_since_unix_epoch_or_zero"

(* Zero_alloc is not required on 32-bit targets, but we need "assume" to satisfy
   [@@zero_alloc] in the interface. *)
let[@zero_alloc assume] [@inline always] nanoseconds_since_unix_epoch_or_zero () =
  nanoseconds_since_unix_epoch_or_zero ()
;;

external nanosecond_counter_for_timing
  :  unit
  -> Int63.t
  @@ portable
  = "time_now_nanosecond_counter_for_timing"

[%%endif]
[%%ifdef JSC_POSIX_TIMERS]

let[@cold] [@zero_alloc] gettime_failed () =
  failwith "clock_gettime(CLOCK_REALTIME) failed"
;;

[%%else]

let[@cold] [@zero_alloc] gettime_failed () = failwith "gettimeofday failed"

[%%endif]

let[@zero_alloc] nanoseconds_since_unix_epoch () =
  let t = nanoseconds_since_unix_epoch_or_zero () in
  if Int63.( <> ) t Int63.zero then t else (gettime_failed [@zero_alloc assume]) ()
;;
