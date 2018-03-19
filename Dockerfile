FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04

# docker build -t vanessa/sentence-space .

ENV SHELL /bin/bash

# Environment variables for CUDA
ENV MKL_THREADING_LAYER GNU
ENV CPATH /usr/local/cuda-9.0/include
ENV PATH /usr/local/cuda-9.0/bin:$PATH
ENV LD_LIBRARY_PATH=/usr/local/cuda-9.0/lib64:$LD_LIBRARY_PATH
ENV CUDA_HOME=/usr/local/cuda-9.0

RUN apt-get update && apt-get install -y vim wget git build-essential cmake

# Miniconda
ENV PATH /usr/local/miniconda/bin:$PATH
RUN echo 'export PATH=/usr/local/miniconda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda2-4.4.10-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /usr/local/miniconda && \
    rm ~/miniconda.sh

# Google Sentence Piece Dependencies
RUN apt-get install -y autoconf automake libtool pkg-config libprotobuf9v5 protobuf-compiler libprotobuf-dev

# Sentence Space Dependencies
RUN /usr/local/miniconda/bin/conda update -n base -y conda && \
    /usr/local/miniconda/bin/conda install flask && \
    /usr/local/miniconda/bin/conda install numpy=1.12.1 && \
    /usr/local/miniconda/bin/conda install theano=0.9.0 && \
    /usr/local/miniconda/bin/conda install pandas=0.20.1 && \
    /usr/local/miniconda/bin/conda install matplotlib=2.0.2 && \ 
    /usr/local/miniconda/bin/pip install wordfilter && \
    /usr/local/miniconda/bin/pip install gunicorn && \
    /usr/local/miniconda/bin/conda install -y cython && \
    /usr/local/miniconda/bin/pip install sentencepiece

RUN mkdir -p /code
ADD . /code
WORKDIR /code

# Theano Config 
# This needs to be edited so it works...
ADD .theanorc $HOME/.theanorc

EXPOSE 5001
