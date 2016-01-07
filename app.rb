$: << 'lib'

require 'sinatra'
require 'hoid_requester'
require 'hoid_result'
require 'active_offers'
require 'leadads_offers'
require 'find_advertiser'
require 'query_impala'
require 'whitelisting'

set :server, 'webrick'
set :bind, '10.90.0.40'
set :port, 4444

get '/' do
  erb :tune
end

get '/tune' do
  erb :tune
end

get '/whitelisting' do
  erb :whitelisting
end

get '/internal' do
  erb :index
end

post '/result' do
  @hoid = params[:hoid]
  if  @hoid.lines.count > 1
    result = Result.new(@hoid).sql_result
    text = "Below you find the subids ready to copy past into your SQL query"
  else
    result = Result.new(@hoid).ams_result
    unless result == "No result"
      text = "<h4> <a href='https://ams.fyber.com/support/search_user?search_type=subid&subid=#{result}' >View the Subid in AMS</a> or view below:</h4>"
    end
  end
  erb :result, :locals => { :result => result, :text => text}
end

post '/source' do
  @hoid = params[:hoid]
  if  @hoid.lines.count > 1
    result = Result.new(@hoid).query_result
    text = "Below you find the source of the subids"
  else
    result = Result.new(@hoid).ams_result
    unless result == "No result"
      text = "<h4> <a href='https://ams.fyber.com/support/search_user?search_type=subid&subid=#{result}' >View the Subid in AMS</a> or view below:</h4>"
    end
  end
  erb :result, :locals => { :result => result, :text => text}
end

get '/active' do
  result = Active.new.get_active_offers
  text = "Below you find all Offers with status:active in HasOffers. Copy paste into excel and separate by '§'"
  erb :result, :locals => { :result => result, :text => text}
end

get '/advertisers' do
  result = Active.new.find_advertiser
  text = "Below you find all active Advertisers from HasOffers. Copy paste into excel and separate by ',' when all data needed."
  erb :result, :locals => { :result => result, :text => text}
end

get '/leadads' do
  result = Leadads.new.get_approved_offers
  text = "Below you find all approved conversion from LeadAds for the last 3 days"
  erb :result, :locals => { :result => result, :text => text}
end
