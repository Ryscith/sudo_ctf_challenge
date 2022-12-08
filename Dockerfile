FROM ubuntu:18.04

# Get utils to build sudo
RUN apt-get -y update && \
    apt-get -y install gcc && \
    apt-get -y install make && \
    apt-get -y install autoconf && \
    apt-get -y install groff && \
    apt-get -y install flex && \
    apt-get -y install bison

# Get vulnerable sudo code, then build it
COPY ./vuln_sudo_1_5_1 /repos/sudo
RUN cd /repos/sudo && autoupdate && autoconf && ./configure --with-getpass --disable-pie && make && make install
RUN echo "Cmnd_Alias    PAGERS=/bin/more,/usr/bin/pager\n\
Cmnd_Alias    UTILS=/bin/cp,/bin/mv,/bin/rm,/bin/rmdir,/bin/cat,/bin/mkdir,/bin/touch,/usr/bin/print,\\\\\n\
                    /usr/bin/shuf,/usr/bin/uniq,/usr/bin/tr,/usr/bin/head,/usr/bin/tail,/usr/bin/sort,\\\\\n\
                    /usr/bin/split,/usr/bin/fold,/usr/bin/diff*\n\
Cmnd_Alias    SCRIPTING=/bin/sed,/usr/bin/perl*,/usr/bin/cut,/usr/bin/awk\n\
Cmnd_Alias    PACKAGEMGR=/usr/bin/apt,/usr/bin/apt-get\n\
Cmnd_Alias    EDITORS=/usr/bin/editor\n\
Cmnd_Alias    SHELLS=/bin/bash,/bin/dash,/bin/sh\n\
ctf_player    ALL=ALL,!PAGERS,!UTILS,!SCRIPTING,!PACKAGEMGR,!EDITORS,!SHELLS" >> /etc/sudoers

# Remove extra utils to reduce things we need to secure
RUN rm -f /bin/z* /bin/bz* /usr/bin/xz* /usr/bin/lz* /usr/bin/tsort /usr/bin/rgrep /usr/bin/nawk /usr/bin/mawk

# Create flag.txt and README.txt
RUN mkdir /home/ctf
WORKDIR /home/ctf
RUN echo "flag{1_sud0nt_und3rs74nd_h0w_y0u_g0t_7h1s_f1ag}" > flag.txt && \
    chmod 600 flag.txt
RUN echo "DATE: 12/23/97\n\
Welcome to your new job here at ../../best/software/inc..\n\
We've assigned you a user ID and password..\n\
\n\
USER: ctf_player\n\
PASS: pass\n\
\n\
Don't even try to access anything you aren't supposed to..\n\
We've secured our system using the latest version of sudo, version 1.5.1..\n\
I've dotdotted my i's and dotted my t's.." > README.txt

# Create a new user and start container as the new user. Also set passwords for root and the new user
RUN echo -n "root\nroot" | passwd root
RUN useradd -G users ctf_player
RUN echo -n "pass\npass" | passwd ctf_player
USER ctf_player
