require 'oauth'

module Iprofiler

  class << self
    attr_accessor :key, :secret, :host

    # config/initializers/iprofiler.rb (for instance)
    #
    # Iprofiler.configure do |config|
    #   config.key = 'consumer_key'
    #   config.secret = 'consumer_secret'
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
  autoload :Errors,  "iprofiler/errors"
  autoload :Helpers, "iprofiler/helpers"
  autoload :Version, "iprofiler/version"
end
