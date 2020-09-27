FROM ubuntu:18.04
MAINTAINER Pavel Zemsky <pzemsky@gmail.com>

RUN apt-get update && \
    apt-get install wget -y \
    build-essential manpages-dev git automake autoconf -y \
    zlib1g-dev \
    libncurses5-dev -y \
    python-dev -y \
    libbz2-dev -y \
    liblzma-dev \
    libcurl4-openssl-dev -y \
    autoconf -y \
    automake -y \
    libtool -y \
    pkg-config
RUN mkdir soft
ENV SOFT=/soft
WORKDIR $SOFT
RUN mkdir tmp

#########################
# biobambam (+libmaus)  #
# version: 3            #
# released: 2015-04-20  #
#########################

RUN mkdir libmaus biobambam && \
    cd tmp && \
    git clone --depth 1 https://github.com/gt1/libmaus.git && \
    cd libmaus && \
    autoreconf -i -f && \
    ./configure --prefix=/soft/libmaus && \
    make install && \
    cd .. && \
    git clone --depth 1 https://github.com/gt1/biobambam.git && \
    cd biobambam && \
    autoreconf -i -f && \
    ./configure --with-libmaus='/soft/libmaus' --prefix='/soft/biobambam' && \
    make install && \
    cd .. && \
    rm -Rf * && \
    cd /soft && \
    ls /soft/biobambam/bin | awk  '{print toupper($1) "=/soft/biobambam/bin/./" $1}' > /scriptsbiobambam
ENV PATH=${PATH}:$SOFT/biobambam/bin

#########################
# htslib                #
# version: 1.11         #
# released: 2020-09-22  #
#########################

ARG HTSLIB_VERSION=1.11
RUN mkdir htslib-${HTSLIB_VERSION} && \
    cd tmp && \
    wget https://github.com/samtools/htslib/releases/download/${HTSLIB_VERSION}/htslib-${HTSLIB_VERSION}.tar.bz2 && \
    tar xjf htslib-${HTSLIB_VERSION}.tar.bz2 && \
    cd htslib-${HTSLIB_VERSION} && \
    ./configure --prefix=$SOFT/htslib-${HTSLIB_VERSION} && \
    make install && \
    cd ..
ENV PATH=${PATH}:$SOFT/htslib-${HTSLIB_VERSION}/bin
ENV HTSLIB=$SOFT/htslib-${HTSLIB_VERSION}/bin/htsfile

#########################
# samtools              #
# version: 1.11         #
# modified: 2020-09-22  #
#########################

ARG SAMTOOLS_VERSION=1.11
RUN mkdir samtools-${SAMTOOLS_VERSION} && \
    cd tmp && \
    wget https://github.com/samtools/samtools/releases/download/${SAMTOOLS_VERSION}/samtools-${SAMTOOLS_VERSION}.tar.bz2 && \
    tar xjf samtools-${SAMTOOLS_VERSION}.tar.bz2 && \
    cd  samtools-${SAMTOOLS_VERSION} && \
    ./configure --prefix=$SOFT/samtools-${SAMTOOLS_VERSION} && \
    make install && \
    cd .. && \
    rm -Rf * && \
    cd ..
ENV PATH=${PATH}:$SOFT/samtools-${SAMTOOLS_VERSION}/bin
ENV SAMTOOLS=$SOFT/samtools-${SAMTOOLS_VERSION}/bin/samtools

#########################
# libdeflate            #
# version: 1.6          #
# released: 2020-08-25  #
#########################

RUN mkdir libdeflate && \
    cd tmp && \
    git clone --depth 1 https://github.com/ebiggers/libdeflate.git && \
    cd libdeflate && \
    make PREFIX='/soft/libdeflate' install && \
    cd .. && \
    rm -Rf * && \
    cd ..
ENV PATH=${PATH}:$SOFT/libdeflate/bin
ENV LIBDEFLATEGUNZIP=$SOFT/libdeflate/bin/libdeflate-gunzip
ENV LIBDEFLATEGZIP=$SOFT/libdeflate/bin/libdeflate-gzip
