// !!! This is a file automatically generated by hipify!!!
#include <ATen/Dispatch.h>
#include <ATen/ExpandUtils.h>
#include <ATen/NativeFunctions.h>
#include <ATen/hip/HIPApplyUtils.cuh>
#include <ATen/AccumulateType.h>
#include <ATen/CUDAGeneratorImpl.h>
#include <ATen/native/UnaryOps.h>
#include <ATen/native/hip/DistributionTemplates.h>

#include <hiprand/hiprand.h>
#include <hiprand/hiprand_kernel.h>
#include <hiprand/hiprand_kernel.h>
#include <utility>
#include <functional>

#include <ATen/native/Distributions.h>
#include <ATen/native/hip/Loops.cuh>
#include <ATen/native/TensorIterator.h>
#include <ATen/LegacyTHFunctionsCUDA.h>

#include <THH/THHGeneral.h>
#include <THH/THHApply.cuh>
#include <THH/THHDeviceUtils.cuh>

#include <cstdint>
#include <limits>
#include <utility>
#include <type_traits>

namespace at { namespace native {

void normal_kernel(Tensor& self, double mean, double std, c10::optional<Generator> gen) {
  auto generator = get_generator_or_default<CUDAGeneratorImpl>(gen, cuda::detail::getDefaultCUDAGenerator());
  at::native::templates::cuda::normal_kernel(self, mean, std, generator);
}

REGISTER_DISPATCH(normal_stub, &normal_kernel);

}} // namespace at::native
