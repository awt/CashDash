#!/usr/bin/env ruby1.9.1
require 'rubygems'
require 'sinatra'
require 'haml'
require 'sass'
require 'sqlite3'
require 'dm-core' 
require 'json'
require 'thin'
require 'logger'
require 'mixpanel'

require File.join(File.dirname(__FILE__), 'lib', 'config')

require File.join(File.dirname(__FILE__), 'database')
#http://datamapper.org/getting-started

helpers do

  def protected!
    unless authorized?
      response['WWW-Authenticate'] = %(Basic realm="Testing HTTP Auth")
      throw(:halt, [401, "Not authorized\n"])
    end
  end

  def authorized?
    return true if( "production" != ENV['RACK_ENV'] )
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == ['admin', 'admin']
  end

end

helpers do
  def partial(page, options={})
    haml page, options.merge!(:layout => false)
  end
  def logger
    LOGGER
  end

end

get '/' do
  protected!
  @config = CashDash::Config.instance.get_config
  haml :index
end

get '/api/chart' do
  content_type :json
  Chart.get(params[:name]).config
end

get '/api/chart_names' do
  content_type :json
  Chart.all(:order => :name).collect{|c| c.name }.to_json
end

post 'api/receive_commits' do

end
get '/stylesheets/style.css' do
  response['Content-Type'] = 'text/css; charset=utf-8'
  sass :style
end

