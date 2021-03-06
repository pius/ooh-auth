require 'rubygems'
require 'merb-core'
require 'merb-slices'
require 'spec'

# Add ooh-auth.rb to the search path
Merb::Plugins.config[:merb_slices][:auto_register] = true
Merb::Plugins.config[:merb_slices][:search_path]   = File.join(File.dirname(__FILE__), '..', 'lib', 'ooh-auth.rb')
require Merb::Plugins.config[:merb_slices][:search_path]

# Using Merb.root below makes sure that the correct root is set for
# - testing standalone, without being installed as a gem and no host application
# - testing from within the host application; its root will be used
Merb.start_environment(
  :testing => true, 
  :adapter => 'runner', 
  :environment => ENV['MERB_ENV'] || 'test',
  :session_store => 'memory'
)

module Merb
  module Test
    module SliceHelper
      
      # The absolute path to the current slice
      def current_slice_root
        @current_slice_root ||= File.expand_path(File.join(File.dirname(__FILE__), '..'))
      end
      
      # Whether the specs are being run from a host application or standalone
      def standalone?
        #raise StandardError, "Merb.root #{Merb.root.inspect} ::OohAuth.root #{::OohAuth.root.inspect}"
        File.join(Merb.root, "") == File.join(::OohAuth.root, "")
      end
      
	    def user_class
	      Merb::Authentication.user_class
      end
  	  
  	  def noko(document)
        Nokogiri::HTML(document)
      end
	    
	    # Produces a signed FakeRequest ready to be used when testing any action that requires signing.
	    def request_signed_by(client, get_params={}, post_params={}, env={}, opts={})
	      raise RuntimeError, "client #{client.inspect} is not a saved record, has errors #{client.errors.inspect}" if client.new_record?
	      get_params = {
	        :oauth_consumer_key=>client.api_key
	      }.merge(get_params)
	      # Prepare headers
        env = {
          :request_method => "GET",
          :http_host => "test.fullfat.com", 
          :request_uri=>"/secrets/"
	      }.merge(env)
	      env[:query_string] = get_params.collect{|k,v| "#{k}=#{v}"}.join("&")
	      # Extras
	      opts = {
	        :post_body=>post_params.collect{|k,v| "#{k}=#{v}"}.join("&")
	      }.merge(opts)
        
        unsigned = fake_request(env, opts)        
        get_params[:oauth_signature] ||= Merb::Parse.escape(unsigned.build_signature)
        env[:query_string] = get_params.collect{|k,v| "#{k}=#{v}"}.join("&")
        
        signed = fake_request(env, opts)
        #raise RuntimeError, "Request not properly signed. Got: #{signed.uri}?#{signed.params.collect{|k,v|"#{k}=#{v}"}.join("&")}, expected: #{signed.signature_base_string} / #{signed.signature_secret}" unless signed.signed?
        #signed
      end
      
      # Signs a URL like "/controller/action" with the correct signature to avoid triggering the
      # ensure_signed filter method.
      def sign_url_with(client, url, params={})
        signed = request_signed_by(client, params, {}, {:request_uri=>url, :http_host=>"localhost"})
        return "#{signed.uri}?#{signed.query_string}"
      end
      
	    # Override for buggy freaking redirect_to assertion in merb 0.9.11.
      # duplicates syntax of old version, so can be safely removed once
      # http://merb.lighthouseapp.com/projects/7433-merb/tickets/949-redirect_to-assertion-errors-on-success-under-some-setups
      # is fixed.
      def redirect_to(url)
        simple_matcher("redirect to #{url.inspect}") do |controller, matcher|
          actual_url = controller.rack_response[1]["Location"]
          matcher.failure_message = "expected to be redirected to #{url.inspect} but instead was redirected to #{actual_url.inspect}"
          actual_url == url
        end
      end
	          
    end
  end
end

# this loads all plugins required in your init file so don't add them
# here again, Merb will do it for you
#Merb.start_environment(:testing => true, :adapter => 'runner', :environment => ENV['MERB_ENV'] || 'test')
# Migrate that shit
DataMapper.auto_migrate!
# Load fixtures
require File.join(File.dirname(__FILE__), 'spec_fixtures')

Spec::Runner.configure do |config|
  config.include(Merb::Test::ViewHelper)
  config.include(Merb::Test::RouteHelper)
  config.include(Merb::Test::ControllerHelper)
  config.include(Merb::Test::SliceHelper)
end