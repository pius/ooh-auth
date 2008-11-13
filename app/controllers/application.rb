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
  
end