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

  # Make common params available to controllers
  [:return_to_param, :default_return_to, :api_key_param, :api_token_param, :api_signature_param, :api_receipt_param].each do |key|
    define_method key do
	    Merb::Slices::config[:merb_auth_slice_fullfat][key]
    end
  end
  
  # Can be removed once http://merb.lighthouseapp.com/projects/7433/tickets/956-patch-add-message-support
  # is merged.
  def message=(arg)
    @_message = arg
  end
  
end