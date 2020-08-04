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

  get '/' do
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
      User.find(session[:user_id])
    end

    def find_user_by_id
      User.find_by_id(params[:id])
    end

    def set_session
      session[:user_id] = @user.id
  end
  end
end