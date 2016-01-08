require 'minitest/autorun'
require 'rack/test'
require_relative '../app'
require 'purdytest'

class MainAppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_displays_main_page
    get '/'
    assert last_response.ok?
    assert last_response.body.include?('Tune')
  end

  def test_enter_sdf_works
    post '/result?hoid=sdf'
    assert last_response.ok?
    assert last_response.body.include?('Here is your result')
  end

  def test_enter_nothing_works
    post '/result?hoid='
    assert last_response.ok?
    assert last_response.body.include?('Here is your result')
  end

  def test_enter_one_HOID_works
    post '/result?hoid=10210921117720271453150818'
    assert last_response.ok?
    assert last_response.body.include?('Here is your result')
  end

  def test_enter_multiple_lines_with_nonsense_works
    post "/result?hoid=10210921117720271453150818%0D%0Asdfsdfsdf%0D%0A1027821112840714sdf%0D%0A%0D%0A"
    assert last_response.ok?
    assert last_response.body.include?('Here is your result')
  end

  def test_enter_multiple_HOIDs_works
    post "/result?hoid=10210921117720271453150818%0D%0A1028931261571451150815%0D%0A102782111284071451150814%0D%0A10210921117720271453150818"
    assert last_response.ok?
    assert last_response.body.include?('Here is your result')
  end

  def test_impala_query_from_hoids
    post "/source?hoid=102223104132378852151218\r\n10218921810614278852151218\r\n\102791652116178852151218"
    assert last_response.ok?
    assert last_response.body.include?('Here is your result')
  end

    def test_impala_nonsense
    post "/source?hoid=102223104132378852151218\r\n1asdfasdfsd\r\n\102791652116178852151218"
    assert last_response.ok?
    assert last_response.body.include?('Here is your result')
  end

  def test_displays_active_offers_call
    get '/active'
    assert last_response.ok?
    assert last_response.body.include?('Here is your result')
  end

  def test_displays_leadads_offers
    get '/leadads'
    assert last_response.ok?
    assert last_response.body.include?('Here is your result')
  end

  def test_displays_advertisers
    get '/advertisers'
    assert last_response.ok?
    assert last_response.body.include?('Here is your result')
  end

end
