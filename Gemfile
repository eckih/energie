source 'https://rubygems.org'

ruby '1.9.3'

gem 'rails_12factor'

gem 'rails',     :git => 'git://github.com/rails/rails.git', :branch => '3-2-stable'
gem 'journey',   :git => 'git://github.com/rails/journey.git', :branch => '1-0-stable'
gem 'arel',      :git => 'git://github.com/rails/arel.git', :branch => '3-0-stable'

gem "heroku"
gem 'capistrano', '~> 3.0.1'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'# ,   :git => 'git://github.com/rails/sass-rails.git', :branch => '3-2-stable'
  gem 'coffee-rails', :git => 'git://github.com/rails/coffee-rails.git', :branch => '3-2-stable'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'mysql2'
end

group :production do
  gem 'pg'
  gem 'thin'
end

gem 'jquery-rails'

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

#gem 'execjs'
gem 'therubyracer'
gem 'best_in_place'
gem 'highcharts'
#
gem "active_model_serializers"
