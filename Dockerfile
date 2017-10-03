# Use an official ubuntu 16.04  as a parent image
FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04

# Author name
MAINTAINER Jiaqing Lin

# Set the working directory to /app
WORKDIR /root

# Copy the current directory contents into the container at /app
#ADD . /app

# Install dependencies
RUN apt-get update && apt-get install --assume-yes apt-utils \
    cmake \
    curl \
    git \
    unzip \
    vim \
    wget \
    nasm \
    python3 \
    python3-dev \
    python3-dbg \
    python3-pip \
    python3-tk \
    build-essential \
    pkg-config \
    libglew-dev \
    libjpeg8-dev \
    libtiff5-dev \
    libjasper-dev \
    libpng12-dev \
    libgtk2.0-dev \
    libavcodec-dev \
    libavformat-dev \
    libavutil-dev \
    libpostproc-dev \
    libswscale-dev \
    libv4l-dev \
    libatlas-base-dev \
    gfortran \
    libhdf5-dev \
    zlib1g-dev \
    libeigen3-dev \
    libtbb-dev \
    libboost-all-dev

# Install ffmpeg3
RUN cd ~ && \
    rm -rf ffmpeg && \
    git clone https://git.ffmpeg.org/ffmpeg.git && \
    cd /root/ffmpeg && \
    ./configure --enable-cuda --enable-cuvid --enable-nvenc \
                --enable-nonfree --enable-libnpp \
                --extra-cflags=-I/usr/local/cuda/include \
                --extra-ldflags=-L/usr/local/cuda/lib64 && \
    make -j $(nproc) && \
    export PATH=$PATH:/root/ffmpeg && \
    ldconfig

# Install python libs
RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install \
    numpy \
    matplotlib \
    scipy \
    pillow \
    h5py \
    tqdm \
    youtube_dl

# Install cuda-python
RUN pip3 install \
    pycuda \
    cupy \
    # Install Chainer framework
    chainer

# Download OpenCV 3.x.x latest version and install
RUN cd ~ && \
    rm -rf opencv && \
    rm -rf opencv_contrib && \
    git clone https://github.com/opencv/opencv.git && \
    git clone https://github.com/opencv/opencv_contrib.git && \
    cd /root/opencv && \
    mkdir build && \
    cd build && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
          -D CMAKE_INSTALL_PREFIX=/usr/local \
          -D INSTALL_C_EXAMPLES=OFF \
          -D INSTALL_PYTHON_EXAMPLES=OFF \
          -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules \
          -D WITH_FFMPEG=ON \
          -D WITH_CUDA=ON \
          -D CUDA_NVCC_FLAGS="-D_FORCE_INLINES" \
          -D ENABLE_FAST_MATH=1 \
          -D CUDA_FAST_MATH=1 \
          -D WITH_CUBLAS=1 \
          -D BUILD_opencv_python3=ON \
          -D BUILD_EXAMPLES=OFF .. && \
    cd ~/opencv/build && \
    make -j $(nproc) && \
    make install && \
    ldconfig && \

    # clean opencv repos
    rm -rf ~/opencv/build && \
    rm -rf ~/opencv/3rdparty && \
    rm -rf ~/opencv/doc && \
    rm -rf ~/opencv/include && \
    rm -rf ~/opencv/platforms && \
    rm -rf ~/opencv/modules && \
    rm -rf ~/opencv_contrib/build && \
    rm -rf ~/opencv_contrib/doc && \
    # Change opencv lib file name
    cd /usr/local/lib/python3.5/dist-packages && \
    mv cv2.cpython-35m-x86_64-linux-gnu.so cv2.so
