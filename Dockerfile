FROM python:3.7.5-slim as builder

RUN apt-get update && \
    apt-get install -y \
      debhelper \
      build-essential \
      pybind11-dev \
      python3-dev \
      python3-numpy-dev \
      zlib1g-dev  \
      curl \
      wget \
      unzip \
      pkg-config \
      zip unzip \
      git && \
    apt-get clean
RUN pip install pip --upgrade
RUN pip install pybind11
RUN pip3 install pip --upgrade
RUN pip3 install pybind11 numpy Pillow 

RUN wget https://github.com/bazelbuild/bazel/releases/download/3.7.2/bazel-3.7.2-installer-linux-x86_64.sh  && bash bazel-3.7.2-installer-linux-x86_64.sh

RUN wget https://github.com/Kitware/CMake/releases/download/v3.18.6/cmake-3.18.6-Linux-x86_64.sh && bash cmake-3.18.6-Linux-x86_64.sh --skip-license

RUN git clone https://github.com/tensorflow/tensorflow.git 
RUN export BUILD_FLAGS="-I/usr/local/include/python3.7m/ -I"$(python -c "import numpy as np; print(np.get_include())")" $BUILD_FLAGS" && cd tensorflow && git checkout 5f2341e61bc5e5172f521fffd1a0851146891c2a  && ls tensorflow/lite/tools/pip_package && BUILD_NUM_JOBS=4 PYTHON=python3 tensorflow/lite/tools/pip_package/build_pip_package_with_cmake.sh native


FROM python:3.7.5-slim

COPY --from=builder /tensorflow/tensorflow/lite/tools/pip_package/gen/tflite_pip/python3/dist/tflite_runtime-2.5.0-cp37-cp37m-linux_x86_64.whl /
run pip3 install --no-cache-dir --upgrade pip && pip3 install --no-cache-dir *.whl && pip3 install --no-cache-dir --upgrade numpy==1.20 && rm *.whl
