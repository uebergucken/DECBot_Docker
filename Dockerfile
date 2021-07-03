FROM i386/alpine:3.14

ARG CLIENT
ARG TOKEN

RUN apk add --no-cache \
    python3 \
    py3-pip \
    python3-dev \
    build-base \
    alsa-lib-dev \
    libffi-dev \
    opus \
    git \
    ffmpeg \
    xvfb && \
    printf 'https://dl-cdn.alpinelinux.org/alpine/v3.12/main\nhttps://dl-cdn.alpinelinux.org/alpine/v3.12/community\n' > /etc/apk/repositories && \
    apk add --no-cache \
    wine && \
    rm -rf /var/lib/apt/lists/* \
;

RUN Xvfb :0 -screen 0 1024x768x16 &

RUN export DISPLAY=:0.0 && wineboot

RUN pip install discord.py pydub pyyaml pynacl --prefer-binary && \
    cd /tmp && git clone https://github.com/uebergucken/DECbot.git && \
    cd /tmp/DECbot && pip install . && \
    mkdir -p /usr/local/bin/dectalk && \
    cd /usr/local/bin/dectalk && \
    git clone https://github.com/uebergucken/DECTalk4_win32_bin.git && \
    mkdir -p /etc/decbot && \
    printf 'client: %s \ntoken: %s \ntts: { bin: /usr/local/bin/dectalk/DECTalk4_win32_bin } \nopus: /usr/lib/libopus.so.0 \n' "${CLIENT}" "${TOKEN}" > /etc/decbot/decbot.conf

RUN printf '#!/bin/sh\nXvfb :0 -screen 0 1024x768x16 & \nexport DISPLAY=:0.0 \ndecbot --config /etc/decbot/decbot.conf' > /start.sh && chmod +x ./start.sh

RUN apk del -r --purge \
   python3-dev \
   build-base \
   alsa-lib-dev \
   libffi-dev \
   git \
;

RUN decbot --config /etc/decbot/decbot.conf --invite

ENTRYPOINT ["/bin/sh", "/start.sh"]
