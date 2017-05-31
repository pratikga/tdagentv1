############################################################
# Dockerfile to build td-agent container images
# Based on Centos
############################################################

# Set the base image to centos
FROM centos

# File Author / Maintainer 
MAINTAINER Pratik

#Defining environment
ENV container docker 

#Manual installation of systemd
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]

# Update the repository sources list
RUN yum -y update 

# Install Ruby related packages 
RUN yum -y install curl libcurl14-openssl-dev ruby ruby-dev make 

# Install Devolopment tools
RUN yum -y groupinstall "Development Tools" --skip-broken

################## BEGIN INSTALLATION ######################

# Manually adding the repo file 
ADD td-agent.repo /etc/yum.repos.d/td-agent.repo

ADD RPM-GPG-KEY-td-agent /etc/pki/rpm-gpg/RPM-GPG-KEY-td-agent

RUN yum -y install td-agent

#Install Development tools for td-agent
RUN td-agent-gem install development tools

# Install fluentd Plugins 
RUN /opt/td-agent/embedded/bin/fluent-gem install --no-ri --no-rdoc \
    gelf \
    fluent-plugin-record-reformer \
    fluent-plugin-record-modifier 

# ADD Configuration File
ADD td-agent.conf /etc/td-agent/td-agent.conf


##################### INSTALLATION END #####################
