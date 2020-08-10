require 'bundler/setup'
Bundler.require(:default, 'development')

ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || {
                                          adapter: 'postgresql',
                                          database: 'db/development.sqlite'
                                        })

require './app/controllers/application_controller'
require_all 'app'
