#docker run -d -it -p 8888:8888 -v /home/local/DSG/tsykes/mnt_centos_jupyter:/home/jupyter --name jupyterrr  jupyterr

docker run -d -p 8888:8888 -e JUPYTER_ENABLE_LAB=yes -v /home/local/DSG/tsykes/jupyterr_home:/home/jovyan/work --name jupyterrr --user root -e GRANT_SUDO=yes jupyterr 

# docker run -it --name fed-jup-bash a95912a6a291 /bin/bash
