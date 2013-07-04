require 'nokogiri'
require 'restclient'
require 'addressable/uri'
require 'json'

puts "Type in address"

start_address = "160 folsom st, san francisco ca" #gets.chomp

geo_query = Addressable::URI.new(
   :scheme => "http",
   :host => "maps.googleapis.com",
   :path => "maps/api/geocode/json",
   :query_values => {:address => start_address,
                     :sensor => false}
 ).to_s

geo_response = RestClient.get(geo_query)
info = JSON.parse(geo_response)
start_lat_lng = info["results"][0]["geometry"]["location"]

places_query = Addressable::URI.new(
   :scheme => "https",
   :host => "maps.googleapis.com",
   :path => "maps/api/place/textsearch/json",
   :query_values => {:query => "ice cream by San Francisco",
                     :location => "#{start_lat_lng["lat"]},#{start_lat_lng["lng"]}",
                     :radius => 500,
                     :sensor => false,
                     :key => "key"}
 ).to_s


places_response = RestClient.get(places_query)
places_info = JSON.parse(places_response)


place_location = {}
places_info['results'].each do |result|
  puts result['name']
  place_location[result['name']] = result['geometry']['location']
end

puts "Enter the name of the shop you want to visit:"

shop_name = "Sophie's Crepes" #gets.chomp

end_lat_lng = place_location[shop_name]

directions_query = Addressable::URI.new(
   :scheme => "http",
   :host => "maps.googleapis.com",
   :path => "maps/api/directions/json",
   :query_values => {:origin => "#{start_lat_lng["lat"]},#{start_lat_lng["lng"]}",
                     :destination => "#{end_lat_lng["lat"]},#{end_lat_lng["lng"]}",
                     :sensor => false,
                     :mode => "walking"}
 ).to_s
directions_response = RestClient.get(directions_query)
directions_info = JSON.parse(directions_response)

directions_info['routes'][0]['legs'][0]['steps'].each do |step|
  puts Nokogiri::HTML(step['html_instructions']).text
end

