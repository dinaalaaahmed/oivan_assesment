FROM ruby:3.3.7-slim

# Accept build argument for environment
ARG RAILS_ENV=production
ENV RAILS_ENV=${RAILS_ENV}

# Use HTTPS for apt sources (more reliable)
RUN sed -i 's|http://deb.debian.org|https://deb.debian.org|g' /etc/apt/sources.list.d/debian.sources

# Install dependencies
RUN apt-get update -o Acquire::http::Timeout=30 -o Acquire::Retries=3 && \
    apt-get install -y --no-install-recommends \
      build-essential \
      libpq-dev \
      libyaml-dev \
      nodejs \
      npm \
      git \
      curl \
      tzdata \
      dos2unix && \
    npm install -g yarn && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy dependency files first (better layer caching)
COPY Gemfile Gemfile.lock ./

# Install Ruby dependencies
RUN gem install bundler -v 2.7.2 && \
    if [ "$RAILS_ENV" = "production" ]; then \
      bundle config set --local without 'development test' && \
      bundle config set --local deployment true; \
    fi && \
    bundle config set --local force_ruby_platform true && \
    bundle install --jobs 4 --retry 3

# Copy application code
COPY . .

# Fix line endings for all script files (Windows compatibility)
RUN find . -type f -name "*.rb" -exec dos2unix {} \; && \
    find . -type f -name "*.rake" -exec dos2unix {} \; && \
    find bin -type f -exec dos2unix {} \; && \
    find config -type f -exec dos2unix {} \; 2>/dev/null || true

# Precompile assets only in production
RUN if [ "$RAILS_ENV" = "production" ]; then \
      SECRET_KEY_BASE=dummy bundle exec rails assets:precompile; \
    fi

# Create non-root user for security (production only)
RUN if [ "$RAILS_ENV" = "production" ]; then \
      groupadd -r rails && useradd -r -g rails rails && \
      chown -R rails:rails /app; \
    fi

# Expose port
EXPOSE 3000

# Start server
CMD ["bin/rails", "server", "-b", "0.0.0.0"]