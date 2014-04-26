require 'bundler'
Bundler.require
require 'bitcasa/version'

module Bitcasa
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

    def delete(path)
      raise ArgumentError unless path
      @client.do(:delete, 'files', nil, path: path)
    end

    def folder(path = nil)
      path ||= root_folder["path"]
      @client.do(:get, 'folders', "#{path}")
    end

    def find_by(opts = {})
      path = opts.delete(:path) || root_folder["path"]
      key, value = opts.first
      folder(path)['items'].select { |item|
        case value.class.to_s
        when 'Regexp'
          item[key.to_s] =~ value
        else
          item[key.to_s] == value
        end
      }
    end

    def create_folder(name, path = nil)
      path ||= root_folder["path"]
      @client.do(:post, 'folders', path, folder_name: name)
    end

    def root_folder
      @root_folder ||= begin
        folder('')['items'].
          select{|e| e['sync_type'] == "infinite drive"}.
          first
      end
    end
  end

  class Client
    API_BASE_URL = 'https://developer.api.bitcasa.com/v1'.freeze
    #API_BASE_URL = 'http://localhost:4567'

    def initialize(access_token: nil)
      @access_token = access_token || ENV['ACCESS_TOKEN'] || raise(ArgumentError)
    end

    def access_token
      @access_token
    end

    def do(method, path, resource = nil, opts = {})
      url = [API_BASE_URL, path, resource].compact.join('/')
      case method
      when :post, :delete
        url << "?access_token=#{access_token}"
      else
        opts = { params: {access_token: access_token}.merge(opts) }
      end
      opts.merge!(multipart: true)

      response = RestClient.send(method, url, opts)
      JSON.parse(response)["result"]
    end
  end
end
