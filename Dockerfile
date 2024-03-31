FROM ruby:3.3

WORKDIR /app

# Kopiere das Gemfile und Gemfile.lock in das Image
COPY Gemfile Gemfile.lock ./

# Installiere die Gems
RUN bundle install

# Kopiere den restlichen Code
COPY . /app

# Führe die generate.rb Datei aus
CMD ["ruby", "generate.rb"]
