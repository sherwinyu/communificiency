source 'https://rubygems.org'

local_gemfile = File.dirname(__FILE__) + "/Gemfile.local.rb"
if File.file?(local_gemfile)
  self.instance_eval(Bundler.read_file(local_gemfile))
end


group :development do
end

group :development, :test do
  gem 'sqlite3', '1.3.5'
  gem 'rspec-rails', '2.10.0'
  gem 'guard-rspec', '0.5.5'
  gem 'pry', '~> 0.9.9.6'
  gem 'pry-rails'
end

group :production do
  gem 'pg', '0.12.2'
end

group :test do
  gem 'capybara', '1.1.2'
  gem 'guard-spork', '0.3.2'
  gem 'spork', '0.9.0'
  gem 'factory_girl_rails', '1.4.0'
  gem 'shoulda'
end


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '3.2.4'
  gem 'coffee-rails', '3.2.2'
  gem 'uglifier', '1.2.3'
  gem 'bootstrap-sass', '~> 2.0.3'
end

gem 'bootstrap-sass', '~> 2.0.3'
gem 'rails', '3.2.5'
gem 'jquery-rails', '~> 2.0.0'
gem 'rest-client', '~> 1.6.7'

gem 'stripe'
gem 'stripe_event'

gem 'devise'
gem 'redcarpet' 
gem 'simple_form'
gem 'cocoon'
gem 'client_side_validations'
gem 'client_side_validations-simple_form'
gem 'formtastic'
# gem 'nested_form'
gem 'faker', '1.0.1'
gem 'bootstrap-will_paginate', '0.0.6'
gem 'meta-tags', :require => 'meta_tags'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
