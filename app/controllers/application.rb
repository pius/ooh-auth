class MerbAuthSliceFullfat::Application < Merb::Controller
  
  controller_for_slice
  
  private
  def user_class
    Merb::Authentication.user_class
  end
  
end