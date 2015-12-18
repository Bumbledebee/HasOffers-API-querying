require 'net/http'
require 'json'
require 'dotenv'
Dotenv.load

class Active

    def get_active_offers
      uri = URI("https://api.hasoffers.com/Apiv3/json?NetworkId=#{ENV['network_id']}&Target=Offer&Method=findAll&NetworkToken=#{ENV['network_token']}&filters%5Bstatus%5D=active")
      res = Net::HTTP.get_response(uri)
      if res.is_a?(Net::HTTPSuccess)
        hash = JSON.parse(res.body)
        result = hash["response"]["data"]
      else result ="not available"
      end
      if result != []
        results = "Offer ID§ Offer name§ Expiration Date§ Status§ Whitelist Enabled§ Encryption Enabled§ Tracking Protocol §Advertiser id"
        result.each do |line|
            results << ("</br>"+line[1]["Offer"]["id"].to_s+"§"+line[1]["Offer"]["name"].to_s+"§"+line[1]["Offer"]["expiration_date"].to_s+"§"+line[1]["Offer"]["status"].to_s+"§"+line[1]["Offer"]["enable_offer_whitelist"].to_s+"§"+line[1]["Offer"]["enforce_encrypt_tracking_pixels"].to_s+"§"+line[1]["Offer"]["protocol"].to_s+"§"+line[1]["Offer"]["advertiser_id"].to_s)
        end
      else
        results = result
      end
      results
    end
end
