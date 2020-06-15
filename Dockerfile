FROM ubuntu:18.04

LABEL maintainer "GHIFARI160 <ghifari@ghifari160.com>"

# ENV DEBIAN_FRONTEND=noninteractive

RUN set -x && \
    apt update && \
    apt upgrade -y && \
    apt autoremove -y && \
    apt install --no-install-recommends --no-install-suggests -y curl ca-certificates && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir /init

################
## Supervisor ##
################
RUN set -x && \
    apt update && \
    apt install --no-install-recommends --no-install-suggests -y supervisor && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

################
##    GOSU    ##
################
ENV GOSU_VERSION 1.12
RUN set -eux && \
    apt update && \
    apt install --no-install-recommends --no-install-suggests -y ca-certificates dirmngr gnupg wget && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* && \
    dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" && \
    wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" && \
    wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" && \
    export GNUPGHOME="$(mktemp -d)" && \
    gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 && \
    gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu && \
    command -v gpgconf && gpgconf --kill all || :; \
    rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc && \
    apt purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false && \
    chmod +x /usr/local/bin/gosu && \
    gosu --version && \
    gosu nobody true

################
##   Node.JS  ##
################
ENV NODE_ENV production

RUN set -x && \
    addgroup --system --gid 104 node && \
    adduser --system --ingroup node --no-create-home --home /nonexistent --gecos "node user" --shell /bin/false --uid 104 node && \
    curl -sL https://deb.nodesource.com/setup_12.x | bash && \
    apt update && \
    apt install --no-install-recommends --no-install-suggests -y nodejs && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

################
##   Ghost    ##
################
ENV GHOST_PORT=2368
ENV GHOST_URL=http://localhost:2368
ENV GHOST_ADMIN_URL=http://localhost:2368

RUN set -x && \
    npm install -g ghost-cli && \
    mkdir -p /var/www/ghost

COPY ghost.sh /init/ghost.sh
COPY ghost-setup.sh /init/ghost-setup.sh
COPY supervisor-ghost.conf /etc/supervisor/conf.d/ghost.conf

VOLUME /var/www/ghost

EXPOSE 2368

CMD [ "/usr/bin/supervisord" ]