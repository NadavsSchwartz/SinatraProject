class FlightController < ApplicationController
  get '/flights' do
    # pulls all airport data from db
    @airport = Airports.all
    erb :'flights/one_way_flight'
  end

  post '/flights' do
    # Edits user input from autocomplete to match data requirements for the api
    origin = params[:origin].split(' ,')[1]
    destination = params[:destination].split(' ,')[1]

    # Gets the flight data from api & validate it
    @flights = Flight.get_flight(origin, destination, params[:depart_date])
    if @flights['ValidationErrors'] || !!@flights['message']
      flash[:error] = "We Couldn't find any flights. Please go back and try again"
    elsif @flights['Quotes'].empty?
      flash[:error] = 'The search came empty. Please go back and try again'
    else
      # set flight in the DB if passed validation test
      flights = Flight.set_flight
      @user = current_user
      # pull the flight based on params
      @flights = Flight.where(origin_iata_code: origin, return_iata_code: destination)
      erb :'flights/index'
    end
  end

  get '/flights/:id' do
    @flight = Flight.find_by(id: params[:id])
    if !!@flight
      erb :'flights/show'
    else
      flash.now[:error] = "That flight doesn't exist!, Please go back and try again :)"
    end
  end
  post '/flights/:id' do
    # Just a precaution validation on top of changing it to POST from GET to avoid user accesing the data
    if current_user.nil? || @flight = Flight.find_by(id: params[:id]).nil?
      flash[:error] = 'You need to be logged in and have the flight added to your account, in order to see/edit/delete flights'
    else
      @user = current_user
      @flight = Flight.find_by(id: params[:id])
      @cart = Cart.find_or_create_by(user_id: @user.id, flight_id: @flight.id)
      erb :'flights/add_to_profile' if @cart.save
    end
  end

  get '/flights/edit/:id' do
    # validate if user is logged in and if flight exists in user's profile
    if current_user.nil? || !current_user.carts.find_by(user_id: current_user.id, flight_id: params[:id])
      flash[:error] = 'You need to be logged in and have the flight added to your account, in order to see/edit/delete flights'
    else
      @airport = Airports.all
      @current_flight = current_user.flights.find(params[:id])
      erb :'flights/edit_flight'
    end
  end

  post '/flights/update/:id' do
    # update flight directly from user profile and update the card with links & info
    origin = params[:origin].split(' ,')[1]
    destination = params[:destination].split(' ,')[1]
    @flights = Flight.get_flight(origin, destination, params[:depart_date])
    if @flights['ValidationErrors'] || !!@flights['message']
      flash[:error] = "We Couldn't find any flights With that input. Please go back and try again"
    elsif @flights['Quotes'].empty?
      flash[:error] = 'The search came empty. Please go back and try again'
    else
      set_flight = Flight.set_flight
      user_flight = Flight.find_by(id: params[:id])
      user_flight.origin = params[:origin]
      user_flight.destination = params[:destination]
      user_flight.origin_date = params[:depart_date]
      user_flight.cost = set_flight[0]['cost']
      user_flight.origin_iata_code = set_flight[0]['origin_iata_code']
      user_flight.return_iata_code = set_flight[0]['return_iata_code']
      user_flight.save!
      redirect '/users/account'
        end
  end

  get '/flights/delete/:id' do
    # validate that user is logged in & added the flight to his account & hasn't deleted it already
    if !logged_in?
      flash[:error] = 'You need to be logged in, in order to edit/delete flights'
    else
      if current_user.carts.find_by(user_id: current_user.id, flight_id: params[:id])
        if current_user.flights.ids.include? params[:id].to_i
          flight = Flight.find_by(id: params[:id])
          flight.destroy
          flash.now[:error] = 'Flight deleted.'
          redirect to '/users/account'
        else
          flash.now[:error] = 'You already deleted that flight from your account.'
        end
      else
        flash.now[:error] = "Error occured. You can not delete a flight that doesn't exist in your profile."
        end
    end
  end
end
