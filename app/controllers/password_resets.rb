class MerbAuthSliceFullfat::PasswordResets < MerbAuthSliceFullfat::Application

  def index; new; end

  # Render a form allowing the user to start the password reset procedure.
  def new
    @password_reset = MerbAuthSliceFullfat::PasswordReset.new
    render(:new)
  end
  
  # Allow the user to create a password reset associated with their account.
  # Expects a parameter set in MerbAuthSliceFullfat[:password_reset_identifier_field]
  # which is used to identify the user. By default this is :email.
  def create
    @for_user = user_class.first user_identifier => params[user_identifier]
    @password_reset = MerbAuthSliceFullfat::PasswordReset.create_for_user(@for_user)
    if @password_reset.valid?
      # Reset was successfully created. We'll render the page for the created reset.
      # We do this with a 201 CREATED status code, and to comply properly with HTTP     
      # we include the resource location in the location header.
      headers['Location'] = slice_url(:password_reset, @password_reset)
      render(:show, :status=>201)
    else
      # Oh dear, incorrect login was entered.
      # Set a message and render the form again with a 'not found' response code
      @_message = "Sorry, but we couldn't find you in our records. Are you sure you entered the correct details?"
      render(:new, :status=>404)
    end
  end
  
  # Finds a specific password reset and displays a form allowing the user to set
  # a new password.
  def show
    @password_reset = MerbAuthSliceFullfat::PasswordReset.find_by_identifier(params[:identifier])
    render
  end
  
  # Consumes a password reset for a given user
  def update
    
  end
  
  # Destroys a password reset based on passphrase WITHOUT changing the user's password.
  # Effectively, cancels the password reset procedure.
  def destroy
    @password_reset = MerbAuthSliceFullfat::PasswordReset.find_by_identifier(params[:identifier])
    @password_reset.destroy
  end
  
  private
  def user_identifier
    MerbAuthSliceFullfat[:password_reset_identifier_field]
  end
  
end
