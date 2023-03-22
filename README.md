# tvm-test
Testing the Apache TVM deep learning compiler.

Build and run a Docker image that will compile the provided `model.tflite` to an MLF archive using `tvmc`:
```
./dkr_build.sh && dkr_run.sh
```

Compile the MLF into a C application that will run inference on the model and output a Python file for analysis and comparison of the model outputs.
Run the C application and thereafter run the generated Python code:
```
make run
```
(The above will take care of building and running the C application _and_ running the generated Python code)

The test model used here approximates a sin function, and was taken from Tensorflow's user tutorials.
