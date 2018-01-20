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
    new_step = []
    steps.each do |_, v|
      # p distance(new_step.last['latitude'], new_step.last['longitude'], v['latitude'], v['longitude']) if new_step.last
      if new_step.size == 0 || distance(new_step.last['latitude'], new_step.last['longitude'], v['latitude'], v['longitude']) > 4
        new_step << v 
      end
    end

    p new_step

    res = Parallel.map(new_step) do |i|
      step = i
      shops = search(term: "food", latitude: step['latitude'], longitude: step['longitude'], radius: 4000, limit: 20,locale: 'ja_JP')
      shops["businesses"]
    end
    
    res.flatten!
    res.uniq!{|v| v["id"]}
    res
  end

  private
  def distance(lat1, lng1, lat2, lng2)
    x1 = lat1.to_f * Math::PI / 180
    y1 = lng1.to_f * Math::PI / 180
    x2 = lat2.to_f * Math::PI / 180
    y2 = lng2.to_f * Math::PI / 180
    
    radius = 6378.137
    
    diff_y = (y1 - y2).abs
    
    calc1 = Math.cos(x2) * Math.sin(diff_y)
    calc2 = Math.cos(x1) * Math.sin(x2) - Math.sin(x1) * Math.cos(x2) * Math.cos(diff_y)
    
    numerator = Math.sqrt(calc1 ** 2 + calc2 ** 2)
    
    denominator = Math.sin(x1) * Math.sin(x2) + Math.cos(x1) * Math.cos(x2) * Math.cos(diff_y)
    
    degree = Math.atan2(numerator, denominator)
    degree * radius
  end  

end