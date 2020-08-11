ENV['SINATRA_ENV'] ||= 'development'

require 'bundler/setup'
Bundler.require(:default, ENV['SINATRA_ENV'])

ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || {
                                          adapter: 'postgresql',
                                          database: "db/#{ENV['SINATRA_ENV']}.sqlite",
                                          pool: 10,
                                          timeout: 10_000
                                        })

require './app/controllers/application_controller'
require_all 'app'
