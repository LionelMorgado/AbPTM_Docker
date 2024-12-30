# AbPTM_Docker

## Short description
Dockerfile to create a docker image for the AbPTM R/Shiny app.

## Computational environment
The present Dockerfile was developed and tested using PowerShell and Docker 24.0.7 on Windows 10.

## How to run
### Step1: Get the AbPTM source code
Download the AbPTM source code available at https://github.com/LionelMorgado/AbPTM.git.
### Step2: Prepare local project directory
Create a local folder with all the project files, including the Dockerfile and the AbPTM source code.
### Step3: Create docker image
Type in a terminal the commands below:
>cd <DOCKER_IMAGE_DIR> (e.g.: C:\AbPTM_docker)
>docker build -t abptm_docker .
### Step4: Launch docker container
Type in a terminal the commands below:
>docker run -it -p 8180:8180 abptm_docker

In case of success the R/Shiny app running inside the container will be accessible via a web browser at http://localhost:8180.
