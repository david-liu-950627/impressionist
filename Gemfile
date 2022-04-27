source 'https://rubygems.org'

gem 'rake', '>= 0.9'
gem 'rdoc', '>= 2.4.2'

platforms :jruby do
  gem 'activerecord-jdbcsqlite3-adapter'
  gem 'jdbc-sqlite3'
  gem 'jruby-openssl'
end

platforms :ruby, :mswin, :mingw do
  gem 'sqlite3'
end

group :test do
  gem 'capybara', '>= 2.0.3'
  gem 'rails', '>= 6.0.4.8'
  gem 'rspec-rails'
  gem 'simplecov'
  gem 'systemu'
end

gemspec
