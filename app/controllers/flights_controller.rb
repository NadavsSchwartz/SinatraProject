class FlightController < ApplicationController
  get '/flights' do
    # pulls all airport data from db
    @airport = Airport.all
    erb :'flights/one_way_flight'
  end

  post '/flights' do
    # TODO: find a way to make it work with any user input, too hard coded.
    origin = params[:origin].split(' ,')[1]
    destination = params[:destination].split(' ,')[1]
    @flights = Flight.get_flight(origin, destination, params[:depart_date])
    if @flights['Quotes'].empty? || !!@flights['message']
      flash[:error] = "We Couldn't find any flights. Please go back and try again"
    else
      flights = Flight.set_flight
      @user = current_user
      @flights = Flight.where(origin_iata_code: origin, return_iata_code: destination)
      erb :'flights/index'
    end
  end

  get '/flights/:id' do
    @flight = Flight.find_by(id: params[:id])
    @user = current_user
    @cart = Cart.new(user_id: @user.id, flight_id: @flight.id)
    if @cart.save
      erb :'flights/show'
    else
      flash[:error] = 'We encountered a problem.'
    end
  end

  get '/flights/edit/:id' do
    if current_user.carts.find_by(user_id: current_user.id, flight_id: params[:id])
      @airport = Airport.all
      @user = current_user
      @current_flight = @user.flights.find(params[:id])
      erb :'flights/edit_flight'
    else
      flash.now[:error] = 'Error occured. please refresh the page and try again.'
    end
  end

  post '/flights/:id' do
    origin = params[:origin].split(' ,')[1]
    destination = params[:destination].split(' ,')[1]
    @flights = Flight.get_flight(origin, destination, params[:depart_date])
    if !!@flights['message'] || @flights['Quotes'].empty?
      flash[:error] = "We Couldn't find any flights for your updated search flight. Please go back and try again"
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
    binding.pry
    if current_user.carts.find_by(user_id: current_user.id, flight_id: params[:id])
      @flight = Flight.find(params[:id])
      @flight.destroy
      flash.now[:error] = 'Flight deleted.'
      redirect to '/users/account'
    else
      flash.now[:error] = "Error occured. You can not delete a flight that wasn't added to your account."
    end
  end
end
