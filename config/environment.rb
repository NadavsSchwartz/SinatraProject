ENV['SINATRA_ENV'] ||= "development"

require 'bundler/setup'
Bundler.require(:default, ENV['SINATRA_ENV'])

ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || {
                                          adapter: 'postgresql',
<<<<<<< HEAD
                                          database: "db/#{ENV['SINATRA_ENV']}.sqlite"
=======
                                          database: "db/#{ENV['SINATRA_ENV']}.sqlite",
                                          pool: 10
>>>>>>> parent of 28e2f9a... trial
                                        })

require './app/controllers/application_controller'
require_all 'app'
