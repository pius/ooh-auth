class MerbAuthSliceFullfat::Application < Merb::Controller
  
  controller_for_slice
  
  private
  def user_class
    Merb::Authentication.user_class
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
  
end