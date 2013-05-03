require 'sinatra'

hipchat_api_token = ENV['HIPCHAT_TOKEN']
hipchat_room_id = ENV['HIPCHAT_ROOM_ID']
hipchat_username = ENV['HIPCHAT_USERNAME']
hipchat_client = HipChat::Client.new(hipchat_api_token)

client = Octokit::Client.new(oauth_token: ENV['GITHUB_TOKEN'])
repo_owner = ENV['GITHUB_REPO_OWNER']
repo_name = ENV['GITHUB_REPO_NAME']
repo = Octokit::Repository.new(owner: repo_owner, name: repo_name)

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
  if pull_request['state'] == 'open'
    sha = pull_request['head']['sha']
    state = 'pending'
    client.create_status(repo, sha, state)
  end
end
