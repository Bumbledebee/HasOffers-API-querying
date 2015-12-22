require_relative './hoid_requester.rb'
require_relative './query_impala.rb'
require 'pry'

class Result
  attr_reader :hoids, :result

  def initialize(hoids)
    @hoids = hoids
    @result = result
  end

  def ams_result
    result = Requester.new(hoids).get_subid
    Offer.new(result).get_format
  end

  def sql_result
      result = String.new
      hoids.split(/\r?\n|\r/).each do |line|
        res = Requester.new(line).get_subid
        res = Offer.new(res).get_format
        result << "'"+res+"'"+"</br>"","
      end
      result
  end

   def query_result
      subid = String.new
      hoids.split(/\r?\n|\r/).each do |line|
        res = Requester.new(line).get_subid
        res = Offer.new(res).get_format
        subid << "'"+res+"'"+","
      end
      if subid == "'No subid',"
        result = "No subid"
      else
        l = subid.size
        l = l -2
        subids = subid[0..l]
        now = Date.today
        startdate = (now - 30).to_s
        enddate = now.to_s
        query = "select toc.landing_page_id as lpid, a.id as appid, a.name as appname,
        count(*) as number_of_conversions
        from cms.applications_parquet as a
        join ids.track_offer_clicks_history_parquet toc on a.id = toc.application_id
        where toc.subid in (#{subids})
        and toc.created_at >= '2015-08-01' group by 1,2,3"
        result = Query.new(query,startdate,enddate)
        result.run_query
      end
      result
  end

end
