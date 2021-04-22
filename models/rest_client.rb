# frozen_string_literal: true

require 'json'
require 'rest-client'

require_relative 'config'

class AppRestClient
  API_URL = Config.new.api_url
  AUTH_USER = Config.new.auth_user
  AUTH_TOKEN = Config.new.auth_token

  attr_accessor :client

  def get(path)
    response = RestClient.get("#{API_URL}/#{path}", { 'X-AUTH-USER': AUTH_USER, 'X-AUTH-TOKEN': AUTH_TOKEN })
    JSON.parse(response.body)
  rescue => exception
    {}
  end

  def patch(path)
    response = RestClient.patch("#{API_URL}/#{path}", { copy: 'all' }, { 'X-AUTH-USER': AUTH_USER, 'X-AUTH-TOKEN': AUTH_TOKEN })
    JSON.parse(response.body)
  rescue => exception
    {}
  end
end