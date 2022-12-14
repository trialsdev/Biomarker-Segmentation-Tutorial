FROM python:3.6

ENV APP /app
ENV PYTHONUNBUFFERED True
WORKDIR $APP
COPY . ./

RUN pip install -r requirements.txt

RUN pip install antspyx

RUN apt-get update && apt-get install sudo
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    unzip

CMD /bin/bash

ENV INSTALL_FOLDER='tools/'

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

RUN sudo apt install libquadmath0

# Configure environment
ENV FSLDIR=${INSTALL_FOLDER}/fsl/ \
    FSLOUTPUTTYPE=NIFTI_GZ

# Below needs a new line
ENV PATH=${FSLDIR}/bin:$PATH \
    LD_LIBRARY_PATH=${FSLDIR}:${LD_LIBRARY_PATH}


RUN wget -O weights.zip https://www.dropbox.com/s/v2ptd9mfpo13gcb/mistie_2-20200122T175000Z-001.zip?dl=1  && unzip -j weights.zip 
RUN for i in _data-00001-of-00002 _data-00000-of-00002 _index; do out=`echo ${i} | sed "s/_/weights./"`; mv ${i} ${out}; done

CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 app:app