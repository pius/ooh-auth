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
  
  # Finds a specific password reset and displays a form allowing the user to set
  # a new password.
  def show
    
  end
  
  # Consumes a password reset for a given user
  def update
    
  end
  
  # Destroys a password reset based on passphrase WITHOUT changing the user's password.
  # Effectively, cancels the password reset procedure.
  def destroy
    
  end
  
end
