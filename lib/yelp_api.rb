require "json"
require "net/http"

class YelpAPI
  API_HOST = "https://api.yelp.com"
  SEARCH_PATH = "/v3/businesses/search"
  BUSINESS_PATH = "/v3/businesses/"  # trailing / because we append the business id to the path

  def initialize(api_key)
    @api_key = api_key
  end

  def search(params)
    params = params.to_hash
    url = "#{API_HOST}#{SEARCH_PATH}"

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

  def search_with_steps(steps)
    steps = steps.to_hash
    res = []
    (steps.size-1).times do |i|
      start_point = steps[i.to_s]
      end_point = steps[(i + 1).to_s]
      s = search(term: "food", latitude: start_point['latitude'], longitude: start_point['longitude'], radius: 1000)
      e = search(term: "food", latitude: end_point['latitude'], longitude: end_point['longitude'], radius: 1000)
      res += s["businesses"] + e['businesses']
    end
    res.uniq!{|v| v["id"]}
  end

end