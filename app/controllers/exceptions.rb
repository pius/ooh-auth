# the mixin to provide the exceptions controller action for Unauthenticated
#class Application < Merb::Controller; end
#class Exceptions < Application; end

module MerbAuthSliceFullfat::ExceptionsMixin
  
  # Catch unauthenticated requests and handle the exception.
  # HTML requests should be redirected to the login form with a ?return_to param for the current uri
  # JS, JSON, XML and YAML requests should respond with a straight 403 header
  def unauthenticated
    provides :html, :xml, :json, :yaml
    case content_type
    when :html
      return_to_key = MerbAuthSliceFullfat[:return_to_param]
      redirect  url(:new_merb_auth_slice_fullfat_session, return_to_key=>(params[return_to_key] or request.uri))
    else
      basic_authentication.request!
      ""
    end
  end
  
end

Merb::Authentication.customize_default do  
  Exceptions.class_eval do
    include Merb::Slices::Support # Required to provide slice_url
  
    # # This stuff allows us to provide a default view
    the_view_path = File.expand_path(File.dirname(__FILE__) / ".." / "views")
    self._template_roots ||= []
    self._template_roots << [the_view_path, :_template_location]
    self._template_roots << [Merb.dir_for(:view), :_template_location]
    
    include MerbAuthSliceFullfat::ExceptionsMixin
    
    show_action :unauthenticated
  
  end
end