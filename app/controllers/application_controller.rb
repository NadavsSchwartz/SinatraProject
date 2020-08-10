require './config/environment'
require 'sinatra'
require 'sinatra/flash'

class ApplicationController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, 'test'
    register Sinatra::Flash
  end

  error Sinatra::NotFound do
    content_type 'text/plain'
    [404, "couldn't find the page you were looking for because it doesn't exist.

Return to the homepage

Error code: 404"]
  end

  get '/' do
    @flights = Flight.last(12)
    if !logged_in?
      erb :index
    else
      @user = current_user
      erb :index
    end
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find_by(id: session[:user_id])
    end

    def find_user_by_id
      User.find_by_id(params[:id])
    end

    def set_session
      session[:user_id] = @user.id
  end
  end
end
