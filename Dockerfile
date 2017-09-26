
# centos/s2i-base-centos7
FROM openshift/base-centos7

EXPOSE 8080

ENV RUBY_VERSION 2.3

ENV MAINTAINER="Mark Morga <markmorga@gmail.com>"

ENV BUILDER_VERSION 1.0

ENV SUMMARY="Platform for building and running Ruby $RUBY_VERSION applications" \
    DESCRIPTION="Platform for building Jekyll documentation sites \
Ruby $RUBY_VERSION available as docker container is a base platform for \
This image provides a Ruby 2.3 environment to build repository documentation \
web sites using Jekyll."

LABEL summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      io.k8s.display-name="mmorga/s2i-jekyll-builder" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="jekyll,site,pages,builder,ruby,ruby23,rh-ruby23" \
      version="1.0" \
      release="1" \
      maintainer="$MAINTAINER"

RUN yum install -y centos-release-scl && \
    yum-config-manager --enable centos-sclo-rh-testing && \
    INSTALL_PKGS="tar unzip bc which lsof java-1.8.0-openjdk java-1.8.0-openjdk-devel rh-ruby23 rh-ruby23-ruby-devel rh-ruby23-rubygem-rake rh-ruby23-rubygem-bundler rh-nodejs4 rh-nodejs4-npm graphviz ImageMagick" && \
    yum install -y --enablerepo=centosplus --setopt=tsflags=nodocs $INSTALL_PKGS && rpm -V $INSTALL_PKGS && \
    yum clean all -y

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH
COPY ./s2i/bin/ $STI_SCRIPTS_PATH

# Copy extra files to the image.
COPY ./root/ /

RUN chown -R 1001:0 /opt/app-root && chmod -R ug+rwx /opt/app-root

USER 1001

# Set the default CMD to print the usage of the language image
CMD $STI_SCRIPTS_PATH/usage
