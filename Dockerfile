# Use an official ubuntu 16.04  as a parent image
FROM kansea/cuda:py3-cv3-ffmpeg-chainer

# Author name
MAINTAINER Jiaqing Lin

# Set the working directory to /app
#WORKDIR /app

# Copy the current directory contents into the container at /app
#ADD . /app

# Install any needed packages specified in requirements.txt
RUN apt-get update && apt-get install -y \
    curl \
    git \
    vim \
    python3 \
    python3-dev \
    python3-dbg \
    python3-pip \
    build-essential \
    ffmpeg
    
RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install \
    numpy \
    matplotlib \
    scipy \
    opencv-python

RUN pip3 install \
    pycuda \
    cupy

Run pip3 install \
    chainer

# Run app.py when the container launches
#CMD ["python3", "app.py"]
