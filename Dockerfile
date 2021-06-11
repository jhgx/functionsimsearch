FROM ubuntu:bionic

RUN chmod 777 /tmp
RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y git wget cmake sudo gcc-7 g++-7 python3-pip zlib1g-dev googletest
RUN apt-get install -y libgtest-dev libgflags-dev libz-dev libelf-dev g++ python3-pip libboost-system-dev libboost-thread-dev libboost-date-time-dev

WORKDIR /code/functionsimsearch
COPY ./build_dependencies.sh .
RUN ./build_dependencies.sh

# build functionsimsearch
COPY . .
RUN make -j

# recommend mapping the /pwd volume, probably like (for ELF file):
#   docker run -it --rm -v $(pwd):/pwd functionsimsearch disassemble ELF /pwd/someexe
ENTRYPOINT ["/code/functionsimsearch/entrypoint.sh"]
