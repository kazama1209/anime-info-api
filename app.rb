require "bundler/setup"
require "sinatra"
require "sinatra/cors"

require "./anime_details.rb"
require "./schedule.rb"

set :allow_origin, "*"
set :allow_methods, "GET,HEAD,POST"
set :allow_headers, "content-type,if-modified-since"
set :expose_headers, "location,link"

get "/api/anime_details" do
  tid = params[:tid]

  get_anime_details(tid)
end

get "/api/schedule" do
  span = params[:span]

  get_schedule(span)
end

