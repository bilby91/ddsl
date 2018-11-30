FROM docker:18.05

LABEL maintainer="Martín Fernández <fmartin91@gmail.com>"

# Application directory
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

# Install docker-compose
RUN pip install docker-compose

# Install ruby dependencies
RUN gem install bundler --no-ri

WORKDIR ${APP_HOME}

# Copy only Gemfile for caching
COPY lib/ddsl/version.rb $APP_HOME/lib/ddsl/version.rb
COPY Gemfile* *.gemspec $APP_HOME/

# Install ruby dependencies
RUN bundle install

# COPY app to container
COPY . $APP_HOME

# Build the gem locally
RUN gem build ddsl.gemspec

# Install binary
# FIXME: We need to load the version dynamically
RUN gem install --no-rdoc --no-ri --local ddsl-0.0.2.gem
