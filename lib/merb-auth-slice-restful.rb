if defined?(Merb::Plugins)

  $:.unshift File.dirname(__FILE__)

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
  # :mirror - which path component types to use on copy operations; defaults to all
  Merb::Slices::config[:merb_auth_slice_restful][:layout] ||= :merb_auth_slice_restful
  
  # All Slice code is expected to be namespaced inside a module
  module MerbAuthSliceRestful
    
    # Slice metadata
    self.description = "MerbAuthSliceRestful is Merb slice that extends merb-auth-more with RESTful authentication"
    self.version = "0.0.1"
    self.author = "Engine Yard"
    
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
    
    # Setup routes inside the host application
    #
    # @param scope<Merb::Router::Behaviour>
    #  Routes will be added within this scope (namespace). In fact, any 
    #  router behaviour is a valid namespace, so you can attach
    #  routes at any level of your router setup.
    #
    # @note prefix your named routes with :merb_auth_slice_restful_
    #   to avoid potential conflicts with global named routes.
    def self.setup_router(scope)
      # example of a named route
      scope.match("/login", :method => :get ).to(:controller => "sessions",     :action => "new"            ).name(:login)
      scope.match("/login", :method => :put ).to(:controller => "sessions",     :action => "update"         ).name(:perform_login)
      scope.match("/logout"                 ).to(:controller => "sessions",     :action => "destroy"        ).name(:logout)
    end
    
  end
  
  # Setup the slice layout for MerbAuthSliceRestful
  #
  # Use MerbAuthSliceRestful.push_path and MerbAuthSliceRestful.push_app_path
  # to set paths to merb-auth-slice-restful-level and app-level paths. Example:
  #
  # MerbAuthSliceRestful.push_path(:application, MerbAuthSliceRestful.root)
  # MerbAuthSliceRestful.push_app_path(:application, Merb.root / 'slices' / 'merb-auth-slice-restful')
  # ...
  #
  # Any component path that hasn't been set will default to MerbAuthSliceRestful.root
  #
  # Or just call setup_default_structure! to setup a basic Merb MVC structure.
  MerbAuthSliceRestful.setup_default_structure!
  
  # Add dependencies for other MerbAuthSliceRestful classes below. Example:
  # dependency "merb-auth-slice-restful/other"
  
end