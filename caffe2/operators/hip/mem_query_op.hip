// !!! This is a file automatically generated by hipify!!!
#include "caffe2/core/hip/context_gpu.h"
#include "caffe2/core/operator.h"

namespace caffe2 {
namespace {

class GetGPUMemoryUsageOp final : public Operator<HIPContext> {
 public:
  template<class... Args> explicit GetGPUMemoryUsageOp(Args&&... args)
      : Operator<HIPContext>(std::forward<Args>(args)...) {}
  ~GetGPUMemoryUsageOp() override {}

  bool RunOnDevice() override {
    CHECK_EQ(InputSize(), 0);
    CHECK_EQ(OutputSize(), 1);
    std::vector<long> total_by_gpu = HIPContext::TotalMemoryByGpu();
    std::vector<long> max_by_gpu = HIPContext::MaxMemoryByGpu();
    CHECK_EQ(total_by_gpu.size(), max_by_gpu.size());


    auto* stats = Output(0, {2, static_cast<int64_t>(total_by_gpu.size())}, at::dtype<long>());
    context_.CopyFromCPU<long>(
        total_by_gpu.size(),
        total_by_gpu.data(),
        stats->template mutable_data<long>());
    context_.CopyFromCPU<long>(
        max_by_gpu.size(),
        max_by_gpu.data(),
        stats->template mutable_data<long>() + total_by_gpu.size());
    return true;
  }
};

OPERATOR_SCHEMA(GetGPUMemoryUsage)
    .NumInputs(0)
    .NumOutputs(1)
    .SetDoc(R"DOC(Fetches GPU memory stats from HIPContext. Result is stored
      in output blob with shape (2, num_gpus). First row contains the total
      current memory usage, and the second row the maximum usage during
      this execution.

      NOTE: --caffe2_gpu_memory_tracking flag must be enabled to use this op.
    )DOC");

REGISTER_HIP_OPERATOR(GetGPUMemoryUsage, GetGPUMemoryUsageOp);
}

} // namespace caffe2
