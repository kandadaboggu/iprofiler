require 'helper'

describe Iprofiler::Api do
  let(:api_key) { "4QNFkKjPTGK2NXAWsQQU" }
  let(:api_secret) { "sAzNf5Dsm5sYweErySxd" }
  let(:api_host) { "http://localhost:3000" }
  let(:client) { Iprofiler::Client.new }

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

    it "should be able to authenticate" do
      client.valid_credentials?.should eq(true)
    end

    it "should not be able to authenticate" do
      client.api_key = "DUMMY KEY"
      client.valid_credentials?.should eq(false)
    end

    it "empty authentication parameters should not be allowed" do
      client.api_key = nil
      reply = client.company_lookup({})
      reply.status.should eq(:error)
    end
  end

  
  describe "company lookup" do

    let(:company) { 
      Iprofiler::Mash.new(
        :name=>"Bank Of America", 
        :type=>:company, 
        :industry=>"Financial Services", 
        :url=>"bankofamerica.com", 
        :employees=>272600, 
        :email => "foo@boa.com",
        :ip_address => "12.13.77.156",
        :employee_range=>"More than 50,000"
      )
    }

    let(:customer_request_id) { "foo bar 28383"}

    it "should be able to query using company name" do
      reply = client.company_lookup(:company_name => company.name)
      reply.code.should eq(200)
      reply.status.should eq(:found)
    end

    it "should be able to query using domain name" do
      reply = client.company_lookup(:domain => company.url)
      reply.code.should eq(200)
      reply.status.should eq(:found)
    end

    it "should be able to query using ip address" do
      reply = client.company_lookup(:ip_address => company.ip_address)
      reply.code.should eq(200)
      reply.status.should eq(:found)
    end

    it "should be able to query using employee email id" do
      reply = client.company_lookup(:email => company.email)
      reply.code.should eq(200)
      reply.status.should eq(:found)
    end

    it "should not be able to query using empty parameters" do
      reply = client.company_lookup({})
      reply.code.should eq(200)
      reply.status.should_not eq(:found)
    end

    it "should return request closures" do
      reply = client.company_lookup(
        :company_name => company.name,
        :domain => company.url,
        :ip_address => company.ip_address, 
        :email => company.email,
        :customer_request_id => customer_request_id
      )
      reply.company_name.should eq(company.name)
      reply.domain.should eq(company.url)
      reply.ip_address.should eq(company.ip_address)
      reply.email.should eq(company.email)
      reply.customer_request_id.should eq(customer_request_id)
    end
  end

end
