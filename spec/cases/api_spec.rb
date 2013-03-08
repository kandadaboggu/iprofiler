require 'helper'

describe Iprofiler::Api do
  let(:api_key) { "4QNFkKjPTGK2NXAWsQQU" }
  let(:api_secret) { "sAzNf5Dsm5sYweErySxd" }
  let(:api_host) { "http://localhost:3000" }

  before do
    Iprofiler.configure do |config|
      config.api_key = api_key
      config.api_secret = api_secret
      config.api_host = api_host
    end
  end

  describe "configuration" do
    it "should be able to save the global connection parameters" do
      Iprofiler.api_key.should eq(api_key)
      Iprofiler.api_secret.should eq(api_secret)
      Iprofiler.api_host.should eq(api_host)
    end

    describe "client" do

      let(:new_api_key) { "new_key" }
      let(:new_api_secret) { "new_secret" }
      let(:new_api_host) { "new_host" }

      it "connection parameters should inherit from connection parameters" do
        client = Iprofiler::Client.new
        client.api_key.should eq(api_key)
        client.api_secret.should eq(api_secret)
        client.api_host.should eq(api_host)
      end

      it "api key should be overridable" do
        client = Iprofiler::Client.new(new_api_key)
        client.api_key.should eq(new_api_key)
        client.api_secret.should eq(api_secret)
        client.api_host.should eq(api_host)
      end

      it "api secret should be overridable" do
        client = Iprofiler::Client.new(new_api_key, new_api_secret)
        client.api_key.should eq(new_api_key)
        client.api_secret.should eq(new_api_secret)
        client.api_host.should eq(api_host)
      end

      it "api host should be overridable" do
        client = Iprofiler::Client.new(new_api_key, new_api_secret, new_api_host)
        client.api_key.should eq(new_api_key)
        client.api_secret.should eq(new_api_secret)
        client.api_host.should eq(new_api_host)
      end

    end
  end

  describe "authentication" do
    let(:client) { Iprofiler::Client.new }

    it "should be able to authenticate" do
      client.valid_credentials?.should eq(true)
    end

    it "should not be able to authenticate" do
      client.api_key = "DUMMY KEY"
      client.valid_credentials?.should eq(false)
    end
  end
#  
#  describe "company lookup" do
#
#    it "should be able to query using company name" do
#    end
#
#    it "should be able to query using domain name" do
#    end
#
#    it "should be able to query using ip address" do
#    end
#
#    it "should be able to query using employee email id" do
#    end
#
#    it "should not be able to query using empty parameters" do
#    end
#  end

end
