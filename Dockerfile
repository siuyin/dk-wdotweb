# Use phusion/passenger-full as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/passenger-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/passenger-ruby21:0.9.35
#FROM phusion/passenger-ruby21
# Or, instead of the 'full' variant, use one of these:
#FROM phusion/passenger-ruby19:<VERSION>
#FROM phusion/passenger-ruby20:<VERSION>
#FROM phusion/passenger-ruby21:<VERSION>
#FROM phusion/passenger-nodejs:<VERSION>
#FROM phusion/passenger-customizable:<VERSION>

# Set correct environment variables.
ENV HOME /home/app/wdotweb

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# ...put your own build instructions here...
# install development headers for postgresql client
RUN apt-get update
RUN apt-get install graphviz -y

# setup hello app as the 'app' user
RUN mkdir -p /home/app/wdotweb
COPY app/wdotweb /home/app/wdotweb

# setup runit service
RUN mkdir -p /etc/service/wdotweb
ADD run /etc/service/wdotweb/run

EXPOSE 22 8188

## Install an SSH key
ADD config/id_rsa.pub /tmp/your_key
RUN cat /tmp/your_key >> /root/.ssh/authorized_keys && rm -f /tmp/your_key

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

