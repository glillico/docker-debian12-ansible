FROM debian:12
LABEL maintainer="Graham Lillico"

# Update packages to the latest version
# Install required packages.
# Remove packages that are nolonger requried.
# Clean the apt cache.
# Remove documents, man pages & apt files.
RUN apt-get update \
&& apt-get -y upgrade \
&& DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
ansible \
sudo \
systemd \
systemd-sysv \
&& apt-get -y autoremove \
&& apt-get -y clean \
&& rm -rf /var/lib/apt/lists/* \
&& rm -rf /usr/share/doc/* \
&& rm -rf /usr/share/man/*

# Create ansible directory and copy ansible inventory file.
RUN mkdir /etc/ansible \
&& echo -e '[local]\nlocalhost ansible_connection=local' > /etc/ansible/hosts

# Stop systemd from spawning agettys on tty[1-6].
RUN rm -f /lib/systemd/system/multi-user.target.wants/getty.target

VOLUME ["/sys/fs/cgroup"]
CMD ["/lib/systemd/systemd"]
