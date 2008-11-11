require 'rubygems'
require 'merb-core'
require 'merb-auth-core'
require 'merb-auth-more'
require 'merb-slices'
require 'spec'

# Add merb-auth-slice-fullfat.rb to the search path
Merb::Plugins.config[:merb_slices][:auto_register] = true
Merb::Plugins.config[:merb_slices][:search_path]   = File.join(File.dirname(__FILE__), '..', 'lib', 'merb-auth-slice-fullfat.rb')

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
  	  def return_to_param
    	  Merb::Slices::config[:merb_auth_slice_fullfat][:return_to_param]
  	  end
  	  def default_return_to
  	    Merb::Slices::config[:merb_auth_slice_fullfat][:default_return_to]
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