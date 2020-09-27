# docker_test_for_CSP_FMBA
##### Docker image based on Ubuntu 18:04 contains:
* samtools
* htslib
* libdeflate
* biobambam (+libmaus)

All programs are stored in the /soft folder ($SOFT variable) and can be started by a variable corresponding to their name in upper case 
(e.g. you can run bamcat script by $BAMCAT). The path to each program is also included in the $PATH environment variable. Each program is located on a separate single layer (excluding biobambam combined with libmaus).

##### Additional installed packages and utilities:
* wget
*    gcc compiler
*    zlib1g-dev
*    libncurses5-dev
*    python-dev
*    libbz2-dev
*    liblzma-dev
*    libcurl4-openssl-dev
*    autoconf
*    automake
*    libtool
*    pkg-config

##### To make image and run container from Dockerfile you should:
1. Add Dockerfile to your local folder
2. Build docker image from Dockerfile:
```
docker build -t <name>
```
3. Run container to extract file to make environment variables for biobambam scripts:
```
docker run -it --rm -v $(pwd):/soft/biobambam <name>
/soft# cp /scriptsbiobambam /soft/biobambam
/soft# exit
```
4. Run working container in the interactive mode:
```
docker run -it --env-file scriptsbiobambam <name>
```
