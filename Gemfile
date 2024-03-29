source 'https://rubygems.org'
ruby '2.0.0'

gem 'rails', '4.0.4'
gem 'pg'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.1'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'turbolinks'
gem 'jquery-turbolinks'
gem 'jbuilder', '~> 1.2'
# gem 'bootstrap-sass', '~> 3.0.3.0' # bootstrap 3
gem 'anjlab-bootstrap-rails', require: 'bootstrap-rails', github: 'anjlab/bootstrap-rails'
gem 'simple_form', git: 'git://github.com/plataformatec/simple_form'
gem 'devise', '~> 3.1.0' #authentication
gem 'kaminari' #pagination
gem 'bootstrap-kaminari-views', git: 'git://github.com/jharbert/bootstrap-kaminari-views'
gem 'cancan' #authorization
gem 'carrierwave' #file upload
gem 'mini_magick' # rmagick replacement
gem 'fog' # cloud services api
gem 'unf' # fog string encoding
gem 'mime-types' # mime types for carrierwave
gem 'stripe' #credit card processing
gem 'cocoon'
gem 'deep_cloneable', '~> 1.6.0'
gem 'draper', '~> 1.3' # Decorators
gem 'faker'
gem 'sunspot_rails' # search
gem 'sunspot_solr' # search
gem 'parse-ruby-client' # parse.com integration
gem 'gibbon' # mailchimp
gem 'rails_admin' # Admin interface
gem 'ice_cube' # Recurrence
gem 'rollbar' # exceptions / errors tracking
gem 'attr_encrypted' # encryption/decryption

group :doc do
  gem 'sdoc', require: false
end

group :development do
  gem 'quiet_assets'
  gem 'bullet'
  gem 'letter_opener'
end

group :development, :test do
  gem 'rspec-rails', '~> 2.0'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'pry-rails'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'database_cleaner'
  gem 'launchy'
end

group :production do
  gem 'unicorn', '4.6.3' # rack http server
  gem 'rails_12factor'
  gem 'google-analytics-rails'
end
