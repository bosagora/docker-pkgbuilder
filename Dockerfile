# Base image to build Alpine packages
# abuild refuses to run as root, so we need to create a user
# and a trusted set of keys
FROM alpine:edge

RUN echo 'http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories
RUN apk --no-cache upgrade && apk --no-cache add alpine-sdk dmd dub dtools-rdmd emacs gdmd ldc sudo wget zsh
RUN adduser -G abuild -D effortman
RUN wget -O /home/effortman/.zshrc https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc
RUN sed -i -e 's/^# \%sudo[[:space:]]*ALL=(ALL)/%sudo ALL=(ALL) NOPASSWD:/g' /etc/sudoers && \
    addgroup -S sudo && \
    addgroup effortman sudo

USER effortman
WORKDIR /home/effortman/

# Keys are installed in /home/effortman/.abuild/*.rsa[.pub]
RUN abuild-keygen -a -n -i
