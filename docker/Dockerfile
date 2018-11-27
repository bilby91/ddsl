FROM docker:18.05

LABEL maintainer="Martín Fernández <mfernandez@geoforce.com>"

ENV APP_HOME /var/www/app

# Install the base tooling
RUN apk add --no-cache \
      build-base \
      gcc \
      python \
      py-pip \
      python-dev \
      gettext \
      curl \
      bash \
      git \
      ruby \
      ruby-dev \
      ruby-bigdecimal 

# Install untrusted packages (separate line for scoping)
RUN apk add --no-cache \
    --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ \
    --allow-untrusted \
    aws-cli

# Install docker-compose
RUN pip install docker-compose

# Install ruby dependencies
RUN gem install builder bundler --no-ri

WORKDIR ${APP_HOME}

# Copy only Gemfile for caching
COPY lib/ddsl/version.rb $APP_HOME/lib/ddsl/version.rb
COPY Gemfile* *.gemspec $APP_HOME/

# Install ruby dependencies
RUN bundle install

# COPY app to container
COPY . $APP_HOME

