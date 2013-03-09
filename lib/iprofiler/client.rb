require 'cgi'
require 'openssl'
require 'base64'
require 'net/http'


module Iprofiler

  class Client
    include Api::QueryMethods

    attr_accessor :api_key, :api_secret, :api_host

    def initialize(api_key=Iprofiler.api_key, api_secret=Iprofiler.api_secret, api_host=Iprofiler.api_host)
      @api_key = api_key
      @api_secret = api_secret
      @api_host = api_host
    end

    def valid_credentials?
      company_lookup({}).code == 200
    end

  protected

    def get(api_path, options)
      response = Net::HTTP.get_response(request_uri(api_path, options))
      Mash.from_json(response.body).tap do |reply|
        code = response.code.to_i
        reply.code = code
        if code == 200
          reply.status = reply.status.to_sym
        else
          reply.status = :error
        end
        # email requests are served by Leadiq server
        email = options['email'] || options[:email]
        reply.email = email unless email.nil?
      end
    end

  private

    def request_uri api_path, options
      authp = auth_params(api_path)
      requestp = options.map{|k, v| "#{k}=#{CGI.escape(v)}"}.join("&")
      URI("#{api_host}#{api_path}?#{authp}&#{requestp}")
    end

    def auth_params(api_path, verb="get")
      epoch = Time.now.to_i
      signature = "#{verb.upcase}\n#{epoch}\n#{api_path}"
      "api_key=#{CGI.escape(api_key)}&epoch=#{epoch}&signature=#{sign_data(signature)}"
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
