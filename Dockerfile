FROM oraclelinux:7.2

MAINTAINER Timothy Langford

# RUN yum -y update
RUN yum -y install wget

# Install Oracle Java
RUN wget --no-cookies \
         --no-check-certificate \
         --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" \
                  "http://download.oracle.com/otn-pub/java/jdk/8u65-b17/jdk-8u65-linux-x64.rpm"
RUN yum -y localinstall jdk-8u65-linux-x64.rpm
RUN rm -f jdk-8u65-linux-x64.rpm
ENV JAVA_HOME=/usr/java/jdk1.8.0_65

# Install Logstash
COPY build/logstash.repo /etc/yum.repos.d/logstash.repo
RUN rpm --import http://packages.elasticsearch.org/GPG-KEY-elasticsearch
RUN yum -y install logstash
# RUN /opt/logstash/bin/plugin update

# Mount Logstash config
COPY logstash/config/logstash.conf /logstash/config/logstash.conf
# RUN chown -R logstash:logstash /logstash/config
VOLUME ["/logstash/config"]

# Mount Logstash certs
# VOLUME ["/logstash/certs"]

EXPOSE 4560

# Run Logstash
CMD ["/opt/logstash/bin/logstash", "--quiet",  "-f", "/logstash/config/logstash.conf"]
