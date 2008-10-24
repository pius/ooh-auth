if defined?(Merb::Plugins)

  $:.unshift File.dirname(__FILE__)

  load_dependency 'merb-auth-core'
  load_dependency 'merb-auth-more'
  load_dependency 'merb-slices'
  Merb::Plugins.add_rakefiles "merb-auth-slice-restful/merbtasks", "merb-auth-slice-restful/slicetasks", "merb-auth-slice-restful/spectasks"

  # Register the Slice for the current host application
  Merb::Slices::register(__FILE__)
  
  # Slice configuration - set this in a before_app_loads callback.
  # By default a Slice uses its own layout, so you can swicht to 
  # the main application layout or no layout at all if needed.
  # 
  # Configuration options:
  # :layout - the layout to use; defaults to :merb-auth-slice-restful
  # :mirror - which path component types to use on copy operations; defaults to all.  
  Merb::Slices::config[:merb_auth_slice_restful][:layout] ||= :merb_auth_slice_restful
  Merb::Slices::config[:merb_auth_slice_restful].merge!({
    :return_to_param  =>  :return_to # key to use when pulling the return url from login and logout links.
  })
  # SliceRestful uses merb-auth-more's configuration options:
  # Merb::Plugins.config[:"merb-auth"][:password_param] => key to use when looking up the LOGIN in requests.
  # Merb::Plugins.config[:"merb-auth"][:password_param] => key to use when looking up the PASSWORD in requests.
  # Merb::Authentication.user_class => the class to use when calling #authenticate on your user model.

  
  # All Slice code is expected to be namespaced inside a module
  module MerbAuthSliceRestful
    
    # Slice metadata
    self.description = "MerbAuthSliceRestful is Merb slice that extends merb-auth-more with RESTful authentication"
    self.version = "0.0.1"
    self.author = "Dan Glegg"
    
    # Stub classes loaded hook - runs before LoadClasses BootLoader
    # right after a slice's classes have been loaded internally.
    def self.loaded
    end
    
    # Initialization hook - runs before AfterAppLoads BootLoader
    def self.init
    end
    
    # Activation hook - runs after AfterAppLoads BootLoader
    def self.activate
    end
    
    # Deactivation hook - triggered by Merb::Slices.deactivate(MerbAuthSliceRestful)
    def self.deactivate
    end
    
    def self.setup_router(scope)
      Merb::Router.prepare do
        match("/login", :method => :get ).to(:controller => "merb_auth_slice_restful/sessions",     :action => "new"            ).name(nil, :login)
        match("/login", :method => :post).to(:controller => "merb_auth_slice_restful/sessions",     :action => "create"         ).name(nil, :authenticate)
        match("/logout"                 ).to(:controller => "merb_auth_slice_restful/sessions",     :action => "destroy"        ).name(nil, :logout)
      end
    end
    
  end
  
  MerbAuthSliceRestful.setup_default_structure!
  
  # Add dependencies for other MerbAuthSliceRestful classes below. Example:
  # dependency "merb-auth-slice-restful/other"
  
end