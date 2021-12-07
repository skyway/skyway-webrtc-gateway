FROM alpine:3.10

#default 8000
ENV PORT_NUM 8000
#error/warn/debug
ENV LOG_LEVEL "error"

# Set the working directory to /skyway
WORKDIR /skyway

# Install alpien-pkg-glibc libgcc libuuid
# glibc packages for Alpine Linux are prepared by Sasha Gerrand and the releases are published in sgerrand/alpine-pkg-glibc github repo.
# https://github.com/sgerrand/alpine-pkg-glibc
RUN apk add --no-cache --virtual tmpPackages ca-certificates wget && \
    wget https://github.com/skyway/skyway-webrtc-gateway/releases/download/0.4.0/gateway_linux_x64 && \
    chmod +x ./gateway_linux_x64 && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.29-r0/glibc-2.29-r0.apk && \
    apk add glibc-2.29-r0.apk && \
    apk add libgcc && \
    apk add libuuid && \
    rm glibc-2.29-r0.apk && \
    rm /etc/apk/keys/sgerrand.rsa.pub && \
    rm /root/.wget-hsts && \
    echo [general] > ./config.toml && \
    echo api_port=$PORT_NUM >> ./config.toml && \
    echo log_level=\"$LOG_LEVEL\" >> ./config.toml && \
    apk del tmpPackages

ENV LD_LIBRARY_PATH /lib64:/lib:/usr/lib

# Run rest when the container launches
CMD ["/skyway/gateway_linux_x64"]
