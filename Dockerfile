# syntax = docker/dockerfile:1

FROM ruby:3.3.0-slim-bookworm AS base

WORKDIR /app

ENV BOOTSNAP_READONLY="1" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_WITHOUT="development:test" \
    PORT="8080" \
    RAILS_ENV="production" \
    RACK_ENV="production" \
    RUBY_ENV="production"

##
## Intermediate image
##

FROM base AS build

# hadolint ignore=DL3008
RUN apt-get update -qq \
    && apt-get install --no-install-recommends -y \
        build-essential \
        libpq-dev \
    && rm -rf /var/lib/apt/lists/*

COPY --link Gemfile Gemfile.lock .ruby-version ./
RUN bundle install \
    && bundle clean --force \
    && bundle exec bootsnap precompile --gemfile \
    && rm -rf --verbose \
        vendor/bundle/ruby/*/cache \
        vendor/bundle/ruby/*/bundler/gems/*/.git

COPY --link . .
RUN bundle exec bootsnap precompile app/ lib/

##
## Final image
##

FROM base

# hadolint ignore=DL3008
RUN apt-get update -qq \
    && apt-get install --no-install-recommends -y \
        libjemalloc2 \
        libpq-dev \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build /app /app

RUN groupadd --system errmon \
    && useradd errmon --gid errmon --system --no-create-home --home /nonexistent --shell /bin/false \
    && chown -R errmon:errmon tmp/

ENV LD_PRELOAD="libjemalloc.so.2" \
    RUBY_YJIT_ENABLE="1"

USER errmon:errmon

EXPOSE 8080

CMD ["bin/puma", "-C", "config/puma.rb"]
