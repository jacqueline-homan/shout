require 'sinatra'
require 'sinatra/reloader' if development?
require 'slim'
require 'omniauth-twitter'
require 'pry'

configure :development do
  use BetterErrors::Middleware 
  BetterErrors.application_root = File.expand_path('..', __FILE__)
  BetterErrors.editor = :sublime if defined? BetterErrors
enable :sessions

use OmniAuth::Builder do
	provider :twitter, ENV['TFWS_KEY'], ENV['TFWS_SECRET']
end 
get '/style.css' { scss :styles }
get '/' do
	erb :home
end
get '/about' do
	erb :about 
end
get '/auth/twitter/callback' do
	binding.pry
  # probably you will need to create a user in the database too...
  session[:uid] = env['omniauth.auth']['uid']
  # this is the main endpoint to your application
  redirect to('/')
end
get '/auth/failure' do
  # omniauth redirects to /auth/failure when it encounters a problem
  # so you can implement this as you please
end