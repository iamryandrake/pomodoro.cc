FROM shanesveller/elixir-lang:latest

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -q && \
    apt-get -y install git inotify-tools && \
    apt-get -y install erlang-dev erlang-ssl erlang-inets erlang-dev && \
    apt-get -y install erlang-edoc erlang-eunit erlang-tools erlang-common-test && \
    apt-get clean -y && \
    rm -rf /var/cache/apt/*


COPY mix.* /usr/src/app/
COPY config /usr/src/app/

WORKDIR /usr/src/app

RUN mix clean
RUN mix deps.get
RUN mix deps.compile
RUN mix compile

COPY . /usr/src/app

ENV PORT 4000
EXPOSE 4000
CMD ["mix","phoenix.server"]
