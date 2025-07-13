FROM ruby:3.4-slim as jekyll

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js for staticrypt
RUN apt-get update && apt-get install -y --no-install-recommends \
    nodejs npm \
    && rm -rf /var/lib/apt/lists/*
# Install staticrypt globally
RUN npm install -g staticrypt

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

COPY Gemfile Gemfile.lock ./
RUN bundle install

RUN ruby --version && bundle --version && gem install bundler
RUN gem update --system && gem install jekyll && gem cleanup

EXPOSE 4000
WORKDIR /site

FROM jekyll as jekyll-serve

CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0"]
