require 'sinatra'

hipchat_api_token = ENV['HIPCHAT_TOKEN']
hipchat_room_id = ENV['HIPCHAT_ROOM_ID']
hipchat_username = ENV['HIPCHAT_USERNAME']
hipchat_client = HipChat::Client.new(hipchat_api_token)

client = Octokit::Client.new(oauth_token: ENV['GITHUB_TOKEN'])
repo_owner = ENV['GITHUB_REPO_OWNER']
repo_name = ENV['GITHUB_REPO_NAME']
repo = Octokit::Repository.new(owner: repo_owner, name: repo_name)

Redis.current = Redis.new( url: ENV['REDISCLOUD_URL'] )

get '/' do
  puts "Hello World!"
end

get '/test_hipchat' do
  hipchat_client[hipchat_room_id].send(hipchat_username, 'Hello!')
end

post '/build_result' do
  puts params
  sha = params['sha']
  state = params['state']
  target_url = params['target_url']

  build_result = Redis::HashKey.new(sha)
  build_result['state'] = state
  build_result['target_url'] = target_url

  client.create_status(repo, sha, state, target_url: target_url)
end

post '/github_callback' do
  payload = JSON.parse(params[:payload])
  puts "payload.keys #{payload.keys}"
  pull_request = payload['pull_request']
  if pull_request['state'] == 'open'
    puts "pull_request.keys #{pull_request.keys}"
    head = pull_request['head']
    puts "head #{head}"
    sha = head['sha']

    build_result = Redis::HashKey.new(sha)
    if sha_status
      state = build_result['state']
      target_url = build_result['target_ur;']
    else
      state = 'pending'
      target_url = nil
    end

    client.create_status(repo, sha, state, target_url: target_url)
  end
end
