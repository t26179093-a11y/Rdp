FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1
ENV PASSWORD=root
ENV USER=root
RUN apt-get update && apt-get install -y \
    # Desktop
    xfce4 \
    xfce4-goodies \
    # VNC & noVNC
    x11vnc \
    xvfb \
    novnc \
    websockify \
    # Firefox
    firefox \
    # Tools
    dbus-x11 \
    netcat-openbsd \
    sudo \
    curl \
    wget \
    git \
    nano \
    && rm -rf /var/lib/apt/lists/*

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 6080

CMD ["/start.sh"]
