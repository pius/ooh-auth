class MerbAuthSliceFullfat::PasswordResets < MerbAuthSliceFullfat::Application

  def index; new; end

  # Render a form allowing the user to start the password reset procedure.
  def new
    render(:new)
  end
  
  # Allow the user to create a password reset associated with their account.
  def create
    render
  end
  
  
  def show
    
  end
  
end
