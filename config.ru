$stdout.sync = true

require 'rubygems'
require 'bundler'

Bundler.require

require 'web.rb'

run Sinatra::Application
