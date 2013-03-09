require 'cgi'
require 'openssl'
require 'base64'
require 'net/http'


module Iprofiler

  class Client
    include Api::QueryMethods

    CONNECTION_PARAMETERS = [:api_key, :api_secret, :api_host]
    attr_reader :api_key, :api_secret, :api_host, :missing_credentials

    CONNECTION_PARAMETERS.each do |attr|
      define_method "#{attr}=" do | val |
        instance_variable_set("@#{attr}", val).tap do |v|
          validate_credential_presence
        end
      end
    end

    def initialize(api_key=Iprofiler.api_key, api_secret=Iprofiler.api_secret, api_host=Iprofiler.api_host)
      @api_key = api_key
      @api_secret = api_secret
      @api_host = api_host
      validate_credential_presence
    end

    def valid_credentials?
      credentials_present? && (company_lookup({}).code == 200)
    end

  protected

    def credentials_present?
      missing_credentials.size == 0
    end

    def credentials_missing?
      !credentials_present?
    end

    def validate_credential_presence
      @missing_credentials = CONNECTION_PARAMETERS.select{ |attr| send(attr).nil?}
    end

    def get(api_path, options)
      return credentials_missing_error if credentials_missing?
      http_reply = Net::HTTP.get_response(request_uri(api_path, options))
      construct_reply(http_reply, options)
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

    def credentials_missing_error
      return Mash.new.tap do |reply|
        reply.status = :error
        reply.code = 400
        reply.error = "Invalid or missing API connection parameter(s)[#{missing_credentials.join(",")}]"
      end
    end

    def construct_reply(response, options)
      Mash.from_json(response.body).tap do |reply|
        code = response.code.to_i
        reply.code = code
        if code == 200
          reply.status = reply.status.to_sym
          if reply.status == :found
            reply.company.type = reply.company.type.to_sym
          end
        else
          reply.status = :error
        end
        # email requests are served by Leadiq server
        email = options['email'] || options[:email]
        reply.email = email unless email.nil?
      end
    end
  end

end
