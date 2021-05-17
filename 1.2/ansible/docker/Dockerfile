FROM ubuntu:20.04

#ansible
RUN apt update; \
    apt install software-properties-common; \
    apt-add-repository --yes --update ppa:ansible/ansible; \
    apt install ansible -y

RUN apt install python3-pip -y; \
    pip3 install boto3

#aws cli
RUN apt install curl unzip -y

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"; \
    unzip awscliv2.zip; \
    ./aws/install

ADD ./ssh /root/ssh
ADD ./project /root/project

RUN mkdir ~/.ssh; \
    chmod 700 ~/.ssh; \
    cp /root/ssh/ansible-docker.pem ~/.ssh; \
    chmod 600 ~/.ssh/ansible-docker.pem; \
    mv ~/.ssh/ansible-docker.pem ~/.ssh/id_rsa

RUN echo "alias ans-pl-aws='ansible-playbook playbook.yml -v'" >> ~/.bashrc