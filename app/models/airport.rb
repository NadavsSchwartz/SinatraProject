class Airport < ActiveRecord::Base

  def self.get_airport(city_name)
    airport = HTTParty.get "https://skyscanner-skyscanner-flight-search-v1.p.rapidapi.com/apiservices/autosuggest/v1.0/US/usd/en-GB/?query=#{city_name}",
                           headers: {
                             'X-RapidAPI-Host' => 'skyscanner-skyscanner-flight-search-v1.p.rapidapi.com',
                             'X-RapidAPI-Key' => '04ffdca11fmsh6d2319daea4c209p172278jsn9b371a9115f8'
                           }
    airport['Places'].select do |airports|
      Airport.find_or_create_by(
        iata_code: airports['PlaceId'],
        state: airports['RegionId'],
        iso_code: airports['CountryId'],
        name: airports['PlaceName']
      )
    end
  end
 end
