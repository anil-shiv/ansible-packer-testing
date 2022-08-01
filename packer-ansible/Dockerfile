FROM centos:centos8
ONBUILD ARG JENKINS_USER=jenkins
ONBUILD ARG JENKINS_UID=1033
ARG JENKINS_GROUP=${JENKINS_USER}

RUN echo "${JENKINS_USER}----${JENKINS_USER}"

ONBUILD RUN yum clean all && yum update -y
WORKDIR /opt
RUN cd /etc/yum.repos.d/ && sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* && \
        sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-* && \
        yum update -y
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
    ln -sf /usr/share/zoneinfo/US/Pacific /etc/localtime 



RUN yum install epel-release -y
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

# RUN yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
# RUN yum -y install packer && ln -s /usr/bin/packer /usr/local/packer

ARG PACKER_VER=1.8.2

RUN wget -O /tmp/packer.zip \
    "https://releases.hashicorp.com/packer/${PACKER_VER}/packer_${PACKER_VER}_linux_amd64.zip" \
  && unzip -o /tmp/packer.zip -d /usr/local/bin \
  && rm -f /tmp/packer.zip

ADD bin /opt/resource

ONBUILD RUN adduser ${JENKINS_USER} -u ${JENKINS_UID} && \
        chown -R ${JENKINS_USER}:${JENKINS_GROUP} /dist && \
        echo "${JENKINS_USER} ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/${JENKINS_USER} && \
        chmod 0440 /etc/sudoers.d/${JENKINS_USER} 
ONBUILD USER ${JENKINS_USER} 
