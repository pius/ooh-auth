class PasswordReset
  include DataMapper::Resource
  
  property :id, Serial
  property :passphrase, String
  property :created_at, DateTime
  property :user_id, Integer
  
  # A password reset is a small token with a long alphanumeric passphrase associated with it.
  # An unauthenticated user may consume a PasswordReset in order to change their password.
  # Important behavioural details:
  # - Creating a new password reset for a user will destroy all prior resets for that user.
    before :save, :"clear_history_for_saving!"
    before :save, :"set_unique_passphrase!"
  # - Creation and consumption of these objects drives the generation of user password mail.
    after :save,    :mail_link
    after :destroy, :mail_new_password
    
  # Finds the most recent valid PasswordReset for the given user.
  def self.find_by_passphrase(p)
    self.first(:passphrase => p)
  end
  # Creates a new reset for the given user.
  def self.new_for_user(u)
    create :user_id=>u.id
  end
    
  # Emails the user with a link to reset their password.
  def mail_link
    # TODO
  end
  
  # Emails the user their new password once the reset is complete.
  def mail_new_password
    # TODO
  end
  
  # Creates a unique passphrase
  def self.unique_passphrase
    p = ""
    while (p=="" or first(:passphrase=>p)) do
      p = User.generate_password(50)
    end
    return p
  end
  # Sets a unique passphrase in-place unless one was specified.
  def set_unique_passphrase!
    self.passphrase ||= self.class.unique_passphrase
  end
  
  # Destroys all previously saved PasswordResets relating to the same user
  # as this one.
  def clear_history_for_saving!
    return nil if !self.user
    PasswordReset.all(:user_id =>self.user_id).destroy!
  end

end