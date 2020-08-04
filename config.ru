require './config/environment'
require 'sinatra'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'
require 'amadeus'
raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.' if ActiveRecord::Migrator.needs_migration?

use FlightController
use CartsController
use UsersController
run ApplicationController
