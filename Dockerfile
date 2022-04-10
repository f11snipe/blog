FROM ruby:2.7

ENV BASE_DIR /blog

RUN gem install bundler jekyll && \
    mkdir -p ${BASE_DIR}

WORKDIR ${BASE_DIR}

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

CMD [ "bundle", "exec", "jekyll", "serve", "--host=0.0.0.0", "--livereload" ]
