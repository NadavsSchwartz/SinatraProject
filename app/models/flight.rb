require 'httparty'
require 'sinatra'
require 'sinatra/flash'
class Flight < ActiveRecord::Base
  belongs_to :cart
  belongs_to :user
  # get request to skyscanner to pull info based on user input.
  # to do: remove iteration from this file and refactor it, too ugly.
  def self.get_flight(origin, destination, origin_date, destination_date = '')
    @flight = HTTParty.get "https://skyscanner-skyscanner-flight-search-v1.p.rapidapi.com/apiservices/browsequotes/v1.0/US/USD/en-US/#{origin}/#{destination}/#{origin_date}?inboundpartialdate=#{destination_date}",
                           headers: {
                             'X-RapidAPI-Host' => 'skyscanner-skyscanner-flight-search-v1.p.rapidapi.com',
                             'X-RapidAPI-Key' => '04ffdca11fmsh6d2319daea4c209p172278jsn9b371a9115f8'
                           }
    # checking if originId matches the originId from the user's input, otherwise switching it. (at times api response switches between origin and return iata_code)
    # to do: find a better logic, and find a way to update existing flight if outdated
    if !@flight['Quotes'].nil? && @flight['Quotes'][0]['OutboundLeg']['OriginId'] == @flight['Places'][0]['PlaceId']
      @flight['Quotes'].each do |quote|
        Flight.find_or_create_by(
          origin_date: quote['OutboundLeg']['DepartureDate'].split('T')[0],
          cost: quote['MinPrice'],
          origin: @flight['Places'][0]['Name'],
          destination: @flight['Places'][1]['Name'],
          origin_iata_code: @flight['Places'][0]['IataCode'],
          return_iata_code: @flight['Places'][1]['IataCode']
        )
      end
    elsif @flight['Quotes'][0]['OutboundLeg']['OriginId'] == @flight['Places'][1]['PlaceId']
      @flight['Quotes'].each do |quote|
        Flight.find_or_create_by(
          origin_date: quote['OutboundLeg']['DepartureDate'].split('T')[0],
          cost: quote['MinPrice'],
          origin: @flight['Places'][1]['Name'],
          destination: @flight['Places'][0]['Name'],
          origin_iata_code: @flight['Places'][1]['IataCode'],
          return_iata_code: @flight['Places'][0]['IataCode']
        )
      end
    else
      puts "We couldn't find any flights."
      # redirect to '/flight'
    end
end
end
