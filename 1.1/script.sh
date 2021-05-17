#!/bin/bash
arg=$1

if [[ "$1" ]];
then
  echo "Variable are set!"
else
  echo "Have not variables set! Usage '"bash script.sh nginx or httpd"'"
fi

if [[ "$1" == "nginx" ]];
then
  docker run -it nginx
fi

if [[ "$1" == "httpd" ]];
then
  docker run -it httpd
fi