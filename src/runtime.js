///////// TIME_NOW

//Provides: time_now_nanoseconds_since_unix_epoch_or_zero
//Requires: caml_int64_mul, caml_int64_of_float, caml_int64_of_int32
var ms_to_nano = caml_int64_of_int32(1000*1000);
function time_now_nanoseconds_since_unix_epoch_or_zero(){
    var ms = Date.now();
    // multiple by two - int63 integers are shifted to the left
    var ms_i63 = caml_int64_of_float(ms*2);
    // doing the multiplication in int64 space would drop all the values
    // after the decimal point, but because [Date.now()] only provides
    // 1ms resolution anyway, there's never any value after the decimal point.
    return caml_int64_mul(ms_i63,ms_to_nano);
}

//Provides: ms_float_to_ns_int64
//Requires: caml_int64_of_float
function ms_float_to_ns_int64(ms) {
  // multiply by 1_000_000 while still a float so that sub-millisecond
  // values don't get truncated by the float->int conversion.
  return caml_int64_of_float(ms * (1000.0 * 1000.0));
}

/* The reason we can't share all the code between [*_counter_for_timing] and
 * [*_unix_epoch] is because [performance.now()] breaks when the computer goes
 * to sleep, and when a tab is backgrounded.
 * https://github.com/w3c/hr-time/issues/115 */

//Provides: time_now_nanosecond_counter_for_timing
//Requires: caml_int64_add, ms_float_to_ns_int64, caml_int64_shift_left
function time_now_nanosecond_counter_for_timing(){
    var ms_since_program_started = performance.now();
    var ns_since_program_started = ms_float_to_ns_int64(ms_since_program_started);
    // shift left by 1 because in javascript, an int63 is implemented as an
    // int64 with the least significant bit set to zero
    return caml_int64_shift_left(ns_since_program_started, 1);
}
