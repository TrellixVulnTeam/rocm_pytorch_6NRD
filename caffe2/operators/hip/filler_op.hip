// !!! This is a file automatically generated by hipify!!!
#include "hip/hip_runtime.h"
#include <cmath>
#include "caffe2/core/hip/context_gpu.h"
#include "caffe2/operators/filler_op.h"
#include "caffe2/operators/hip/operator_fallback_gpu.h"

namespace caffe2 {

namespace {
__global__ void FillRangeKernel(const int n, float* data) {
  HIP_1D_KERNEL_LOOP(index, n) {
    data[index] = index;
  }
}

template <typename T>
__global__ void FillDiagonalKernel(
    const int num_diagonal_elements,
    const int64_t step_size,
    const T value,
    T* data) {
  HIP_1D_KERNEL_LOOP(index, num_diagonal_elements) {
    data[index * step_size] = value;
  }
}
}

template <>
bool RangeFillOp<float, HIPContext>::Fill(Tensor* output) {
  int N = output->numel();
  FillRangeKernel<<<
      CAFFE_GET_BLOCKS(N),
      CAFFE_HIP_NUM_THREADS,
      0,
      context_.hip_stream()>>>(N, output->template mutable_data<float>());
  C10_HIP_KERNEL_LAUNCH_CHECK();

  return true;
}

template <>
template <typename T>
bool DiagonalFillOp<HIPContext>::FillWithType(Tensor* output) {
  VerifyOutputShape(output);
  auto* data = output->template mutable_data<T>();
  int size = output->numel();
  // first fill everything with 0
  math::Set<T, HIPContext>(size, T(0), data, &context_);

  T value = OperatorBase::GetSingleArgument<T>("value", 0);
  int64_t step_size = GetStepSize(output);
  int num_diagonal_elements = ceil((float)size / step_size);

  FillDiagonalKernel<<<
      CAFFE_GET_BLOCKS(num_diagonal_elements),
      CAFFE_HIP_NUM_THREADS,
      0,
      context_.hip_stream()>>>(num_diagonal_elements, step_size, value, data);
  C10_HIP_KERNEL_LAUNCH_CHECK();

  return true;
}

REGISTER_HIP_OPERATOR(UniformFill, UniformFillOp<float, HIPContext>);
REGISTER_HIP_OPERATOR(UniformIntFill, UniformFillOp<int, HIPContext>);
REGISTER_HIP_OPERATOR(ConstantFill, ConstantFillOp<HIPContext>);
REGISTER_HIP_OPERATOR(DiagonalFill, DiagonalFillOp<HIPContext>);
REGISTER_HIP_OPERATOR(GaussianFill, GaussianFillOp<float, HIPContext>);
REGISTER_HIP_OPERATOR(XavierFill, XavierFillOp<float, HIPContext>);
REGISTER_HIP_OPERATOR(MSRAFill, MSRAFillOp<float, HIPContext>);
REGISTER_HIP_OPERATOR(RangeFill, RangeFillOp<float, HIPContext>);
REGISTER_HIP_OPERATOR(LengthsRangeFill, GPUFallbackOp);

} // namespace caffe2
