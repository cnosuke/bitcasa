require 'bundler'
Bundler.require

module Bitcasa
  VERSION = '0.0.1'

  class RESTClient
    def initialize(access_token: nil)
      @access_token = access_token || ENV['ACCESS_TOKEN'] || raise(ArgumentError)
    end

    def access_token
      @access_token
    end
  end
end
