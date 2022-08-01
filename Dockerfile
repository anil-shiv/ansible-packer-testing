FROM centos:centos8

ONBUILD ARG JENKINS_USER=jenkins
ONBUILD ARG JENKINS_UID=1033
ARG JENKINS_GROUP=${JENKINS_USER}

RUN echo "${JENKINS_USER}----${JENKINS_USER}"

ONBUILD RUN yum clean all && yum update -y
WORKDIR /opt
RUN cd /etc/yum.repos.d/ && sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* \
            && sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
RUN yum clean all && \
yum update -y && \
yum install -y dstat \
                openssh-server openssh-clients \
                lsof \
                mailx \
                mtr \
                nc \
                rsync \
                strace \
                traceroute \
                unzip \
                wget \
                passwd \
                yum-utils \
                zip && \
    mkdir /dist && \
    ln -sf /usr/share/zoneinfo/US/Pacific /etc/localtime && \
    yum clean all

COPY kubernetes.repo /etc/yum.repos.d/
RUN yum install -y kubectl
RUN curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz" | tar xz -C /tmp
RUN mv /tmp/eksctl /usr/local/bin
RUN curl -fsSL -o helm-v3.7.1-linux-amd64.tar.gz https://get.helm.sh/helm-v3.7.1-linux-amd64.tar.gz
RUN tar -zxvf helm-v3.7.1-linux-amd64.tar.gz

RUN mv linux-amd64/helm /usr/local/bin/helm

RUN yum install epel-release -y
# RUN yum install ansible -y
RUN yum install python3.9 -y 
RUN python3.9 -V
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python3.9 get-pip.py --user &&\
    python3.9 -m pip install --user ansible
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

# RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install


CMD [ "/bin/bash" ]

RUN yum install -y java-11-openjdk \
            svn \
            git \
            sudo \
            perl-LDAP  && \
mkdir -p /usr/local/bin && \
mkdir -p /dist/jenkins && \
chmod 755 /dist/jenkins && \
yum clean all && \
rm -rf /dist/java/*src.zip && \
rm -rf /dist/java/lib/visualvm && \
rm -rf /dist/java/lib/missioncontrol 


ENV JAVA_HOME=/usr/bin/java
ENV PATH $JAVA_HOME/bin:$PATH


#

