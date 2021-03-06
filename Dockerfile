# Pull base image.
#FROM bigboards/cdh-base-__arch__
FROM bigboards/java-7-x86_64

MAINTAINER bigboards
USER root 

# Install much required packages
RUN apt-get update && apt-get install -f unzip

# Fetch h2o latest_stable
RUN \
  wget http://h2o-release.s3.amazonaws.com/h2o/rel-ueno/5/h2o-3.10.4.5-cdh5.8.zip --no-check-certificate -O /opt/h2o.zip && \
  unzip -d /opt /opt/h2o.zip && \
  rm /opt/h2o.zip && \
  cd /opt && \
  cd `find . -name 'h2odriver.jar' | sed 's/.\///;s/\/h2odriver.jar//g'` && \ 
  cp h2odriver.jar /opt && \
  wget http://s3.amazonaws.com/h2o-training/mnist/train.csv.gz && \
  gunzip train.csv.gz 

# Add the executable batch file
ADD docker_files/h2o-run.sh /apps/h2o-run.sh
RUN chmod a+x /apps/h2o-run.sh

# declare the volumes
RUN mkdir /etc/h2o
VOLUME /etc/h2o

# external ports
EXPOSE 54321 54321/udp 
EXPOSE 54322 54322/udp

CMD ["/apps/h2o-run.sh"]
