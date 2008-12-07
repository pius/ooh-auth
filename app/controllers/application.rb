class OohAuth::Application < Merb::Controller
  
  controller_for_slice
  
  private
  def user_class
    Merb::Authentication.user_class
  end  

  # Can be removed once http://merb.lighthouseapp.com/projects/7433/tickets/956-patch-add-message-support
  # is merged.
  def message=(arg)
    @_message = arg
  end
  
end