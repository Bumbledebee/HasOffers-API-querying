require 'impala'
require 'date'

class Query

  attr_reader :query, :startdate, :enddate

  def initialize(query, startdate, enddate)
    @query = query
    @startdate = startdate
    @enddate = enddate
  end

  def run_query
    Impala.connect('10.0.40.2', 21000) do |conn|
        conn.query(@query)
    end
  end

end
