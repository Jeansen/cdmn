FROM debian
ARG DEBIAN_FRONTEND=noninteractive
ENV USERNAME marcel

RUN echo "deb http://http.us.debian.org/debian/ stretch main contrib non-free" > /etc/apt/sources.list && \
  echo "deb http://security.debian.org/ stretch/updates main contrib non-free" >> /etc/apt/sources.list && \
  echo "deb http://http.us.debian.org/debian/ stretch-updates main contrib non-free" >> /etc/apt/sources.list && \

  apt-get update && apt-get install -y \
  curl \ 
  wget \
  unzip \
  apt-transport-https \
  dirmngr \
  fontconfig \
  man \
  sudo \
  xauth \
  x11-xserver-utils \
  rxvt-unicode-256color \
  perl \
  libfilesys-df-perl \
  libparams-validate-perl \
  libxft-dev \
  libperl-dev \
  checkinstall \
  git && \

  apt-get remove -y rxvt-unicode-256color && apt-get clean

ADD http://dist.schmorp.de/rxvt-unicode/rxvt-unicode-9.22.tar.bz2 /tmp/

RUN mkdir -p /tmp/rxvt_src && \
    wget -O - http://dist.schmorp.de/rxvt-unicode/rxvt-unicode-9.22.tar.bz2 | tar -xjf - -C /tmp/rxvt_src
WORKDIR /tmp/rxvt_src/rxvt-unicode-9.22

RUN git clone https://github.com/Jeansen/cdmn.git && \
  patch src/rxvtperl.xs cdmn/resources/rxvtperl.xs.patch && \
  ./configure --enable-everything --enable-256-color && \
  make && checkinstall -y && \

  useradd -m $USERNAME && \
  echo "$USERNAME:$USERNAME" | chpasswd && \
  usermod --shell /bin/bash $USERNAME && \
  usermod -aG sudo $USERNAME && \
  echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME && \
  chmod 0440 /etc/sudoers.d/$USERNAME && \
  # Replace 1000 with your user/group id
  usermod  --uid 1000 $USERNAME && \
  groupmod --gid 1000 $USERNAME

USER $USERNAME
ENV SHELL=/bin/bash
WORKDIR /home/$USERNAME

RUN mkdir -p /home/$USERNAME/.local/share/fonts/DejaVuSansMono && \
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v1.1.0/DejaVuSansMono.zip && \
    unzip DejaVuSansMono.zip -d /home/$USERNAME/.local/share/fonts/DejaVuSansMono && rm DejaVuSansMono.zip

RUN fc-cache -vf

CMD xrdb -load /home/$USERNAME/.Xresources && urxvt -pe cdmn
