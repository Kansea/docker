# Use an official ubuntu 16.04  as a parent image
FROM kansea/cuda:cuda

# Author name
MAINTAINER Jiaqing Lin

# Set the working directory to /app
#WORKDIR /app

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
    python3 \
    python3-dev \
    python3-dbg \
    python3-pip \
    python3-tk \
    build-essential \
    pkg-config \
    libjpeg8-dev \
    libtiff5-dev \
    libjasper-dev \
    libpng12-dev \
    libgtk2.0-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libv4l-dev \
    libatlas-base-dev \
    gfortran \
    libhdf5-dev

# Install python libs
RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install \
    numpy \
    matplotlib \
    scipy \
    pillow

# Install cuda-python
RUN pip3 install \
    pycuda \
    cupy

# Install Chainer framework
Run pip3 install \
    chainer

# Download OpenCV 3.2.0 and install
RUN cd ~ && \
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
    mv cv2.cpython-35m-x86_64-linux-gnu.so cv2.so && \
    cd cv2 && \
    mv cv2.cpython-35m-x86_64-linux-gnu.so cv2.so

# Run app.py when the container launches
#CMD ["python3", "app.py"]
