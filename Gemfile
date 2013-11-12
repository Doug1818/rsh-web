source 'https://rubygems.org'
ruby "2.0.0"

gem 'rails', '4.0.1'
gem 'pg'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'turbolinks'
gem 'jquery-turbolinks'
gem 'jbuilder', '~> 1.2'
gem 'anjlab-bootstrap-rails', require: 'bootstrap-rails', github: 'anjlab/bootstrap-rails'
gem 'simple_form', git: 'git://github.com/plataformatec/simple_form'
gem 'devise', '~> 3.1.0' #authentication
gem 'kaminari' #pagination
gem 'bootstrap-kaminari-views', git: 'git://github.com/jharbert/bootstrap-kaminari-views'
gem 'cancan' #authorization
gem 'carrierwave' #file upload
gem 'mini_magick' # rmagick replacement
gem "fog" # cloud services api
gem 'unf' # fog string encoding
gem 'stripe' #credit card processing
gem 'cocoon'

group :doc do
  gem 'sdoc', require: false
end

group :development do
  gem 'quiet_assets'
end

group :development, :test do
  gem 'rspec-rails', '~> 2.0'
  gem 'factory_girl_rails', '~> 4.0'
end

group :test do
  gem 'debugger'
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'database_cleaner'
end

group :production do
  gem 'unicorn', '4.6.3' # rack http server
end
