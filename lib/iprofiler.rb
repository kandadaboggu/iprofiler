module Iprofiler

  class << self
    attr_accessor :api_key, :api_secret, :api_host

    # config/initializers/iprofiler.rb (for instance)
    #
    # Iprofiler.configure do |config|
    #   config.api_key = 'consumer_key'
    #   config.api_secret = 'consumer_secret'
    #   config.api_host = 'http://visitoriq2.iprofile.net'
    # end
    #
    # elsewhere
    #
    # client = Iprofiler::Client.new
    def configure
      yield self
      true
    end
  end

  autoload :Api,     "iprofiler/api"
  autoload :Client,  "iprofiler/client"
  autoload :Mash,    "iprofiler/mash"
  autoload :Version, "iprofiler/version"
end
