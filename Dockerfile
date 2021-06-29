FROM i386/alpine:3.14

ARG CLIENT
ARG TOKEN

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

RUN printf 'https://dl-cdn.alpinelinux.org/alpine/v3.10/main\n\
https://dl-cdn.alpinelinux.org/alpine/v3.10/community\n'\
> /etc/apk/repositories

RUN apk add --no-cache wine

RUN Xvfb :0 -screen 0 1024x768x16 &
RUN export DISPLAY=:0.0 && wineboot

RUN pip install discord.py pydub pyyaml pynacl --prefer-binary

RUN cd /tmp && git clone https://github.com/wquist/DECbot.git && cd /tmp/DECbot && pip install .

RUN mkdir -p /usr/local/bin/dectalk && cd /usr/local/bin/dectalk && git clone https://github.com/uebergucken/DECTalk4_win32_bin.git

RUN mkdir -p /etc/decbot && printf 'client: %s \n\
token: %s \n\
tts: { bin: /usr/local/bin/dectalk/DECTalk4_win32_bin } \n\
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
