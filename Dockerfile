FROM centos:7 

ENV SERVER_HOST=0.0.0.0
ENV SERVER_PORT=8080

#install tarantool and dependencies for tarantoolctl
RUN curl -L https://tarantool.io/IIVMVtV/release/2.8/installer.sh | bash
RUN yum install -y git gcc tarantool-devel

#install http module for tarantool server
RUN tarantoolctl rocks install http

EXPOSE 8080
EXPOSE 3301
