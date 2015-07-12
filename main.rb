require 'rubygems'
require 'sinatra'
require 'json'
require 'tilt/haml'
require 'tilt/sass'
require './model/log.rb'

helpers do
  include Rack::Utils; alias_method :h, :escape_html
end

get '/style.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :style
end

get '/' do
  @log = Log.order(:posted_date).reverse
  haml :index
end

get '/gohome' do
  Log.create({
    :from => request[:from],
    :posted_date => Time.now,
  })
  "from #{request[:from]}"
end

post '/gohome', provides: :json do
  request.body.rewind
  body = request.body.read
  if body == ''
    status 400
  end
  request.body.rewind
  params = JSON.parse request.body.read
  Log.create({
    :from => params['from'],
    :body => body,
    :posted_date => Time.now,
  })
  content_type :json
  resdata = {from: params['from']}
  resdata.to_json
end
