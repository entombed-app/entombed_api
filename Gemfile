source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

gem 'rails', '~> 5.2.6'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'figaro'
gem 'faraday'
gem 'jsonapi-serializer'
gem 'bcrypt'
gem "aws-sdk-s3", require: false
gem 'rack-cors'
gem 'image_processing', '~> 1.2'
gem 'active_storage_validations'

group :development, :test do
  gem 'pry'
  gem 'simplecov'
  gem 'rubocop-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'travis'
end

group :test do
  gem 'rspec-rails'
  gem 'database_cleaner-active_record'
  gem 'shoulda-matchers'
  gem 'launchy'
  gem 'orderly'
  gem 'capybara'
  gem 'webmock'
  gem 'vcr'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'listen', '>= 3.0.5', '< 3.2'
gem 'spring'
gem 'spring-watcher-listen', '~> 2.0.0'
