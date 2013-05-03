require 'sinatra'

hipchat_api_token = ENV['HIPCHAT_TOKEN']
hipchat_room_id = ENV['HIPCHAT_ROOM_ID']
hipchat_username = ENV['HIPCHAT_USERNAME']
hipchat_client = HipChat::Client.new(hipchat_api_token)

get '/' do
  puts "Hello World!"
end

get '/test_hipchat' do
  hipchat_client[hipchat_room_id].send(hipchat_username, 'Hello!')
end

get '/post_build' do
  puts params
end

post '/post' do
  puts params
end
