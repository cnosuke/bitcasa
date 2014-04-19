require 'bundler'
Bundler.require

module Bitcasa
  VERSION = '0.0.1'

  class RESTClient
    API_BASE_URL = 'https://developer.api.bitcasa.com/v1'.freeze

    def initialize(access_token: nil)
      @access_token = access_token || ENV['ACCESS_TOKEN'] || raise(ArgumentError)
    end

    def access_token
      @access_token
    end

    def api(method, path, resource = nil, opts = {})
      url = [API_BASE_URL, path, resource].join('/') + "?access_token=#{access_token}"
      response = RestClient.send(method, url, opts)
      {
        response: response,
        body: JSON.parse(response)
      }
    end
  end
end
