FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04

ENV SHELL /bin/bash

# Environment variables for CUDA
ENV CPATH /usr/local/cuda/include:$CPATH
ENV PATH /usr/local/cuda/bin:$PATH
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
ENV CUDA_HOME=/usr/local/cuda

RUN apt-get update && apt-get install -y vim wget git build-essential cmake

# Miniconda
ENV PATH /usr/local/miniconda/bin:$PATH
RUN echo 'export PATH=/usr/local/miniconda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda2-4.4.10-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /usr/local/miniconda && \
    rm ~/miniconda.sh


# Sentence Space Dependencies
RUN /usr/local/miniconda/bin/conda update -n base -y conda && \
    /usr/local/miniconda/bin/conda install -y numpy theano pandas matplotlib

RUN mkdir -p /code
ADD . /code
WORKDIR /code
RUN /usr/local/miniconda/bin/pip install -r requirements.txt

# Theano Config 
# This needs to be edited so it works...
ADD .theanorc $HOME/.theanorc

EXPOSE 5001
