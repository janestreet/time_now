open! Base

(** Returns the number of nanoseconds that have passed since the unix epoch.

    In Javascript, the resolution of the timestamp returned by this function is 1ms. *)
val nanoseconds_since_unix_epoch : unit -> Int63.t

(** [nanosecond_counter_for_timing] returns the number of nanos since an arbitrary epoch
    that is fixed at program startup. On some platforms the epoch is the unix epoch, and
    on other platforms the epoch is when the program starts running. The resulting
    timestamps are useful when compared to or subtracted from other timestamps produced by
    the same function in the same process. This is intended for use in benchmarks.

    In Javascript, the resolution of the timestamp returned by this function is not
    formally defined, but in practice is significantly higher than the 1ms resolution
    produced by [nanoseconds_since_unix_epoch]. *)
val nanosecond_counter_for_timing : unit -> Int63.t
