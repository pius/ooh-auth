require 'rubygems'
require 'merb-core'
require 'merb-slices'
require 'spec'

# Add merb-auth-slice-fullfat.rb to the search path
Merb::Plugins.config[:merb_slices][:auto_register] = true
Merb::Plugins.config[:merb_slices][:search_path]   = File.join(File.dirname(__FILE__), '..', 'lib', 'merb-auth-slice-fullfat.rb')
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
        #raise StandardError, "Merb.root #{Merb.root.inspect} ::MerbAuthSliceFullfat.root #{::MerbAuthSliceFullfat.root.inspect}"
        File.join(Merb.root, "") == File.join(::MerbAuthSliceFullfat.root, "")
      end
      
      def login_param
        Merb::Authentication::Strategies::Basic::Base.login_param
      end      
    	def password_param
    	  Merb::Authentication::Strategies::Basic::Base.password_param
  	  end
  	  
  	  def password_reset_identifier_field
  	    Merb::Slices::config[:merb_auth_slice_fullfat][:password_reset_identifier_field]
	    end
  	  def return_to_param
    	  Merb::Slices::config[:merb_auth_slice_fullfat][:return_to_param]
  	  end
  	  def default_return_to
  	    Merb::Slices::config[:merb_auth_slice_fullfat][:default_return_to]
	    end
	    
	    def user_class
	      Merb::Authentication.user_class
      end
  	  
  	  def noko(document)
        Nokogiri::HTML(document)
      end
  	
  	  # Authenticate a user using normal session auth, and then execute the block given
  	  def with_session_in(*controllers, &block)
  	    
	    end
	    
	    # Produces a signed FakeRequest ready to be used when testing any action that requires signing.
	    def request_signed_by(client, get_params={}, post_params={}, env={}, opts={})
	      get_params = {
	        "api_key"=>client.api_key
	      }.merge(get_params)
        env = {
          :request_method => "GET",
          :http_host => "test.fullfat.com", 
          :request_uri=>"/secret/"
	      }.merge(env)
	      opts = {
	        :post_body=>post_params.collect{|k,v| "#{k}=#{v}"}.join("&")
	      }.merge(opts)
        
        all_params = get_params.merge(post_params)
        get_params[:api_signature] = Digest::SHA1.hexdigest("#{client.secret}#{env[:request_method].downcase}http#{env[:http_host]}#{env[:request_uri]}#{all_params.keys.sort.join("")}#{all_params.values.sort.join("")}")
	      env[:query_string] = get_params.collect{|k,v| "#{k}=#{v}"}.join("&")
        
        fake_request(env, opts)
      end
      
      # Signs a URL like "/controller/action" with the correct signature to avoid triggering the
      # ensure_signed filter method.
      def sign_url_with(client, url, params={})
        defaults = Merb::Test::RequestHelper::FakeRequest.new
        params = {
          "api_key"=>client.api_key
        }.merge(params)
        params[:api_signature] ||= Digest::SHA1.hexdigest(sig = "#{client.secret}#{defaults.method}http#{defaults.host}#{url}#{params.keys.sort.join("")}#{params.values.sort.join("")}")
        param_string = params.collect{|k,v| "#{k}=#{v}"}.join("&")
        url = "#{url}?#{param_string}"
        #raise RuntimeError, {:plain_sig=>sig, :url=>url}.inspect
        return url
      end
      
      # Signs a URL
  	
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