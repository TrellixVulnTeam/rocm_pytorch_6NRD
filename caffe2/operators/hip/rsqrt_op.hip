// !!! This is a file automatically generated by hipify!!!
#include "hip/hip_runtime.h"
#include "caffe2/operators/rsqrt_op.h"

#include <algorithm>
#include <functional>

#include "caffe2/core/hip/context_gpu.h"
#include "caffe2/utils/math.h"

namespace caffe2 {

namespace {

template <typename T>
__global__ void
RsqrtGradientHIPKernel(const int size, const T* dY, const T* Y, T* dX) {
  HIP_1D_KERNEL_LOOP(i, size) {
#if __HIP_ARCH__ >= 350
    dX[i] = __ldg(dY + i) * math::utils::Cube<T>(__ldg(Y + i)) *
        static_cast<T>(-0.5);
#else
    dX[i] = dY[i] * math::utils::Cube<T>(Y[i]) * static_cast<T>(-0.5);
#endif
  }
}

} // namespace

template <>
template <typename T>
bool RsqrtGradientFunctor<HIPContext>::Forward(
    const std::vector<int>& dY_dims,
    const std::vector<int>& /* Y_dims */,
    const T* dY,
    const T* Y,
    T* dX,
    HIPContext* context) const {
  const int size = std::accumulate(
      dY_dims.cbegin(), dY_dims.cend(), 1, std::multiplies<int>());
  RsqrtGradientHIPKernel<T>
      <<<CAFFE_GET_BLOCKS(size),
         CAFFE_HIP_NUM_THREADS,
         0,
         context->hip_stream()>>>(size, dY, Y, dX);
  C10_HIP_KERNEL_LAUNCH_CHECK();

  return true;
}

REGISTER_HIP_OPERATOR(
    Rsqrt,
    UnaryElementwiseOp<
        TensorTypes<float>,
        HIPContext,
        RsqrtFunctor<HIPContext>>);
REGISTER_HIP_OPERATOR(
    RsqrtGradient,
    BinaryElementwiseOp<
        TensorTypes<float>,
        HIPContext,
        RsqrtGradientFunctor<HIPContext>>);

} // namespace caffe2
