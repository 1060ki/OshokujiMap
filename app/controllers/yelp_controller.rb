# -*- coding: utf-8 -*-

require './lib/yelp_api'
require 'kconv'

class YelpController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    client = YelpAPI.new(Rails.application.secrets.yelp_api_key)
    render json: @result = client.search(yelp_params)
  end

  def steps
    client = YelpAPI.new(Rails.application.secrets.yelp_api_key)
    render json: @result = client.search_with_steps(yelp_params[:steps])

  end

  private
  def yelp_params
    params.permit(steps: [[:latitude, :longitude]])
  end
end
