source 'https://rubygems.org'

ruby '2.2.0'

gem 'rails'        , '4.1.9'
gem 'pg'           , '>= 0.18.1'
gem 'sass-rails'   , '~> 4.0.5'
gem 'uglifier'     , '>= 1.3.0' # Use Uglifier as compressor for JavaScript assets
gem 'coffee-rails' , '~> 4.1.0' # Use CoffeeScript for .js.coffee assets and views
gem 'haml-rails'   , '>= 0.7.0' # Template love
gem 'haml'         , '~> 4.0.6'

gem 'spree',             git: 'https://github.com/spree/spree.git',             branch: '2-4-stable'
gem 'spree_gateway',     git: 'https://github.com/spree/spree_gateway.git',     branch: '2-4-stable'
gem 'spree_auth_devise', git: 'https://github.com/spree/spree_auth_devise.git', branch: '2-4-stable'

gem 'jquery-rails'                       # Use jquery as the JavaScript library
gem 'turbolinks'                         # Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'jbuilder', '~> 2.0'                 # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'aws-sdk' , '~> 1.60.2'              # Required for Paperclip to be able to use s3
gem 'sdoc'    , '~> 0.4.0',  group: :doc # bundle exec rake doc:rails generates the API under doc/api.
gem 'puma'                               # Use puma as the app server
gem 'rails_12factor', group: :production

group :development do
  gem 'spring'     # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'pry-rails'  # Ruby console par excellence
  gem 'xray-rails' # Utility to enable view/partial hacking with cmd+shift+x (Mac) or ctrl+shift+x
end
