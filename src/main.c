#include <math.h>
#include <stdint.h>
#include <stdio.h>

#include <tvm_runtime.h>

#include "tvmgen_default.h"

#define MEM_BUF_SZ 2048
#define NSAMPLES 100

int main(void) {
    uint8_t membuf[MEM_BUF_SZ];
    tvm_workspace_t workspace = {0};

    StackMemoryManager_Init(&workspace, membuf, MEM_BUF_SZ);

    int8_t output_buf = 0;
    struct tvmgen_default_outputs outputs = {
        .StatefulPartitionedCall_0 = &output_buf,
    };

    int8_t input_buf = 0;
    struct tvmgen_default_inputs inputs = {
        .serving_default_dense_2_input_0 = &input_buf,
    };

    FILE *f = fopen("plt.py", "w");
    fprintf(f, "from matplotlib import pyplot as plt\n");

    fprintf(f, "y = [");
    for (int i = 0; i < NSAMPLES; i++) {
        input_buf = i * (INT8_MAX - INT8_MIN) / NSAMPLES + INT8_MIN;
        tvmgen_default_run(&inputs, &outputs);
        fprintf(f, "%i,", output_buf);
    }
    fprintf(f, "]\n");

    fprintf(f, "g = [");
    for (int i = 0; i < NSAMPLES; i++) {
        fprintf(f, "%i,", (int8_t)(127 * sinf(i * (2 * M_PI) / NSAMPLES)));
    }
    fprintf(f, "]\n");

    fprintf(f, "plt.plot(y)\n");
    fprintf(f, "plt.plot(g)\n");
    fprintf(f, "plt.show()\n");

    return 0;
}
