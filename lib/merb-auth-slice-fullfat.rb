if defined?(Merb::Plugins)

  $:.unshift File.dirname(__FILE__)

  load_dependency "merb-action-args"
  load_dependency 'merb-auth-core'
  load_dependency 'merb-auth-more'
  load_dependency 'merb-slices'
  load_dependency "merb-helpers"
  load_dependency "merb-assets"
  
  Merb::Plugins.add_rakefiles "merb-auth-slice-fullfat/merbtasks", "merb-auth-slice-fullfat/slicetasks", "merb-auth-slice-fullfat/spectasks"

  # Register the Slice for the current host application
  Merb::Slices::register(__FILE__)
  
  # Slice configuration - set this in a before_app_loads callback.
  # By default a Slice uses its own layout, so you can swicht to 
  # the main application layout or no layout at all if needed.
  # 
  # Configuration options:
  # :layout - the layout to use; defaults to :merb-auth-slice-fullfat
  # :mirror - which path component types to use on copy operations; defaults to all.  
  Merb::Slices::config[:merb_auth_slice_fullfat][:layout] ||= :merb_auth_slice_fullfat
  Merb::Slices::config[:merb_auth_slice_fullfat].merge!({
    :path_prefix=>"auth",
    # Authenticating clients can ask for a certain level of permissions chosen from a list. You can alter that list below:
    :client_permission_levels =>  {
      :read=>   {:description=>"This application will be able to read your content, but not to alter it or create new information in your content."},
      :write=>  {:description=>"This application will be able to both read and make changes to your content, but not to delete it."},
      :delete=> {:description=>"This application will have full access to your content, including the ability to delete it."}
    },
    # If no permission level is specifically requested during the auth process, the client will be granted:
    :default_permissions      =>"write".freeze,
    # Reserved for now
    :client_kinds=>%w(web desktop)
  })
  
  # SliceRestful uses merb-auth-more's configuration options:
  # Merb::Plugins.config[:"merb-auth"][:new_session_param] => key to use when looking up the LOGIN in requests.
  # Merb::Plugins.config[:"merb-auth"][:password_param] => key to use when looking up the PASSWORD in requests.
  # Merb::Authentication.user_class => the class to use when calling #authenticate on your user model.

  
  # All Slice code is expected to be namespaced inside a module
  module MerbAuthSliceFullfat
    
    # Slice metadata
    self.description = "MerbAuthSliceFullfat is Merb slice that extends merb-auth-more with RESTful authentication"
    self.version = "0.0.1"
    self.author = "Dan Glegg"
    self.identifier = "merb-auth-slice-fullfat"
    
    # Stub classes loaded hook - runs before LoadClasses BootLoader
    # right after a slice's classes have been loaded internally.
    def self.loaded
    end
    
    # Initialization hook - runs before AfterAppLoads BootLoader
    def self.init
      require "merb-auth-slice-fullfat/authentication_mixin"
      require "merb-auth-slice-fullfat/key_generators"
      require "merb-auth-slice-fullfat/request_verification_mixin.rb"
      require "merb-auth-slice-fullfat/controller_mixin.rb"
      require "merb-auth-slice-fullfat/strategies/oauth.rb"
      Merb::Request.send(:include, MerbAuthSliceFullfat::Request::VerificationMixin)
      Merb::Controller.send(:include, MerbAuthSliceFullfat::ControllerMixin)
      
      # Register strategies
      Merb::Authentication.register :oauth, "merb-auth-slice-fullfat/strategies/oauth.rb"
      Merb::Authentication.activate! :oauth
      
      unless MerbAuthSliceFullfat[:no_default_strategies]
        ::Merb::Authentication.activate!(:default_password_form)
      end
    end
    
    # Activation hook - runs after AfterAppLoads BootLoader
    def self.activate
    end
    
    # Deactivation hook - triggered by Merb::Slices.deactivate(MerbAuthSliceFullfat)
    def self.deactivate
    end
    
    # Add the following to your app's router to mount SliceRestful at the root:
    # Merb::Router.prepare do
    #   slice( :MerbAuthSliceFullfat, :name_prefix => nil, :path_prefix => "auth", :default_routes => false )
    # end
    def self.setup_router(scope)
      scope.resources :authenticating_clients
      scope.resources :tokens
      scope.default_routes
    end
    
  end
  
  MerbAuthSliceFullfat.setup_default_structure!
  
  # Add dependencies for other MerbAuthSliceFullfat classes below. Example:
  
  
end