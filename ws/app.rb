require 'open-uri'
require 'json'
require 'fileutils'
require_relative 'lib/gpxinfo'
require_relative 'lib/cartodb'
require_relative 'helpers'

configure do
  enable :sessions
  set :json_encoder, :to_json
  set :erb, :layout => :layout
  set :base_url, "http://senderos.turismodearagon.com/visorprames/"
  set :tmp_dir, '/tmp/huracan_ws/tmp'
  set :cache_dir, '/tmp/huracan_ws/cache'
end

FileUtils.mkdir_p settings.tmp_dir
FileUtils.mkdir_p settings.cache_dir
FileUtils.mkdir_p settings.cache_dir + "/gpx"

before do
  headers["Access-Control-Allow-Methods"] = "GET, POST, PUT, DELETE, OPTIONS"
  headers["Access-Control-Allow-Origin"] = "*"
  headers["Access-Control-Allow-Headers"] = "accept, authorization, origin"
end

options "*" do
  response.headers["Allow"] = "HEAD,GET,PUT,DELETE,OPTIONS,POST"
  response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept"
end

# return the waypoints with photos in a given track id
get '/track/:id/photos' do
  content_type :json

  id = params[:id]

  wps = JSON.parse(open("#{settings.base_url}/get_waypoints.php?id=#{id}").read)

  # discard waypoints without photos
  wps = wps.find_all { |wp| wp['photo'] != nil }

  # change photo filename for URL
  wps.each do |wp|
    wp['photo'] = "http://senderos.turismodearagon.com/fotos/#{wp["photo"]}"
  end.to_json
end

get '/track/:id/altitude_profile' do
  content_type :json

  id = params[:id]

  gpxinfo = GPXInfo.new(get_gpx(id))
  gpxinfo.altitude_profile.to_json
end

get '/track/:id/altitude_profile.csv' do
  content_type 'text/plain'

  id = params[:id]

  gpxinfo = GPXInfo.new(get_gpx(id))
  csv = []
  gpxinfo.altitude_profile.each { |p| csv << "#{p[0]}, #{p[1]}" }
  csv.join("\n")
end

get '/track/:id/altitude_profile.png' do
  content_type 'image/png'

  id = params[:id]
  size = params[:size] || '360x180'

  gpxinfo = GPXInfo.new(get_gpx(id))
  csv = []
  gpxinfo.altitude_profile.each { |p| csv << "#{p[0]}, #{p[1]}" }
  File.read(altitude_profile_png(csv.join("\n"), id, size))
end

get '/track/:id/info' do
  content_type :json

  id = params[:id]

  GPXInfo.new(get_gpx(id)).distances.to_json
end

get '/tracks' do
  tracks = CartoDB.get_tracks({
                                'term' => params[:term], 
                                'lat' => params[:lat],
                                'lon' => params[:lon],
                                'limit' => params[:limit]
                              }
                             ).collect do |r|
    r['name']
  end
end

get '/tracks/:id' do
  @js_asset = 'show'
  @track_id = params[:id]

  @distances = GPXInfo.new(get_gpx(@track_id)).distances
  erb :show
end

get '/' do
  @js_asset = 'index'
  erb :index
end
