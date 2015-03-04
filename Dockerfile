# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/baseimage:latest
MAINTAINER bobby prabowo

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# ...put your own build instructions here...
RUN apt-get update

# install iotivity dependencies
RUN apt-get install -y git-core ssh wget

# download & install boost
RUN mkdir /home/iotivity
RUN cd /home/iotivity
RUN wget http://sourceforge.net/projects/boost/files/boost/1.55.0/boost_1_55_0.tar.gz/download
RUN tar xzvf boost_1_55_0.tar.gz
RUN ./bootstrap.sh --with-libraries=system,filesystem,date_time,thread,regex,log,iostreams,program_options --prefix=/usr/local

RUN apt-get update
RUN apt-get install -y python-dev autotools-dev libicu-dev essential libbz2-dev wget

RUN ./b2 install
RUN sh -c 'echo '/usr/local/lib' >> /etc/ld.so.conf.d/local.conf'
RUN ldconfig

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*