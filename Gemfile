source 'https://rubygems.org'

gem 'time_difference' 

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2.0'
gem 'bootstrap-sass', '~>2.3.2.0'
gem 'bcrypt-ruby'
# Use fake users gem
gem 'faker', '~> 1.1.2'

gem "jqcloud-rails"

#Use pagination
gem "will_paginate"
gem 'bootstrap-will_paginate' 
# Use sqlite3 as the database for Active Record
group :development, :test do
    gem 'bazaar', '~> 0.0.2'
    gem 'sqlite3', '1.3.8'
    gem 'pg'#, '0.15.1';
    gem 'rspec-rails', '~> 3.1'
end

group :test do
    gem "minitest"
    gem 'selenium-webdriver', '~> 2.35.1'
    gem 'capybara'
    gem 'factory_girl_rails' 
    gem 'timecop'
end

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :production do
    gem 'pg'#, '0.15.1'
    gem 'rails_12factor', '0.0.2'
    #For Apache
    gem 'therubyracer'

end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'
# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
