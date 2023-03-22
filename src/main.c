#include <math.h>
#include <stdint.h>
#include <stdio.h>

#include <tvm_runtime.h>

#include "tvmgen_default.h"

#define NSAMPLES 100

int main(void) {
    size_t membuf_sz = 2ull * 1024 * 1024;
    uint8_t *membuf = malloc(membuf_sz);
    tvm_workspace_t workspace = {0};

    StackMemoryManager_Init(&workspace, membuf, membuf_sz);

    struct tvmgen_default_outputs outputs = {
        .StatefulPartitionedCall_0 = malloc(2048),
    };
    struct tvmgen_default_inputs inputs = {
        .serving_default_dense_2_input_0 = malloc(2048),
    };

    FILE *f = fopen("plt.py", "w");
    fprintf(f, "from matplotlib import pyplot as plt\n");

    fprintf(f, "y = [");
    for (int i = 0; i < NSAMPLES; i++) {
        *(int8_t*)inputs.serving_default_dense_2_input_0 = i * (INT8_MAX - INT8_MIN) / NSAMPLES + INT8_MIN;
        tvmgen_default_run(&inputs, &outputs);
        fprintf(f, "%i,", *(int8_t*)outputs.StatefulPartitionedCall_0);
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
