FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends     make git curl ca-certificates python3 python3-pip     latexmk texlive-latex-recommended texlive-latex-extra texlive-fonts-recommended texlive-xetex     fonts-freefont-ttf &&     rm -rf /var/lib/apt/lists/*
WORKDIR /workspace
