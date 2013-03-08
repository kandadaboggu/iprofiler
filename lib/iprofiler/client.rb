require 'cgi'
require 'openssl'
require 'base64'
require 'net/http'


module Iprofiler

  class Client
    include Api::QueryMethods

    attr_reader :api_key, :api_secret, :api_host

    def initialize(key=Iprofiler.key, secret=Iprofiler.secret, host=Iprofiler.host)
      @api_key = key
      @api_secret = secret
      @api_host = host
    end

  protected

    def get(api_path, options)
      response = Net::HTTP.get_response(URI(url))
      Mash.from_json(response.body).tap do |reply|
        code = response.code.to_i
        reply[:code] = code
        if code != 200
          reply[:status] = "error"
        end
      end
    end

  private

    def request_uri api_path, options
      authp = auth_params(api_path)
      requestp = options.map{|k, v| "#{k}=#{v}"}.join("&")
      URI("#{host}#{api_path}?#{authp}&#{requestp}")
    end

    def auth_params(api_path, verb="get")
      epoch = Time.now.to_i
      signature = "#{verb.upcase}\n#{epoch}\n#{api_path}"
      "api_key=#{api_key}&epoch=#{epoch}&signature=#{sign_data(api_secret, signature)}"
    end  

    def sign_data(str)
      CGI.escape(
        Base64.encode64( 
          OpenSSL::HMAC.digest( 
            OpenSSL::Digest::Digest.new('sha1'), 
            api_secret, str
          )
        ).chomp.gsub(/\n/,'')
      )
    end

  end

end
