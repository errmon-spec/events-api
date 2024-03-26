FROM ruby:3.3.0-slim-bookworm

SHELL ["/bin/bash", "-o", "errexit", "-o", "pipefail", "-o", "nounset", "-c"]

# hadolint ignore=DL3008
RUN apt-get update -qq \
    && apt-get install --no-install-recommends -y \
        build-essential \
        ca-certificates \
        curl \
        git \
        gnupg2 \
        libpq-dev \
        postgresql-client \
        ssh \
        vim \
        wget \
    && rm -rf /var/lib/apt/lists/*

ENV BUNDLER_VERSION="2.5.6"
RUN gem update --system \
    && gem install bundler:$BUNDLER_VERSION

ENV HADOLINT_VERSION="2.12.0"
RUN case "$(dpkg --print-architecture)" in \
      arm64) HADOLINT_ARCH="arm64" ;; \
      *) HADOLINT_ARCH="x86_64" ;; \
    esac \
    && curl -fsSL "https://github.com/hadolint/hadolint/releases/download/v${HADOLINT_VERSION}/hadolint-Linux-${HADOLINT_ARCH}" \
            --output /usr/bin/hadolint \
    && chmod +x /usr/bin/hadolint

RUN curl -L https://fly.io/install.sh | sh
ENV FLYCTL_INSTALL="/root/.fly"
ENV PATH="$FLYCTL_INSTALL/bin:$PATH"

ENV BUNDLE_APP_CONFIG=".bundle" \
    BUNDLE_PATH="vendor/bundle" \
    LANG="C.UTF-8" \
    RUBY_YJIT_ENABLE="1"

COPY --link ./dotfiles/.bashrc /root/.bashrc

EXPOSE 3000

WORKDIR /app

CMD ["/bin/bash"]
