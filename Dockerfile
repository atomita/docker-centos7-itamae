FROM centos:7

MAINTAINER atomita

RUN yum -y update; yum clean all
RUN yum -y install\
	git\
	gcc-c++\
	make\
	openssl-devel\
	libffi-devel


ENV DOCKER_USER docker


# Install anyenv
RUN git clone https://github.com/riywo/anyenv .anyenv
RUN echo -e "\n\n## anyenv\n\
if [ -d /.anyenv ]; then\n\
	export ANYENV_ROOT=/.anyenv\n\
	export PATH=\"/.anyenv/bin:\${PATH}\"\n\
	eval \"\$(anyenv init -)\"\n\
fi" >> /etc/profile.d/anyenv.sh

## Install rbenv
RUN bash -l -c 'anyenv install rbenv'

## Install ruby
ENV RUBY_VERSION 2.2.0
RUN bash -l -c 'echo "ruby" "$RUBY_VERSION"'
RUN bash -l -c 'CONFIGURE_OPTS="--disable-install-rdoc" rbenv install "$RUBY_VERSION" && rbenv global "$RUBY_VERSION"'
 
# Install bundler and itamae
RUN bash -l -c 'gem install bundler'
RUN bash -l -c 'gem install itamae'
RUN bash -l -c 'rbenv rehash'


# Create user
RUN  adduser $DOCKER_USER

# anyenv own to DOCKER_USER
RUN chown $DOCKER_USER:$DOCKER_USER -R /.anyenv

# Change user
USER $DOCKER_USER
WORKDIR /home/$DOCKER_USER
ENV HOME /home/$DOCKER_USER


USER root
