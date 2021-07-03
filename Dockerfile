# syntax=docker/dockerfile:1
FROM i386/alpine:3.14 AS build
WORKDIR /tmp
RUN apk add --no-cache \
      python3 \
      py3-pip \
      python3-dev \
      build-base \
      alsa-lib-dev \
      libffi-dev \
      git && \
    pip install discord.py pydub pyyaml pynacl && \
    git clone https://github.com/uebergucken/DECbot.git && \
    cd /tmp && git clone https://github.com/uebergucken/DECTalk4_win32_bin.git

FROM i386/alpine:3.14
ARG CLIENT
ARG TOKEN
WORKDIR /tmp
RUN apk add --no-cache \
    python3 \
    py3-pip \
    opus \
    ffmpeg \
    xvfb && \
    printf 'https://dl-cdn.alpinelinux.org/alpine/v3.12/main\nhttps://dl-cdn.alpinelinux.org/alpine/v3.12/community\n' > /etc/apk/repositories && \
    apk add --no-cache \
    wine && \
    rm -rf /var/lib/apt/lists/*
RUN Xvfb :0 -screen 0 1024x768x16 &
RUN export DISPLAY=:0.0 && wineboot
RUN mkdir -p /usr/local/bin/dectalk/ && mkdir -p /etc/decbot/
COPY --from=build /usr/lib/python3.9/site-packages/ /usr/lib/python3.9/site-packages/
COPY --from=build /tmp/DECTalk4_win32_bin/ /usr/local/bin/dectalk/
COPY --from=build /tmp/DECbot/ /tmp/DECbot/
RUN cd /tmp/DECbot && pip install .
RUN printf '#!/bin/sh\nXvfb :0 -screen 0 1024x768x16 & \nexport DISPLAY=:0.0 \ndecbot --config /etc/decbot/decbot.conf' > /start.sh
RUN chmod +x /start.sh && printf 'client: %s \ntoken: %s \ntts: { bin: /usr/local/bin/dectalk } \nopus: /usr/lib/libopus.so.0 \n' "${CLIENT}" "${TOKEN}" > /etc/decbot/decbot.conf
RUN decbot --config /etc/decbot/decbot.conf --invite

ENTRYPOINT ["/bin/sh", "/start.sh"]
