// !!! This is a file automatically generated by hipify!!!
#include "caffe2/operators/lengths_pad_op.h"

#include "caffe2/core/hip/context_gpu.h"

namespace caffe2 {
REGISTER_HIP_OPERATOR(LengthsPad, LengthsPadOp<HIPContext>);
} // namespace caffe2
