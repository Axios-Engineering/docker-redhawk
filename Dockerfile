from centos:centos6
MAINTAINER Ryan Bauman <ryan.bauman@axiosengineering.com>

#add EPEL repo
RUN yum install -y epel-release && yum clean all

#add REDHAWK repo and install redhawk
COPY redhawk.repo /etc/yum.repos.d/
RUN yum install -y redhawk-devel redhawk-debuginfo redhawk-sdrroot-dev-mgr redhawk-sdrroot-dom-mgr redhawk-sdrroot-dom-profile redhawk-codegen redhawk-basic-components redhawk bulkioInterfaces burstioInterfaces frontendInterfaces GPP GPP-profile omniORB-utils omniORB-servers omniEvents-server omniEvents-bootscripts git vim-enhanced which wget sudo PackageKit-gtk-module libcanberra-gtk2 && yum clean all

#configure omniORB.cfg; Note: if linking another container, replace IP address
#e.g. sed -i "s/127.0.0.1/$OMNIORB_PORT_2809_TCP_ADDR/" /etc/omniORB.cfg
RUN echo "InitRef = EventService=corbaloc::127.0.0.1:11169/omniEvents" >> /etc/omniORB.cfg

#configure default user
RUN mkdir -p /home/redhawk
ADD bashrc /home/redhawk/.bashrc
ADD bash_profile /home/redhawk/.bash_profile
RUN chown -R redhawk. /home/redhawk
RUN usermod -a -G wheel --shell /bin/bash redhawk

#allow sudo access sans password
RUN echo "%wheel        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers

ENV HOME /home/redhawk
WORKDIR /home/redhawk
USER redhawk
EXPOSE 2809
EXPOSE 11169
CMD ["/bin/bash", "-l"]
