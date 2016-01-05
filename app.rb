$: << 'lib'

require 'sinatra'
require 'hoid_requester'
require 'hoid_result'
require 'active_offers'
require 'leadads_offers'
require 'find_advertiser'
require 'query_impala'

set :server, 'webrick'
set :bind, '10.90.0.40'

get '/' do
  erb :index
end

post '/result' do
  @hoid = params[:hoid]
  if @hoid.nil?
    result ="no subid"
    text = "You did not enter anything."
  elsif  @hoid.lines.count > 1
    result = Result.new(@hoid).sql_result
    text = "Below you find the subids ready to copy past into your SQL query"
  else
    result = Result.new(@hoid).ams_result
    text = "<h4> <a href='https://ams.fyber.com/support/search_user?search_type=subid&subid=#{result}' >View the Subid in AMS</a> or view below:</h4>"
  end
  erb :result, :locals => { :result => result, :text => text}
end

post '/source' do
  @hoid = params[:hoid]
  if @hoid.nil?
    result ="no subid"
    text = "You did not enter anything."
  elsif  @hoid.lines.count > 1
    result = Result.new(@hoid).query_result
    text = "Below you find the source of the subids"
  else
    result = Result.new(@hoid).ams_result
    text = "<h4> <a href='https://ams.fyber.com/support/search_user?search_type=subid&subid=#{result}' >View the Subid in AMS</a> or view below:</h4>"
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
  text = "Below you find all active Advertisers from HasOffers. Copy paste into excel and separate by ','. The ID here matches the Advertiser ID in the Offer result"
  erb :result, :locals => { :result => result, :text => text}
end

get '/leadads' do
  result = Leadads.new.get_approved_offers
  text = "Below you find all approved conversion from LeadAds for the last 3 days"
  erb :result, :locals => { :result => result, :text => text}
end
