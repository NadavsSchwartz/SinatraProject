require 'httparty'
class Flight < ActiveRecord::Base
  has_many :carts
  has_many :users, through: :carts
  # get request to skyscanner to pull info based on user input.
  def self.get_flight(origin, destination, origin_date, destination_date = '')
    @flight = HTTParty.get "https://skyscanner-skyscanner-flight-search-v1.p.rapidapi.com/apiservices/browsequotes/v1.0/US/USD/en-US/#{origin}/#{destination}/#{origin_date}?inboundpartialdate=#{destination_date}",
                           headers: {
                             'X-RapidAPI-Host' => 'skyscanner-skyscanner-flight-search-v1.p.rapidapi.com',
                             'X-RapidAPI-Key' => '04ffdca11fmsh6d2319daea4c209p172278jsn9b371a9115f8'
                           }
                                                      end

  def self.set_flight
    # checking if originId matches the originId from the user's input, otherwise switching it.
    #(at times api response switches between origin and return iata_code)
    origin_id = @flight['Quotes'][0]['OutboundLeg']['OriginId']
    place_id = @flight['Places'][1]['PlaceId']
    origin_i = 1
    place_i = 0
    if origin_id != place_id
      origin_i = 0
      place_i = 1
    end
    @flight['Quotes'].map do |quote|
      Flight.find_or_create_by(
        origin_date: quote['OutboundLeg']['DepartureDate'].split('T')[0],
        cost: quote['MinPrice'],
        origin: @flight['Places'][origin_i]['Name'],
        destination: @flight['Places'][place_i]['Name'],
        origin_iata_code: @flight['Places'][origin_i]['IataCode'],
        return_iata_code: @flight['Places'][place_i]['IataCode']
      )
    end
  end
end
