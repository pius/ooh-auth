class MerbAuthSliceFullfat::Sessions < MerbAuthSliceFullfat::Application

  # Ignore me, just passing through. Hee hee.
  def index; new; end
  
  # Render a login form allowing the user to authenticate through merb-auth-more's
  # salted_user auth mixin.
  def new
    render
  end
  
  # Actually create the session based on user response.
  def create
    provides :html, :json, :xml, :yaml
    
    case content_type
    when :html
      @user = session.authenticate!(request, params)
    else
      basic_authentication.request!
      ""
    end
  end
  
  # Destroy the session, logging the user out.
  def destroy
    session.abandon!
  end
  
end
