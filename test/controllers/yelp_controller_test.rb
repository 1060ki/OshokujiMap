require 'test_helper'

class YelpControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get yelp_index_url
    assert_response :success
  end

end
