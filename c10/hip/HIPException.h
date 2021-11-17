// !!! This is a file automatically generated by hipify!!!
#pragma once

#include <c10/hip/HIPMacros.h>
#include <c10/hip/HIPMiscFunctions.h>
#include <c10/macros/Macros.h>
#include <c10/util/Exception.h>
#include <hip/hip_runtime.h>

// Note [CHECK macro]
// ~~~~~~~~~~~~~~~~~~
// This is a macro so that AT_ERROR can get accurate __LINE__
// and __FILE__ information.  We could split this into a short
// macro and a function implementation if we pass along __LINE__
// and __FILE__, but no one has found this worth doing.

// Used to denote errors from HIP framework.
// This needs to be declared here instead util/Exception.h for proper conversion
// during hipify.
namespace c10 {
class C10_HIP_API HIPError : public c10::Error {
  using Error::Error;
};
} // namespace c10

// For HIP Runtime API
#ifdef STRIP_ERROR_MESSAGES
#define C10_HIP_CHECK(EXPR)                                     \
  do {                                                           \
    hipError_t __err = EXPR;                                    \
    if (__err != hipSuccess) {                                  \
      throw c10::HIPError(                                      \
          {__func__, __FILE__, static_cast<uint32_t>(__LINE__)}, \
          TORCH_CHECK_MSG(false, ""));                           \
    }                                                            \
  } while (0)
#else
#define C10_HIP_CHECK(EXPR)                                        \
  do {                                                              \
    hipError_t __err = EXPR;                                       \
    if (__err != hipSuccess) {                                     \
      auto error_unused C10_UNUSED = hipGetLastError();            \
      auto _hip_check_suffix = c10::hip::get_hip_check_suffix(); \
      throw c10::HIPError(                                         \
          {__func__, __FILE__, static_cast<uint32_t>(__LINE__)},    \
          TORCH_CHECK_MSG(                                          \
              false,                                                \
              "",                                                   \
              "HIP error: ",                                       \
              hipGetErrorString(__err),                            \
              _hip_check_suffix));                                 \
    }                                                               \
  } while (0)
#endif

#define C10_HIP_CHECK_WARN(EXPR)                              \
  do {                                                         \
    hipError_t __err = EXPR;                                  \
    if (__err != hipSuccess) {                                \
      auto error_unused C10_UNUSED = hipGetLastError();       \
      TORCH_WARN("HIP warning: ", hipGetErrorString(__err)); \
    }                                                          \
  } while (0)

// This should be used directly after every kernel launch to ensure
// the launch happened correctly and provide an early, close-to-source
// diagnostic if it didn't.
#define C10_HIP_KERNEL_LAUNCH_CHECK() C10_HIP_CHECK(hipGetLastError())
