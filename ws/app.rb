require 'sinatra'
require 'open-uri'
require 'json'
require 'sinatra/reloader'
#require_relative 'gpx'

configure do
  enable :sessions
  set :json_encoder, :to_json
  set :erb, :layout => :layout
  set :base_url, "http://senderos.turismodearagon.com/visorprames/"
end

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
  id = params[:id]
  wps = JSON.parse(open("#{settings.base_url}/get_waypoints.php?id=#{id}").read)
  wps.find_all{ |wp| wp['photo'] != nil }.to_json
end

get '/' do
  'Aragon Open Data!'
end