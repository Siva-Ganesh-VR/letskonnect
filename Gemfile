source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

# Core
gem "rails", "~> 7.1.0"
gem "pg", "~> 1.5"
gem "puma", "~> 6.0"

# Asset pipeline & frontend
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "sprockets-rails"
gem "jbuilder"

# Auth
gem "bcrypt", "~> 3.1.7"

# Utilities
gem "pagy", "~> 6.0"
gem "bootsnap", require: false
gem "tzinfo-data", platforms: %i[windows jruby]

group :development, :test do
  gem "debug", platforms: %i[mri windows]
end

group :development do
  gem "web-console"
  gem "error_highlight", ">= 0.4.0", platforms: [:ruby]
end
