# AbPTM_Docker

## Short description
Dockerfile to create a docker image for the AbPTM R/Shiny app

## Computational environment
The following dockerfile was developed and tested using PowerShell and Docker 24.0.7 on Windows 10.

## How to run
### Step1: Build docker image
>cd <DOCKER_IMAGE_DIR> (e.g.: D:\Stuff\Docker\AbPTM_docker)
>docker build -t abptm_docker .
### Step1: Launch docker container
>docker run -it -p 8180:8180 abptm_docker

In case of success the R/Shiny app will be accessible using a web browser at http://localhost:8180.
