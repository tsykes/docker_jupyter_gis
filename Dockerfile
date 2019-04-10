FROM jupyter/datascience-notebook
USER root 

# install postgres 
RUN apt-get update &&  apt-get install -y \
   libpq-dev \
   libcairo2-dev \
   postgresql-client 

# install R packages 
RUN /opt/conda/bin/R -e "install.packages(RPostgreSQL', repos='http://cloud.r-project.org/')" 
RUN /opt/conda/bin/R -e "install.packages('leaflet', repos='http://cloud.r-project.org/')"

#EXPOSE 8888
#USER jovyan
#WORKDIR /home/jovyan

