# Base image to build Alpine packages
# abuild refuses to run as root, so we need to create a user
# and a trusted set of keys
FROM alpine:3.10.1

RUN apk --no-cache add alpine-sdk
RUN adduser -G abuild -D effortman
RUN sed -i -e 's/^# \%sudo[[:space:]]*ALL=(ALL)/%sudo ALL=(ALL) NOPASSWD:/g' /etc/sudoers && \
    addgroup -S sudo && \
    addgroup effortman sudo

USER effortman
WORKDIR /home/effortman/

# Keys are installed in /home/effortman/.abuild/*.rsa[.pub]
RUN abuild-keygen -a -n -i
