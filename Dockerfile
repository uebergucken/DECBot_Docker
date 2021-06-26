FROM i386/alpine:latest

ENV CLIENT=
ENV TOKEN=

RUN apk update && apk add --no-cache \
    python3 \
    py3-pip \
    python3-dev \
    build-base \
    alsa-lib-dev \
    libffi-dev \
    opus \
    git \
    ffmpeg \
    xvfb \
;

RUN printf 'https://dl-cdn.alpinelinux.org/alpine/v3.7/main\n\
https://dl-cdn.alpinelinux.org/alpine/v3.7/community\n'\
> /etc/apk/repositories

RUN apk add --no-cache \
    wine; exit 0;

RUN wineboot;

RUN pip install decbot

RUN mkdir -p /etc/decbot && cd /etc/decbot && git clone https://github.com/uebergucken/DECTalk4_win32_bin.git

RUN printf 'client: %s \n\
token: %s \n\
tts: { bin: /etc/decbot/DECTalk4_win32_bin } \n\
opus: /usr/lib/libopus.so.0 \n' "${CLIENT}" "${TOKEN}" \
> /etc/decbot/decbot.conf

RUN printf '#!/bin/sh\n\
Xvfb :0 -screen 0 1024x768x16 & \n\
export DISPLAY=:0.0 \n\
decbot --config /etc/decbot/decbot.conf' \
> /start.sh

RUN chmod +x ./start.sh

RUN decbot --config /etc/decbot/decbot.conf --invite

ENTRYPOINT ["/bin/sh", "/start.sh"]
