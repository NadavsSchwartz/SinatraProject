class UsersController < ApplicationController
  get '/users/register' do
    if logged_in?
      flash[:error] = "You're already logged in "
      redirect to '/users/account'
    else
      erb :'users/register'
    end
  end

  post '/users/register' do
    @user = User.new(name: params[:name], email: params[:email], password: params[:password])
    if @user.save
      redirect to '/users/login'
    else
      flash.now[:warning] = 'This email is already taken. Please pick a new one or log in.'
      erb :'users/register'
    end
  end

  get '/users/login' do
    if !logged_in?
      erb :'users/login'
    else
      @user = current_user
      redirect to '/'
    end
  end

  post '/users/login' do
    @user = User.find_by(email: params[:email])
    if @user&.authenticate(params[:password].to_s)
      session[:user_id] = @user.id
      redirect to '/users/account'
    else
      redirect 'users/login', notice: 'incorrect credentials'
   end
  end

  get '/users/account' do
    if logged_in?
      @user = current_user
      erb :'/users/account'
    else
      redirect to '/users/login'
    end
  end

  get '/users/logout' do
    if logged_in?
      flash.now[:error] = 'You have logged out successfuly'
      session.clear
      redirect to '/'
    else
      flash.now[:error] = "You can't log out if you're not logged in"
      redirect to '/users/account'
    end
  end
end
