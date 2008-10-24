# the mixin to provide the exceptions controller action for Unauthenticated
module MerbAuthSliceRestful::ExceptionsMixin
  
  # Catch unauthenticated users and redirect them to the sessions controller
  def unauthenticated
    ""
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
    
    include MerbAuthSliceRestful::ExceptionsMixin
    
    show_action :unauthenticated
  
  end
end