#include <stdint.h>
#include <stdio.h>

#include <tvm_runtime.h>

#include "tvmgen_default.h"

int main(void) {
    size_t membuf_sz = 2ull * 1024 * 1024;
    uint8_t *membuf = malloc(membuf_sz);
    tvm_workspace_t workspace = {0};

    puts("allocating memory");
    StackMemoryManager_Init(&workspace, membuf, membuf_sz);

    puts("running inference");
    struct tvmgen_default_outputs outputs = {
       .StatefulPartitionedCall_0 = malloc(2048),
    };
    struct tvmgen_default_inputs inputs = {
       .serving_default_dense_2_input_0 = malloc(2048),
    };
    tvmgen_default_run(&inputs, &outputs);

    return 0;
}
