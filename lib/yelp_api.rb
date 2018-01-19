require "json"
require "net/http"

class YelpAPI
  API_HOST = "https://api.yelp.com"
  SEARCH_PATH = "/v3/businesses/search"
  BUSINESS_PATH = "/v3/businesses/"  # trailing / because we append the business id to the path

  DEFAULT_BUSINESS_ID = "yelp-san-francisco"
  DEFAULT_TERM = "dinner"
  DEFAULT_LOCATION = "San Francisco, CA"

  def initialize(api_key)
    @api_key = api_key
  end

  def search(params)
    params = params.to_hash
    url = "#{API_HOST}#{SEARCH_PATH}"
    # params = {}
    # params[:term] = term
    # params[:lat] = lat
    # params[:lng] = lng
    # params[:location] = location    
  
    # response = Net::HTTP.auth("Bearer #{@api_key}").get(url, params: params)
    # response.parse  

    uri = URI.parse("#{API_HOST}#{SEARCH_PATH}")
    uri.query = URI.encode_www_form(params)
    http = Net::HTTP.new(uri.host, uri.port)

    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    req = Net::HTTP::Get.new(uri.request_uri)
    req["Authorization"] = "bearer #{@api_key}"

    res = http.request(req)
    JSON.load res.body
  end
end

# require './lib/yelp_api'
# y = YelpAPI.new('aw7pojGUZiprirdLWiL319no7riRD7v5joTf7W_TkBohTCaDx82Y12LDE_wSaZ3mwWYk9rBMY6Z-dHAeUUI1bviVmHEnJvsWMQTKRd7xk5nhpFCE6PYrBmYQxxZiWnYx')
# y.search('pizza', 'New York')