# tflite-inference
A Docker image to use as base for the deployment of optimized, x86_64 XNNPACK delegate enabled, tensorflow lite inference services.
The docker-hub image is optimized for recent CPUs implementing the AVX512 SIMD instructions for Intel microprocessors.

## Usage

Use as base image in the development and deployment of tflite enabled services:
``` Dockerfile
FROM matteoferrabonetflite-inference:latest

COPY ...
...
```
