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
    if @flights.nil?
      redirect to '/flights', error: "We Couldn't find any flight."
    else
      @user = current_user
      @flights = Flight.where(origin_iata_code: origin, return_iata_code: destination)
      erb :'flights/show_flight'
    end
  end
end
