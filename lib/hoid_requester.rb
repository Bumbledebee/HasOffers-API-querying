require 'net/http'
require 'pry'
require 'json'
require 'dotenv'
Dotenv.load

#hoid = '10210921117720271453150818'
class Requester

  attr_reader :hoid

  def initialize(hoid)
    @hoid = hoid
  end

  def get_subid
    uri = URI('http://sponsorpaynetwork.api.hasoffers.com/Apiv3/json')
    params = {"NetworkId" => ENV['network_id'],
        "NetworkToken" => ENV['network_token'],
        "Target" => "Report",
        "Method" => "getConversions",
        "fields[0]" => "Stat.affiliate_info1",
        "filters[Stat.ad_id][conditional]" => "EQUAL_TO",
        "filters[Stat.ad_id][values][0]" => hoid}
    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get_response(uri)
    if res.is_a?(Net::HTTPSuccess)
      res = JSON.parse(res.body)
      res = res["response"]["data"]["data"]
    else res = ""
    end
    res
  end
end


class Offer

  attr_reader :res

  def initialize(res)
    @res = res
  end

  def get_format
    if res == "" || res.nil? || res == []
      result = "No result"
    elsif res[0]["Stat"]["affiliate_info1"].size < 28
      result = "No result"
    else
      result = res[0]["Stat"]["affiliate_info1"].insert(8, '-').insert(13, '-').insert(18, '-').insert(23, '-')
    end
    result
  end

end
