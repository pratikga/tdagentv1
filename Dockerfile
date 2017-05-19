############################################################
# Dockerfile to build td-agent container images
# Based on Centos
############################################################

# Set the base image to centos
FROM centos

# File Author / Maintainer 
MAINTAINER Pratik

# Update the repository sources list
RUN yum -y update 

# Install Ruby related packages 
RUN yum -y install curl libcurl14-openssl-dev ruby ruby-dev make 

# Install Devolopment tools
RUN yum -y groupinstall "Development Tools" --skip-broken

################## BEGIN INSTALLATION ######################

# Install fluentd td-agent from the shell script

# SCRIPT does not work 
#RUN curl -L https://toolbelt.treasuredata.com/sh/install-redhat-td-agent2.sh | sh

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

     
 
