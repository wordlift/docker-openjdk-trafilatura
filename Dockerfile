# https://pypi.org/project/cchardet/ cchardet 2.1.7 requires python 3.9 and gcc
# https://pypi.org/project/trafilatura/ trafilatura 1.4.0
FROM eclipse-temurin:21.0.3_9-jdk-jammy

LABEL org.opencontainers.image.source=https://github.com/wordlift/docker-openjdk-trafilatura
LABEL org.opencontainers.image.description="trafilatura + OpenJDK"

RUN \
    # Print executed commands to terminal.
    set -ex ; \
    savedAptMark="$(apt-mark showmanual)" ; \
    apt-get update ; \
    apt install -y python3.11 python3-pip libcurl4-openssl-dev libssl-dev

RUN pip install --upgrade pip

RUN \
    set -ex ; \
    pip install faust-cchardet==2.1.19 ; \
    pip install trafilatura[all]==2.0.0

RUN \
    apt-mark auto '.*' > /dev/null; \
    apt-mark manual $savedAptMark; \
    apt-mark hold python3.11 python3-pip ; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "trafilatura" ]

CMD [ "-h" ]
