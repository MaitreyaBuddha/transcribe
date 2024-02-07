FROM python:3.11-slim

RUN apt-get update && apt-get install -y \
    ffmpeg \
    vim \
    make \
    telnet \
    traceroute \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir \
        pipx==1.4.3 \
        yt-dlp==2024.2.5.232712.dev0

RUN pipx install transcribe-anything==2.7.25 && \
    pipx ensurepath && \
    rm -Rf /root/.cache/pip

ENV PATH=${PATH}:/root/.local/bin/

RUN yt-dlp --no-check-certificate https://vimeo.com/910700884/9b5b5993ce -o "out.%(ext)s"

RUN transcribe-anything https://vimeo.com/910700884/9b5b5993ce && \
    rm -Rf /root/.cache
