FROM ubuntu:latest

CMD ["/sbin/my_init"]

WORKDIR /app

ENV TZ 'Etc/UTC'

RUN DEBIAN_FRONTEND=noninteractive \
    && echo $TZ > /etc/timezone \
    && apt-get -y update \
    && apt-get install -y gnupg net-tools iputils-ping curl wget unzip tzdata \
    && curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg \
    && mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg \
    && sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-bionic-prod bionic main" > /etc/apt/sources.list.d/dotnetdev.list' \
    && apt-get update

RUN apt-get install -y dotnet-sdk-2.2

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*