FROM centos:6
MAINTAINER cgs.wong@gmail.com

# Download the package and install everything
RUN wget https://downloads-packages.s3.amazonaws.com/centos-6.5/gitlab-7.0.0_omnibus-1.el6.x86_64.rpm
RUN sudo yum -y update
RUN sudo yum -y install openssh-server
RUN sudo yum -y install postfix
RUN sudo rpm -i gitlab-7.0.0_omnibus-1.el6.x86_64.rpm

# Edit the configuration file to add your hostname
RUN sudo -e /etc/gitlab/gitlab.rb

# Install and start GitLab
RUN sudo gitlab-ctl reconfigure
RUN sudo lokkit -s http -s ssh


ADD assets/setup/ /app/setup/
RUN chmod 755 /app/setup/install
RUN /app/setup/install

ADD assets/config/ /app/setup/config/
ADD assets/init /app/init
RUN chmod 755 /app/init

# Expose ports for access
EXPOSE 22
EXPOSE 80
EXPOSE 443

# Create persistent volume from host
VOLUME ["/opt/git/data"]

ENTRYPOINT ["/app/init"]
CMD ["app:start"]
