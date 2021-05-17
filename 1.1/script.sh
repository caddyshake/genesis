#!/bin/bash
arg=$1

if [[ "$1" ]];
then
  echo "Variables set!"
else
  echo "Have not variables set! Usage '"bash script.sh ansible or terraform"'"
fi

if [[ "$1" == "ansible" ]];
then
  docker run -it ansible:kirin
fi

if [[ "$1" == "terraform" ]];
then
  docker run -it terraform:kirin
fi