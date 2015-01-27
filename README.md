# REDHAWK docker
A basic [Docker](https://www.docker.com/) image of a [REDHAWK](http://redhawksdr.org) development environment.

The image can be pulled from the [Docker Hub Registry](https://registry.hub.docker.com/u/axios/redhawk/)

The default command for this image runs a bash shell as the 'redhawk' user.  This is a privileged user and is not required to authenticate when running 'sudo' so that the container may be customized.

    docker run -it axios/redhawk

The image comes with the omniNames and omniEvents servers installed and configured.  Start them with:

    sudo service omniNames start
    sudo service omniEvents start

#REDHAWK IDE support
The REDHAWK IDE has been left out of this docker image by default.  To enable IDE support in your docker container perform the following steps:

1.  On your localhost, disable xhost access control:

        xhost +

2. Run the image and bind mount the X11 socket to the container.  Additionally, set the display environment variable:

        docker run -it --volume=/tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY axios/redhawk

3. Install the redhawk-ide yum package:

        sudo yum install redhawk-ide

4. Verify that the REDHAWK IDE can be launched from the container and displays correctly on the host system:

        rhide&

NOTE: If you are on an SELinux enabled CentOS 7 host, you will need to first assign the appropriate context to the /tmp/.X11-unix directory as described [here]( https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Resource_Management_and_Linux_Containers_Guide/sec-Sharing_Data_Across_Containers.html):

    chcon -Rt svirt_sandbox_file_t /tmp/.X11-unix
