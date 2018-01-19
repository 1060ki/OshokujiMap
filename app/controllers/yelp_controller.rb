# -*- coding: utf-8 -*-

require './lib/yelp_api'
require 'kconv'

class YelpController < ApplicationController
  protect_from_forgery with: :exception

  def index
    client = YelpAPI.new(Rails.application.secrets.yelp_api_key)
    p yelp_params 
    render json: @result = client.search(yelp_params)
  end

  private
  def yelp_params
    params.permit(:term, :latitude, :longitude, :location)
  end
end
