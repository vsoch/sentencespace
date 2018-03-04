FROM continuumio/miniconda

RUN apt-get update && apt-get install -y g++
RUN /opt/conda/bin/conda update -n base -y conda && \
    /opt/conda/bin/conda install -y numpy theano pandas matplotlib

RUN mkdir -p /code
ADD . /code
WORKDIR /code
RUN /opt/conda/bin/pip install -r requirements.txt

EXPOSE 5001
