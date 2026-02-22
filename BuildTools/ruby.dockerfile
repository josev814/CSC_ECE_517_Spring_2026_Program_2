FROM ruby:3.4.8-trixie

SHELL ["/bin/bash", "-c"]

# where our project lives in docker
ENV PROJECT_DIR='/opt/project'

# using workdir creates it
WORKDIR $PROJECT_DIR

RUN apt-get update -qq \
    && apt-get install --no-install-recommends -y \
      build-essential \
      libsqlite3-dev \
      pkg-config \
      tzdata \
      curl \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

ARG NODE_MAJOR_VERSION=20

RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_MAJOR_VERSION}.x | bash - \
    && apt-get update \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

ENV BUNDLE_PATH='/usr/local/bundle' \
    BUNDLE_DEPLOYMENT='1'

COPY Gemfile ./

## if we're in dev don't use the gemfile.lock freeze
RUN if [[ "${RAILS_ENV}" != 'production' ]]; then \
      bundle config set frozen false \
      ; \
    fi

# Using mount type in case gemfile.lock doesn't exist
# if it does exist the mount will allow for the .lock file to be used
RUN bundle lock --add-platform x86_64-linux \
    && bundle install \
    && rm -rf ~/.bundle/ ${BUNDLE_PATH}/ruby/*/cache ${BUNDLE_PATH}/ruby/*/bundler/gems/*/.git \
    && bundle exec bootsnap precompile --gemfile \
    && cp ./Gemfile.lock /var/local/Gemfile.lock

# Copy application code
COPY . .

ARG RAILS_ENV=${RAILS_ENV:-production}
ENV RAILS_ENV=${RAILS_ENV}
ARG UID=1000
ARG GID=1000

# Compile bootsnap code, we're only including app if we're in prod
RUN precompile_paths=('lib/') \
    && if [[ "${RAILS_ENV}" == 'production' ]]; then precompile_paths+=('app/'); fi \
    && bundle exec bootsnap precompile ${precompile_paths[@]}


# ignore rails master key
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

RUN groupadd -g ${GID} ruby \
    && useradd --create-home --no-log-init -u ${UID} -g ${GID} --shell /bin/bash ruby \
    && mkdir /node_modules \
    && dirs=(/node_modules db tmp log storage) \
    && for entry in "${dirs[@]}"; do if ! [ -d "${entry}" ]; then continue; fi; chown ruby:ruby -R "${entry}"; done \
    && if [[ "${RAILS_ENV}" != 'production' ]]; then \
        apt-get update \
        && apt-get install -y --no-install-recommends sudo \
        && usermod -aG sudo ruby \
        && echo 'ruby ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/ruby_sudo \
        && rm -rf /var/lib/apt/lists/* \
        && apt-get clean \
        ; \
      fi

EXPOSE 3000

USER ruby

COPY "BuildTools/entrypoint.sh" /

ENTRYPOINT [ "bash", "/entrypoint.sh" ]
CMD [ "bundle", "exec", "rails", "s", "-b", "0.0.0.0", "--port=3000", "-e", "$RAILS_ENV" ]