FROM ubuntu:20.04

#ansible
RUN apt update; \
    apt install software-properties-common; \
    apt-add-repository --yes --update ppa:ansible/ansible; \
    apt install ansible -y

#aws cli
RUN apt install curl unzip -y

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"; \
    unzip awscliv2.zip; \
    ./aws/install
