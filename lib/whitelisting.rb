require 'net/http'
require 'pry'
require 'json'
require 'dotenv'
Dotenv.load

class Offer_List

  attr_reader :advertiser_id, :params, :uri

  def initialize(advertiser_id)
    @advertiser_id = advertiser_id
    @uri = URI('http://sponsorpaynetwork.api.hasoffers.com/Apiv3/json')
    @params = {"NetworkId" => ENV['network_id'],
        "NetworkToken" => ENV['network_token']}
  end

  def get_offers
    params.merge({"Target" => "Offer",
        "Method" => "findAllIdsByAdvertiserId",
        "advertiser_id" => advertiser_id})
    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get_response(uri)
    if res.is_a?(Net::HTTPSuccess)
      res = JSON.parse(res.body)
      binding.pry
      res = res["response"]["data"]["data"]
    else res = ""
    end
    res
    binding.pry
  end

  def get_info

  end

end

#a =Offer_List.new(4016)
#a.get_offers
