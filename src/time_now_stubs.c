#include "config.h"
#include "ocaml_utils.h"
#include <caml/memory.h>
#include <time.h>

#define NANOS_PER_SECOND 1000000000

#if defined(JSC_TIMESPEC)

/* Note: this is imported noalloc if (and only if) ARCH_SIXTYFOUR is defined.
 * This is OK because caml_alloc_int63 doesn't actually allocate in that case.
 */
CAMLprim value time_now_nanoseconds_since_unix_epoch_or_zero() {
  struct timespec ts;

  if (timespec_get(&ts, TIME_UTC) != TIME_UTC)
    return caml_alloc_int63(0);
  else
    return caml_alloc_int63(NANOS_PER_SECOND * (uint64_t)ts.tv_sec +
                            (uint64_t)ts.tv_nsec);
}

#else

#ifndef _MSC_VER

#include <sys/time.h>
#include <sys/types.h>

CAMLprim value time_now_nanoseconds_since_unix_epoch_or_zero() {
  struct timeval tp;
  if (gettimeofday(&tp, NULL) == -1)
    return caml_alloc_int63(0);
  else
    return caml_alloc_int63(NANOS_PER_SECOND * (uint64_t)tp.tv_sec +
                            (uint64_t)tp.tv_usec * 1000);
}

#else /* compiling with cl */

#if _MSC_VER < 1900 /* timespec_get is supported starting VS 2015 */

/*
 * Note that there are fallback implementations of gettimeofday for Windows.
 * I am not convinced there is much value in supporting Visual Studio versions
 * older than 2015 in an OCaml library, so we just croak here instead of
 * falling back.
 */

#error timespec_get is only available in Visual Studio 2015 (14.0) and later
#endif

#include <time.h>

/*
 * https://en.cppreference.com/w/c/chrono/timespec_get
 * https://docs.microsoft.com/en-us/cpp/c-runtime-library/reference/timespec-get-timespec32-get-timespec64-get1?view=msvc-160
 */

CAMLprim value time_now_nanoseconds_since_unix_epoch_or_zero() {
  struct timespec ts;

  if (timespec_get(&ts, TIME_UTC) != TIME_UTC)
    return caml_alloc_int63(0);
  else
    return caml_alloc_int63(NANOS_PER_SECOND * (uint64_t)ts.tv_sec +
                            (uint64_t)ts.tv_nsec);
}
#endif
#endif

CAMLprim value time_now_nanosecond_counter_for_timing() {
  return time_now_nanoseconds_since_unix_epoch_or_zero();
}
