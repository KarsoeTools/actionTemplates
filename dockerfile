FROM raonigabriel/web-terminal:latest

# Build argument that can be set from workflow
ARG BUILD_VERSION=latest
ENV BUILD_VERSION=${BUILD_VERSION}

ARG USER
ENV USER=${USER}

ARG USER_SECRET
ENV USER_SECRET=${USER_SECRET}

RUN rm /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/v3.14/main" >> /etc/apk/repositories && \
    echo "https://dl-cdn.alpinelinux.org/alpine/v3.18/community" >> /etc/apk/repositories && \
    apk add --no-cache --allow-untrusted  curl nano git g++ make npm docker-cli helm && \
    npm install -g yarn typescript @angular/cli && \
    addgroup -g 1000 docker && \
    adduser -s /bin/sh -u 1000 -D -G docker developer && \
    mkdir /home/developer/.ngrok2 && \
    echo "web_addr: 0.0.0.0:4040" > /home/developer/.ngrok2/ngrok.yml && \
    echo "tunnels:" >> /home/developer/.ngrok2/ngrok.yml && \
    echo "  nodejs:" >> /home/developer/.ngrok2/ngrok.yml && \
    echo "    proto: http" >> /home/developer/.ngrok2/ngrok.yml && \
    echo "    addr: 3000" >> /home/developer/.ngrok2/ngrok.yml && \
    chown -R developer:docker /home/developer/.ngrok2
 
USER developer
WORKDIR /home/developer
CMD ttyd -c "$USER:$USER_SECRET" -s 3 -t "titleFixed=/bin/sh" -t "rendererType=webgl" -t "disableLeaveAlert=true" /bin/sh -i -l
