require 'sinatra'

api_token = ENV['HIPCHAT_TOKEN']
client = HipChat::Client.new(api_token)
room_id = ENV['HIPCHAT_ROOM_ID']
username = ENV['HIPCHAT_USERNAME']

get '/' do
  puts "Hello World!"
end

get '/post_build' do
  puts params
end

post '/post' do
  puts params
  payload = JSON.parse(params[:payload])
  puts payload
  message = "%s: %s" % [payload['alert']['name'], payload['event']['m']]
  puts message
  client[room_id].send(username, message, color: 'red', notify: 1)
end
