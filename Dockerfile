#############################################################
#
# Dockerfile to create the image for the AbPTM R/Shiny app
#
# Created: Lionel Morgado [2024-12-21]
# 
##############################################################
# 
# Docker commands (PowerShell + Docker 24.0.7 on Windows10)
#
# # Create docker image
# >cd <DOCKER_IMAGE_DIR> #(e.g.: D:\Stuff\Docker\AbPTM_docker)
# >docker build -t abptm_docker .
#
# # Launch docker container (opens on http://localhost:8180)
# >docker run -it -p 8180:8180 abptm_docker
#
##############################################################

#------------------------------------------------------------
# Get python3.8 base image
#------------------------------------------------------------
FROM python:3.8

# Update the sources list
RUN apt-get update


#------------------------------------------------------------
# Install R
#------------------------------------------------------------
# Install fortran
RUN apt install build-essential
RUN apt-get install gfortran -y

# Install R
#..get and install depedencies..
RUN apt-get install -y --no-install-recommends libopenblas0-pthread littler r-cran-docopt r-cran-littler liblapack-dev libopenblas-dev
RUN apt-get install -y r-base

#..download and extract R..
RUN curl -O https://cran.rstudio.com/src/base/R-4/R-4.4.2.tar.gz
RUN tar -xzvf R-4.4.2.tar.gz

#..build and install R..
RUN cd R-4.4.2 && ./configure --prefix=/opt/R/4.4.2
RUN cd R-4.4.2 && make
RUN cd R-4.4.2 && make install


#------------------------------------------------------------
# Install R packages
#------------------------------------------------------------
RUN R -e "install.packages('shiny', version='1.5.0')"
RUN R -e "install.packages('shinydashboard', version='0.7.1')"
RUN R -e "install.packages('shinycssloaders', version='1.0.0')"
RUN R -e "install.packages('shinyjs', version='2.0.0')"
RUN R -e "install.packages('ggplot2', version='3.3.3')"
RUN R -e "install.packages('shinyWidgets', version='0.5.6')"
RUN R -e "install.packages('waiter', version='0.2.0')"
RUN R -e "install.packages('shinyBS', version='0.61.1')"
RUN R -e "install.packages('httr', version='1.4.7')"
RUN R -e "install.packages('plotly', version='4.9.3')"
RUN R -e "install.packages('DT', version='0.17')"
RUN R -e "install.packages('RcppArmadillo', version='14.2.2-1')"
RUN R -e "install.packages('ade4', version='1.7-22')"
RUN R -e "install.packages('segmented', version='2.1.3')"
RUN R -e "install.packages('seqinr', repos='http://R-Forge.R-project.org')"
RUN R -e "install.packages('remotes', version='2.5.0')"
RUN R -e "remotes::install_github('daqana/dqshiny', version='2.5.0')"


#------------------------------------------------------------
# Install 3rd-party software
#------------------------------------------------------------
# Install conda
RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN mkdir /root/.conda
RUN chmod +x Miniconda3-latest-Linux-x86_64.sh
RUN bash Miniconda3-latest-Linux-x86_64.sh -b -p /root/miniconda3
RUN rm -f Miniconda3-latest-Linux-x86_64.sh
RUN echo PATH="/root/miniconda3/bin":$PATH >> .bashrc
RUN exec bash
ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"

# Install ANARCI
RUN conda install bioconda::anarci

# Install SCALOP
RUN git clone https://github.com/oxpig/SCALOP.git
RUN conda create -n scalop-env python=3.8 -y
RUN conda shell.bash activate scalop-env
RUN conda install -c bioconda numpy pandas hmmer biopython -y
RUN python3 -m pip install SCALOP/


#------------------------------------------------------------
# Launch AbPTM
#------------------------------------------------------------
# Expose the application port
EXPOSE 8180

# Copy AbPTM code to the container
COPY AbPTM /home/AbPTM

# Launch the R/Shiny app
CMD ["R", "-e", "shiny::runApp('/home/AbPTM/AbPTM.R', port=8180, host='0.0.0.0')"]


