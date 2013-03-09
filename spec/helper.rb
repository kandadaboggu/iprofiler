$:.unshift File.expand_path('..', __FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)
require 'simplecov'
SimpleCov.start
require 'iprofiler'
require 'rspec'
require 'webmock/rspec'
require 'vcr'

VCR.configure do |c|
  c.register_request_matcher(:uri_without_epoch_and_signature, 
   &VCR.request_matchers.uri_without_param(:epoch, :signature))
  c.cassette_library_dir     = File.join("./", "fixtures", "cassette_library")
  c.hook_into                :webmock # or :fakeweb
  c.ignore_localhost         = false
  c.default_cassette_options = { :match_requests_on => [:method, :uri_without_epoch_and_signature]}
  c.configure_rspec_metadata!
  # c.default_cassette_options = { :record => :none }
end


RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
end
