class MerbAuthSliceFullfat::PasswordResets < MerbAuthSliceFullfat::Application

  def index; new; end

  # Render a form allowing the user to start the password reset procedure.
  def new
    render(:new)
  end
  
  # Allow the user to create a password reset associated with their account.
  # Expects a parameter set in MerbAuthSliceFullfat[:password_reset_identifier_field]
  # which is used to identify the user. By default this is :email.
  def create
    @for_user = User.first user_identifier => params[user_identifier]
    @password_reset = PasswordReset.new_for_user(@for_user)
    render
  end
  
  # Finds a specific password reset and displays a form allowing the user to set
  # a new password.
  def show
    @password_reset = PasswordReset.find_by_key(params[:key])
  end
  
  # Consumes a password reset for a given user
  def update
    
  end
  
  # Destroys a password reset based on passphrase WITHOUT changing the user's password.
  # Effectively, cancels the password reset procedure.
  def destroy
    
  end
  
  private
  def user_identifier
    MerbAuthSliceFullfat[:password_reset_identifier_field]
  end
  
end
