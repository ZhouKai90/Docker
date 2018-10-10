# -*- mode: dockerfile -*-
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

# dockerfile to build libmxnet.so c++ api on GPU
FROM registry.docker-cn.com/nvidia/cuda:9.2-cudnn7-devel-ubuntu16.04
LABEL author="kyle zhou"

RUN apt-get update && apt-get install -y \
    build-essential git libatlas-base-dev libopencv-dev python-opencv \
    libcurl4-openssl-dev libgtest-dev cmake wget unzip
	
#install OpenBlas
RUN cd /tmp && git clone https://github.com/xianyi/OpenBLAS.git && cd OpenBLAS && make -j$(nproc) && make PREFIX=/usr install

RUN mkdir /home/workspace -p && cd /home/workspace
ENV BUILD_OPTS "USE_OPENCV=1 USE_BLAS=openblas USE_CUDA=1 USE_CUDA_PATH=/usr/local/cuda-9.2 USE_CUDNN=1 USE_CPP_PACKAGE=1 USE_SSE=1"
RUN git clone --recursive https://github.com/dmlc/mxnet && cd mxnet && \
    make -j$(nproc) $BUILD_OPTS
