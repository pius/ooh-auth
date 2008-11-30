module MerbAuthSliceFullfat
  module ControllerMixin
        
    # Raises a NotAcceptable (HTTP 406) unless the request is satisfactorily signed by
    # an authenticating client.
    def ensure_signed
      raise Merb::Controller::NotAcceptable unless request.signed?
    end
    
    # Raises a Forbidden (HTTP 403) unless the request carries the desired authorisation or above.
    # Special notes: permission levels are taken from MerbAuthSliceFullfat[:client_permission_levels] in order. A call to 
    # ensure_authorisation(:write) will by default return true, for example, if the current request is authorised with :write 
    # or :delete, as :delete is more powerful than :write. 
    # A special level named :root is available. A call to ensure_authorisation with :root as an argument will ensure that the
    # user herself is currently authenticated, rather than one of her authorised agents.
    # ensure_authorisation(:root) is therefore a suitable choice for protecting user profile forms, password change forms and 
    # other similar content.
    def ensure_authorisation(level=:root)
      keys = MerbAuthSlicePassword[:client_permission_levels].keys
      raise Merb::Controller::Forbidden unless (
        (level == :root and !request.api_request?) or
        (keys.index(level) > keys.index(authorisation_level))
      )
    end
        
  end
end