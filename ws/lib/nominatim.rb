require 'open-uri'
require 'json'

class Nominatim
  BASE_URL = "http://nominatim.openstreetmap.org/search"
  def self.hotels(place, limit = 5)
    ret = open("#{Nominatim::BASE_URL}?q=Jaca\[hotel\]&format=json&polygon=0&addressdetails=1&limit=#{limit}").read rescue '{}'
    JSON.parse(ret)
  end
end

if __FILE__ == $0
  Nominatim.hotels('jaca').each do |a|
    puts "#{a['type'].capitalize}: #{a['display_name']}"
  end
end