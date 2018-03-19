# Welcome to sentence space

You can find an introduction to this project, with interactive demos, [here](https://www.robinsloan.com/voyages-in-sentence-space).

This is a server designed to provide a couple of interesting artifacts. The core of it is a variational autoencoder that embeds sentences into a continuous space; as a result, you can select a point anywhere in that space and get a (more or less) coherent sentence back.

Once you've established this continuous sentence space, what can you get from it?

1. *Sentence gradients*: smooth interpolations between two input sentences.
2. *Sentence neighborhoods*: clouds of alternative sentences closely related to an input sentence.

These are very weird artifacts! If you try to write a sentence gradient by hand, you'll find it's very difficult. Is it useful? Possibly not. Is it _interesting_? Definitely!

Again, you'll find a ton more context and exploration in [this post](https://www.robinsloan.com/voyages-in-sentence-space).

## Installation
This code isn't quite turnkey, but if you're willing to tinker, you should be able to get up and running, training your own models and serving your own gradients, neighborhoods, and who-knows-what-else.

Requirements include:

* Python 2.7
* Theano and its dependencies, including Numpy
* Flask
* [`sentencepiece`](https://github.com/google/sentencepiece) (if you want to use the included, pretrained model)
* [`wordfilter`](https://github.com/dariusk/wordfilter)

If you have those requirements installed, it _should_ be possible to just run `bash serve.sh` and get a server running. If that's not the case, open an issue and let me know. I definitely want to streamline this over time, and improve this documentation as well.

### Docker
You can build a Docker image instead of installing locally, and the Docker image has the following changes:

 - the webserver is a separate container (nginx) and they are composed with the [docker-compose.yml](docker-compose.yml) file. The Flask application is run via gunicorn instead of the flask development server.
 - If you build locally, you can bind the `$PWD` to `/code` so restarting the containers will update with your changes
 - Any files that you don't want built into the container, you could instead choose to mount at runtime
 - the scripts have been updated to use python3 (the base image is [continuumio/miniconda3](https://hub.docker.com/r/continuumio/miniconda3/)
 - the versions of various packages are represented in the [requirements.txt](requirements.txt).

You will need to [install Docker](https://docs.docker.com/install/) along with [Docker Compose](https://docs.docker.com/compose/install/). Then (optionally) build the image. This is optional because we have a pre-built image provided on [Docker Hub]().


```
docker build -t vanessa/sentence-space .
```


#### Development
If you need to shell interactively into the container to look aroound:

```
docker run -it vanessa/sentence-space bash
```

You can also bind the repository in the present working directory (`$PWD`) so that you can make changes locally and they will also change in the container:

```
docker run -v $PWD:/code -it vanessa/sentence-space bash
```

## Usage
Once the server is running, the API is simple:

* `/gradient?s1=Your%20first%20sentence&s2=Your%20second%20sentence`
* `/neighborhood?s1=Your%20sentence&mag=0.2`

Both endpoints return a JSON array of results. The code is currently configured to provide seven sentences in each gradient or neighborhood, but you could make that three or 128.

This project is forked from [`stas-semeniuta/textvae`](https://github.com/stas-semeniuta/textvae), which is the code for the paper ["A Hybrid Convolutional Variational Autoencoder for Text Generation"](https://arxiv.org/abs/1702.02390) by Stanislau Semeniuta, Aliaksei Severyn, and Erhardt Barth. I'm indebted to Semeniuta, et. al., for their skill and generosity. If I have tinkered slightly, it is because I stood on the shoulders of smart people.

I'm indebted also to [`@richardassar`](https://github.com/richardassar), whose improvements allow this server to provide results at interactive speeds.

You can find Semeniuta et. al.'s original README in (you guessed it) `ORIGINAL-README.md`.
