
require 'net/http'
require 'json'
require 'dotenv'
require 'date'

Dotenv.load

class Leadads

    def get_approved_offers
      now = Date.today
      uri = URI("https://api.hasoffers.com/Apiv3/json?NetworkId=leadads&Target=Affiliate_Report&Method=getConversions&api_key=#{ENV['api_key']}&fields%5B%5D=Offer.name&fields%5B%5D=Stat.ad_id&fields%5B%5D=Stat.datetime&fields%5B%5D=Stat.offer_id&fields%5B%5D=Stat.conversion_status&fields%5B%5D=Stat.approved_payout&fields%5B%5D=Stat.currency&fields%5B%5D=Stat.affiliate_info1&data_start=#{(now - 3).to_s}&data_end=#{now.to_s}&hour_offset=9")
      res = Net::HTTP.get_response(uri)
      if res.is_a?(Net::HTTPSuccess)
        hash = JSON.parse(res.body)
        result = hash["response"]["data"]["data"]
      else result ="not available"
      end
      if result != []
        results = String.new
        result.each do |line|
          if line["Stat"]["conversion_status"].to_s == 'approved'
            results << (line["Stat"]["affiliate_info1"].to_s+'</br>')
          end
        end
      elsif result == "not available"
        results = result
      end
      results
    end
end
