require './config/environment'
require 'sinatra'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'
# raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.' if ActiveRecord::Migrator.needs_migration?

# use ActiveRecord::ConnectionAdapters::ConnectionManagement

use FlightController
use CartsController
use UsersController
run ApplicationController
