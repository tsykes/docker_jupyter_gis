FROM fedora 
USER root 


# install postgres, python, R, geo, etc 
RUN dnf install -y \
    gcc-c++ \
    git \
    openssl-devel \ 
    libcurl-devel \
    python37 \
    python3-pip \
    R-core \
    R-core-devel \
    jq-devel \
    v8-devel \
    protobuf-devel \
    R-rgdal \
    gdal \
    gdal-libs \
    gdal-devel \
    proj-devel \
    proj-epsg \
    proj-nad \
    geos \
    R-rgeos \
    geos-devel \
    udunits2-devel \
    postgresql \
    postgresql-devel \
    libpqxx \ 
    libpqxx-devel \
    R-sp \
    R-sp-devel \
    sudo

# install pip packages 
RUN pip3 install \
    jupyter \
    jupyterlab 


# create directory that should already exist 
RUN mkdir -p /usr/share/doc/R/html

# install R packages 
RUN R -e "install.packages('devtools', repos='http://cloud.r-project.org/')"
RUN R -e "install.packages('RPostgreSQL', repos='http://cloud.r-project.org/')" 
RUN R -e "install.packages('rgdal', type = 'source', repos='http://cloud.r-project.org/')"
RUN R -e "install.packages('rgeos', type = 'source', repos='http://cloud.r-project.org/')"
RUN R -e "install.packages(c('sf','protolite'), repos='http://cloud.r-project.org/')"
RUN R -e "install.packages('leaflet', repos='http://cloud.r-project.org/')"
RUN R -e "install.packages(c('leaflet.extras','rjson'), repos='http://cloud.r-project.org/')" 
RUN R -e "install.packages('geojsonio', repos='http://cloud.r-project.org/')"

RUN R -e "library(devtools); install_github('IRkernel/repr')"
RUN R -e "library(devtools); install_github('IRkernel/IRdisplay')"
RUN R -e "install.packages('IRkernel', repos='http://cloud.r-project.org/')"


# add user 
RUN groupadd -g 1000 jupyter && \
useradd -g jupyter -G wheel -m -s /bin/bash jupyter && \
echo "jupyter:jupyter" | chpasswd 

RUN echo "jupyter ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/jupyter 

RUN chmod 0440 /etc/sudoers.d/jupyter 

RUN echo "c.NotebookApp.token = 'jupyter'" > /home/jupyter/jupyter_notebook_config.py && \
echo "alias python=python3" >> /home/jupyter/.bash_profile && \
echo "alias pip=pip3" >> /home/jupyter/.bash_profile 

EXPOSE 8888
USER jupyter
WORKDIR /home/jupyter

# configure R kernel 
RUN R -e "library(IRkernel); IRkernel::installspec()"

#CMD ["/bin/bash", "-c", "/opt/conda/bin/jupyter-notebook --ip=*"]
# CMD ["bin/bash", "-c", "jupyter lab"]
ENTRYPOINT ["jupyter", "lab", "--ip=0.0.0.0", "--no-browser"]

