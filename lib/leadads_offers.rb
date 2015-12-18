
require 'net/http'
require 'json'
require 'dotenv'
require 'date'

Dotenv.load

class Leadads

    def get_approved_offers
      now = Date.today
      uri = URI("https://api.hasoffers.com/Apiv3/json?NetworkId=leadads&Target=Affiliate_Report&Method=getConversions&api_key=#{ENV['api_key']}&fields%5B%5D=Offer.name&fields%5B%5D=Stat.ad_id&fields%5B%5D=Stat.datetime&fields%5B%5D=Stat.offer_id&fields%5B%5D=Stat.conversion_status&fields%5B%5D=Stat.approved_payout&fields%5B%5D=Stat.currency&fields%5B%5D=Stat.affiliate_info1&data_start=#{(now - 14).to_s}&data_end=#{now.to_s}&hour_offset=9")
      res = Net::HTTP.get_response(uri)
      if res.is_a?(Net::HTTPSuccess)
        hash = JSON.parse(res.body)
        result = hash["response"]["data"]["data"]
      else result ="not available"
      end
      if result != []
        results = "Offer name, Offer Id, Date, Conversions Status, Payout, Currency, Subid"
        result.each do |line|
            results << ("</br>"+line["Offer"]["name"].to_s+","+line["Stat"]["offer_id"].to_s+","+line["Stat"]["datetime"].to_s+","+line["Stat"]["conversion_status"].to_s+","+line["Stat"]["approved_payout"].to_s+","+line["Stat"]["currency"].to_s+","+line["Stat"]["affiliate_info1"].to_s)
        end
      elsif result == "not available"
        results = result
      end
      results
    end
end
