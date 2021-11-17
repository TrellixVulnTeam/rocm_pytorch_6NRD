// !!! This is a file automatically generated by hipify!!!
#pragma once

#include <ATen/CUDAGeneratorImpl.h>
#include <ATen/hip/HIPEvent.h>
#include <ATen/hip/detail/UnpackRaw.cuh>
#include <ATen/hip/detail/HIPHooks.h>
#include <ATen/detail/CUDAHooksInterface.h>
#include <c10/core/StreamGuard.h>
#include <c10/hip/HIPGraphsC10Utils.h>
#include <ATen/hip/impl/HIPGuardImplMasqueradingAsCUDA.h>

// c10/hip/HIPGraphsC10Utils.h has utils used by both c10 and aten.
// This file adds utils used by aten only.

namespace at {
namespace cuda {

using CaptureId_t = c10::hip::CaptureId_t;
using CaptureStatus = c10::hip::CaptureStatus;

// Use this version where you don't want to create a CUDA context if none exists.
inline CaptureStatus currentStreamCaptureStatus() {
#if defined(HIP_VERSION) && HIP_VERSION >= 11000
  // don't create a context if we don't have to
  if (at::cuda::detail::hasPrimaryContext(c10::hip::current_device())) {
    return c10::hip::currentStreamCaptureStatusMayInitCtx();
  } else {
    return CaptureStatus::None;
  }
#else
  return CaptureStatus::None;
#endif
}

inline void assertNotCapturing(std::string attempt) {
  auto status = currentStreamCaptureStatus();
  TORCH_CHECK(status == CaptureStatus::None,
              attempt,
              " during CUDA graph capture. If you need this call to be captured, "
              "please file an issue. "
              "Current cudaStreamCaptureStatus: ",
              status);
}

} // namespace cuda
} // namespace at
