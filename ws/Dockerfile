FROM shanesveller/elixir-lang:latest

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -q && \
    apt-get -y install apt-transport-https && \
    apt-get update -q && \
    apt-get -y install git inotify-tools && \
    apt-get -y install erlang-dev erlang-tools && \
    apt-get clean -y && \
    rm -rf /var/cache/apt/*


COPY mix.* /usr/src/app/
COPY config /usr/src/app/

WORKDIR /usr/src/app

RUN mix deps.get

# RUN mix deps.compile

COPY . /usr/src/app

ENV PORT 4000
EXPOSE 4000
CMD ["mix","phoenix.server"]
