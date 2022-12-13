# https://pypi.org/project/cchardet/ cchardet 2.1.7 requires python 3.9 and gcc 
# https://pypi.org/project/trafilatura/ trafilatura 1.4.0
FROM openjdk:18-slim-bullseye

RUN \
    # Print executed commands to terminal.
    set -ex ; \ 
    savedAptMark="$(apt-mark showmanual)" ; \
    apt-get update ; \
    apt install -y python3.9 python3-pip libcurl4-openssl-dev libssl-dev

RUN pip install --upgrade pip

RUN \
    set -ex ; \ 
    pip install cchardet==2.1.7 ; \
    pip install trafilatura[all]==1.4.0

RUN \
    apt-mark auto '.*' > /dev/null; \
    apt-mark manual $savedAptMark; \
    apt-mark hold python3.9 python3-pip ; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "trafilatura" ]

CMD [ "-h" ]
