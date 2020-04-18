# ----------------------------------------------------------
#  Target: BASE - used for all subsequent images
# ----------------------------------------------------------
FROM debian:stable as BASE
RUN adduser --home /opt/unison --disabled-password unison
RUN apt-get update && apt-get install -y git wget libncurses5 less

# ----------------------------------------------------------
#  Target: RELEASE - an image that just contains
# ----------------------------------------------------------
FROM BASE as RELEASE

# You can override either of the following two ARGs on the command
# line when building the docker image, for example:
#
# $ docker build --target RELEASE --build-arg release=M1x -t unison:M1x .
#
# or to install perhaps from a .tar.gz from some other url:
#
# docker build --target RELEASE --build-arg release_url=https://example.com/some-other.tar.gz -t unison:M1x .

ARG release=M1i
ARG release_url=https://github.com/unisonweb/unison/releases/download/release%2F$release/unison-linux64.tar.gz

RUN cd /opt/unison                                && \
    wget -O- $release_url | tar xzf -             && \
    mv ./ucm /usr/local/bin/ucm                   && \
    chmod 555 /usr/local/bin/ucm

USER unison

ENTRYPOINT ["/usr/local/bin/ucm", "-codebase","/opt/unison/codebase"]

# --------------------------------------------------------------------
#  Target: BUILD - an image with the latest stck installed and with
#                  unison sourcechecked out, Typically this is only
#                  used as an intermediary step to building a HEAD
#                  image
#
#  args:   repo_url=https://github.com/unisonweb/unison.git
#              override with:
#              --build-arg repo_url=https://my.url/unison.git
#
#          branch=master
#              override with:
#              --build-arg branch=testbranch
# ----------------------------------------------------------
FROM BASE as BUILD

ARG branch=master
ARG repo_url=https://github.com/unisonweb/unison.git

RUN apt-get install -y libncurses-dev && wget -qO- https://get.haskellstack.org/ | sh 

USER unison

RUN cd /opt/unison                                                && \
    mkdir /opt/unison/install /opt/unison/codebase                && \
    git clone --recursive --branch $branch $repo_url unison       && \
    cd unison                                                     && \
    git submodule init                                            && \
    stack build                                                   && \
    stack install --prefix /opt/unison/install

# ----------------------------------------------------------
#  Target: HEAD - An image containing a binary built from
#                 source
# ----------------------------------------------------------

FROM BASE as HEAD
COPY --from=BUILD /opt/unison/install/bin/unison /usr/local/bin/ucm

VOLUME ["/opt/unison/codebase"]
ENTRYPOINT ["/usr/local/bin/ucm", "-codebase","/opt/unison/codebase"]

