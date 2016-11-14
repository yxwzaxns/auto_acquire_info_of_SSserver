require 'sinatra'
require 'json'
require 'net/http'

module Sinatra
  class Base
    set :server, %w[thin mongrel webrick]
    set :bind, '0.0.0.0'
    set :port, 9999
    set :views, File.dirname(__FILE__) + '/views'
    set :environment, :production
    set :logging, true
  end
end

# enable :sessions

get '/' do
  uri = URI('https://app.arukas.io/api/containers/0aa14a1e-d23a-44ce-964b-6a59bc5822d4')

  req = Net::HTTP::Get.new(uri)
  req.basic_auth ENV['SS_TOKEN'], ENV['SS_SECRET']
  # req.use_ssl = true

  res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme) {|http|
    http.request(req)
  }
  info = JSON.parse(res.body)['data']['attributes']['port_mappings'][0][0]
  content_type :json
  res = {:host => info['host'][6..20].gsub(/-/,'.'), :port => info['service_port'], :password => 23333 , :encryption => 'aes-256-cfb'}
  res.to_json
end
