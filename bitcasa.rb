require 'bundler'
Bundler.require

module Bitcasa
  VERSION = '0.0.1'

  class API
    def initialize
      @client = Client.new
    end

    def user
      @client.do(:get, 'user', 'profile')
    end

    def upload(upload_file, path = nil)
      path ||= root_folder["path"]
      @client.do(:post, 'files', "#{path}/", file: File.new(upload_file, "rb"))
    end

    def folder(path = nil)
      path ||= root_folder["path"]
      @client.do(:get, 'folders', "#{path}/")
    end

    def root_folder
      @root_folder ||= begin
        folder('/')['items'].
          select{|e| e['sync_type'] == "infinite drive"}.
          first
      end
    end
  end

  class Client
    API_BASE_URL = 'https://developer.api.bitcasa.com/v1'.freeze

    def initialize(access_token: nil)
      @access_token = access_token || ENV['ACCESS_TOKEN'] || raise(ArgumentError)
    end

    def access_token
      @access_token
    end

    def do(method, path, resource = nil, opts = {})
      url = [API_BASE_URL, path, resource].join('/') + "?access_token=#{access_token}"
      response = RestClient.send(method, url, opts)
      JSON.parse(response)["result"]
    end
  end
end
