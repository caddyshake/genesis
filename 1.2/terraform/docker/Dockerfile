FROM ubuntu:20.04

RUN apt update -y; \
    apt install git wget -y

RUN wget https://golang.org/dl/go1.16.4.linux-amd64.tar.gz; \
    rm -rf /usr/local/go && tar -C /usr/local -xzf go1.16.4.linux-amd64.tar.gz; \
    ln -s /usr/local/go/bin/go /usr/local/bin

RUN cd ~ && git clone https://github.com/hashicorp/terraform.git

RUN cd ~/terraform; \
    go install; \
    cp /root/go/bin/terraform /usr/local/bin/