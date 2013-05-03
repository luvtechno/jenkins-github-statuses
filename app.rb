require 'sinatra'

hipchat_api_token = ENV['HIPCHAT_TOKEN']
hipchat_room_id = ENV['HIPCHAT_ROOM_ID']
hipchat_username = ENV['HIPCHAT_USERNAME']
hipchat_client = HipChat::Client.new(hipchat_api_token)

# client = Octokit::Client.new(oauth_token: ENV['GITHUB_TOKEN'])

get '/' do
  puts "Hello World!"
end

get '/test_hipchat' do
  hipchat_client[hipchat_room_id].send(hipchat_username, 'Hello!')
end

get '/post_build' do
  puts params
end

post '/github_callback' do
  payload = JSON.parse(params[:payload])
  puts "payload.keys #{payload.keys}"
  pull_request = payload['pull_request']
  puts "pull_request.keys #{pull_request.keys}"
end
