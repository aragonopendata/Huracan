require 'open-uri'
require 'json'

class Nominatim
  BASE_URL = "http://nominatim.openstreetmap.org/"
  def self.hotels(place, limit = 5)
    ret = open("#{Nominatim::BASE_URL}/search?q=Jaca\[hotel\]&format=json&polygon=0&addressdetails=1&limit=#{limit}").read rescue '{}'
    JSON.parse(ret)
  end

  def self.reverse(lat, lon)
    rev = nil
    ret = open("#{BASE_URL}/reverse?lat=#{lat}&lon=#{lon}&format=json").read rescue nil

    rev = JSON.parse(ret) if ret

    rev
  end
end

if __FILE__ == $0
  Nominatim.hotels('jaca').each do |a|
    puts "#{a['type'].capitalize}: #{a['display_name']}"
  end

  puts Nominatim.reverse('44.88', '2.44')
end