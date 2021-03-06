FROM ubuntu:16.04
MAINTAINER infrastructor.io

RUN apt update && apt install sudo openssh-server -y
RUN mkdir /var/run/sshd
RUN useradd -ms /bin/bash devops
RUN useradd -ms /bin/bash sudops

RUN echo 'devops:devops' | chpasswd
RUN echo 'sudops:sudops' | chpasswd
RUN echo 'root:infra' | chpasswd

RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ADD sudoers /etc/sudoers
ADD authorized_keys /root/.ssh/authorized_keys
ADD authorized_keys /home/devops/.ssh/authorized_keys
ADD authorized_keys /home/sudops/.ssh/authorized_keys

RUN chown -R devops:devops /home/devops
RUN chown -R sudops:sudops /home/sudops

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
