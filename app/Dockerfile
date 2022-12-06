#get ubntu 18.04
FROM ubuntu:18.04

# Choose the Python version
ARG _PY_SUFFIX=3
ARG PYTHON=python${_PY_SUFFIX}
ARG PIP=pip${_PY_SUFFIX}

# Choose the CUDA and TF Versions
ARG TF_PACKAGE=tensorflow
ARG TF_PACKAGE_VERSION=2.1.0

ENV APP /app.py
ENV PYTHONBUFFERED True
WORKDIR $APP
COPY . ./

# Needed for string substitution
SHELL ["/bin/bash", "-c"]

ARG CHECKOUT_TF_SRC=0
RUN test "${CHECKOUT_TF_SRC}" -eq 1 && git clone https://github.com/tensorflow/tensorflow.git /tensorflow_src || true

RUN apt-get update && apt-get install -y \
    ${PYTHON} \
    ${PYTHON}-pip

RUN ${PIP} --no-cache-dir install --upgrade \
    pip \
    setuptools

#python binary if needed
RUN ln -s $(which python3) /usr/local/bin/python

# install tensorflow
RUN python3 -m pip install --no-cache-dir ${TF_PACKAGE}${TF_PACKAGE_VERSION:+==${TF_PACKAGE_VERSION}}

#install utilities
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    wget \
    openjdk-8-jdk \
    virtualenv \
    swig \
    unzip

#install useful packages
RUN python3 -m pip --no-cache-dir install \
    Pillow \
    h5py \
    keras_preprocessing \
    matplotlib \
    mock \
    numpy \
    scipy \
    sklearn \
    pandas \
    future \
    portpicker \
    enum34 \
    #imaging packages
    nibabel \
    six \
    scikit-image \
    webcolors \
    plotly \
    webcolors \
    fslpy \
    google-cloud-storage \
    wheel==0.37.1 \
    antspyx==0.3.3 \
    gunicorn \
    Flask

# RUN ${PIP} install antspyx
#https://github.com/ANTsX/ANTsPy/releases/download/v0.2.0/antspyx-0.2.0-cp37-cp37m-linux_x86_64.whl


#Install FSL base, but not unnecessary extras
ENV INSTALL_FOLDER=/usr/local/

RUN curl -sSL https://fsl.fmrib.ox.ac.uk/fsldownloads/fsl-6.0.2-centos7_64.tar.gz | tar xz -C ${INSTALL_FOLDER} \
    --exclude='fsl/doc' \
    --exclude='fsl/data/first' \    
    --exclude='fsl/data/atlases' \
    --exclude='fsl/data/possum' \    
    --exclude='fsl/src' \    
    --exclude='fsl/extras/src' \    
    --exclude='fsl/bin/fslview*' \
    --exclude='fsl/bin/FSLeyes' \
    --exclude='fsl/bin/*_gpu*' \
    --exclude='fsl/bin/*_cuda*'

# Configure environment
ENV FSLDIR=${INSTALL_FOLDER}/fsl/ \
    FSLOUTPUTTYPE=NIFTI_GZ

# Below needs a new line
ENV PATH=${FSLDIR}/bin:$PATH \
    LD_LIBRARY_PATH=${FSLDIR}:${LD_LIBRARY_PATH}

# RUN mkdir /.local && chmod a+rwx /.local

# download the weights
RUN wget -O weights.zip https://www.dropbox.com/s/v2ptd9mfpo13gcb/mistie_2-20200122T175000Z-001.zip?dl=1  && unzip -j weights.zip 
RUN for i in _data-00001-of-00002 _data-00000-of-00002 _index; do out=`echo ${i} | sed "s/_/weights./"`; mv ${i} ${out}; done

CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 app:app