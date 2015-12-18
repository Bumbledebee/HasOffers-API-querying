require 'net/http'
require 'json'
require 'pry'
require 'dotenv'
Dotenv.load

class Active

    def find_advertiser
      uri = URI("https://api.hasoffers.com/Apiv3/json?NetworkId=#{ENV['network_id']}&Target=Advertiser&Method=findAll&NetworkToken=#{ENV['network_token']}&filters%5Bstatus%5D=active")
      res = Net::HTTP.get_response(uri)
      if res.is_a?(Net::HTTPSuccess)
        hash = JSON.parse(res.body)
        result = hash["response"]["data"]
      else result ="not available"
      end
      if result != []
        results = "Advertiser ID, Advertiser name, Token generated, Token applied, Account Manager ID"
        result.each do |line|
            results << ("</br>"+line[1]["Advertiser"]["id"].to_s+","+line[1]["Advertiser"]["company"].to_s+","+line[1]["Advertiser"]["tmp_token"].to_s+","+line[1]["Advertiser"]["conversion_security_token"].to_s+","+line[1]["Advertiser"]["account_manager_id"].to_s)
        end
      else
        results = result
      end
      results
    end
end
