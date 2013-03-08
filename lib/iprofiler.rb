module Iprofiler

  class << self
    attr_accessor :key, :secret, :host

    # config/initializers/iprofiler.rb (for instance)
    #
    # Iprofiler.configure do |config|
    #   config.key = 'consumer_key'
    #   config.secret = 'consumer_secret'
    #   config.host = 'http://visitoriq2.iprofile.net'
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
