FROM python:3.11-slim

RUN apt-get update && apt-get install -y \
    ffmpeg \
    vim \
    make \
    telnet \
    && rm -rf /var/lib/apt/lists/*

RUN python -m pip install --upgrade pip && pip install pipx && pipx ensurepath

RUN pipx install transcribe-anything

RUN transcribe-anything https://www.youtube.com/clip/UgkxR-aq_SeT9YnV5skFVvblU4tlH5wJKZhH
