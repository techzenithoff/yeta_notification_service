source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.7'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.7', '>= 6.1.7.10'
# Use sqlite3 as the database for Active Record
#gem 'sqlite3', '~> 1.4'
# Use Puma as the app server
#gem 'puma', '~> 5.0'
gem 'puma', '~> 3.11'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  #gem 'spring'
  gem 'spring', '4.2.1'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]


#gem 'concurrent-ruby', '1.3.4' 


#gem 'rails', '~> 6.1.7'
#gem 'pg'
#gem 'puma'

gem 'pg', '~> 1.5', '>= 1.5.9'

# Background jobs
#gem 'sidekiq'
gem 'redis', '~> 4.0'
gem 'sidekiq', '~> 7.3', '>= 7.3.9'

# Messaging
#gem 'racecar'
#gem 'racecar', '~> 2.12'
#gem 'racecar', '~> 2.11'



#group :production, :staging do
#  gem 'racecar', '~> 2.11'
#end




#gem 'bunny'
gem 'bunny', '~> 2.24'

gem "ruby-kafka", "~> 1.5"

# Auth
#gem 'jwt'
gem 'jwt', '~> 3.1', '>= 3.1.2'

# HTTP
#gem 'faraday'
gem 'faraday', '~> 2.14', '>= 2.14.1'

# Templates
#gem 'liquid'
gem 'liquid', '~> 5.11'

# Observability
#gem 'lograge'
gem 'lograge', '~> 0.14.0'

# Rate limiting
#gem 'rack-attack'
gem 'rack-attack', '~> 6.8'

gem 'dotenv', groups: [:development, :test]