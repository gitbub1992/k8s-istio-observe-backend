#!/bin/bash
#
# author: Gary A. Stafford
# site: https://programmaticponderings.com
# license: MIT License
# purpose: Build Go microservices for demo

readonly -a arr=(a b c d e f g h rev-proxy)
# readonly -a arr=(rev-proxy)
readonly tag=1.5.0
BASE_PATH=$(cd `dirname $0`;pwd)
for i in ${arr[@]}
do
  cp -f Dockerfile service-${i}
  pushd service-${i}
  GOOS=linux CGO_ENABLED=0 go build -mod=vendor -ldflags '-w -s' -a -installsuffix cgo -o hello .
  docker build -t ccr.ccs.tencentyun.com/pulse-line-beta/go-srv-${i}:${tag} . --no-cache
  rm -rf Dockerfile
  rm hello
  popd
done

docker image ls | grep 'ccr.ccs.tencentyun.com/pulse-line-beta/go-srv-'
